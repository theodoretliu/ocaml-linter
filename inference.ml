(******************************************
 * Type inference for simple lambda terms *
 ******************************************)
open Expr ;;
open Unification ;;
open Builtins ;;

exception Unbound_value of string

type aexpr =
  | AFun of varid * aexpr * typing
  | ALet of varid * aexpr * typing
  | ALetIn of varid * aexpr * aexpr * typing
  | AApp of aexpr * aexpr * typing
  | AVar of varid * typing
  | AConst of typing
  | ANil of typing
  | ACons of aexpr * aexpr * typing
  | ATuple of aexpr list * typing
  | AInfix of varid * aexpr * aexpr * typing

let code = ref 0

let reset_type_vars () = code := 0

let next_type_var () : typing =
  incr code;
  TVar (string_of_int !code)

let type_of (ae : aexpr) : typing =
  match ae with
  | AVar (_, a) -> a
  | AFun (_, _, a) -> a
  | ALet (_, _, a) -> a
  | ALetIn (_, _, _, a) -> a
  | AApp (_, _, a) -> a
  | AConst a -> a
  | ACons (_ ,_, a) -> a
  | ANil a -> a
  | ATuple (_, a) -> a
  | AInfix (_, _, _, a) -> a

let last_el (lst : 'a list) : 'a =
  match lst with
  | [] -> raise (Invalid_argument "last_el: empty list")
  | h :: t -> List.fold_left (fun _ x -> x) h t

(* annotate all subexpressions with types *)
(* bv = stack of bound variables for which current expression is in scope *)
(* fv = hashtable of known free variables *)
let annotate (e : expr) : aexpr =
  let (h : (varid, typing) Hashtbl.t) = Hashtbl.create 16 in
  let rec annotate' (e : expr) (bv : (varid * typing) list) : aexpr =
    match e with
    | Var x ->
        (* bound variable? *)
        (try let a = List.assoc x bv in AVar (x, a)
        (* known free variable? *)
        with Not_found -> try let a = Hashtbl.find h x in AVar (x, a)
        (* unknown free variable *)
        with Not_found -> let a = next_type_var () in Hashtbl.add h x a; AVar (x, a))
    | Fun (x, e) ->
        (* assign a new type to x *)
        let a = next_type_var () in
        let ae = annotate' e ((x, a) :: bv) in
        AFun (x, ae, TArrow (a, type_of ae))
    | App (e1, e2) ->
        let a = next_type_var () in
        AApp (annotate' e1 bv, annotate' e2 bv, a)
    | Const s -> AConst (TVar s)
    | Let (x, e) ->
        let a = next_type_var () in
        let ae = annotate' e ((x, a) :: bv) in
        Hashtbl.add h x (type_of ae);
        ALet (x, ae, type_of ae)
    | LetIn (x, e1, e2) ->
        let a = next_type_var () in
        let ae1 = annotate' e1 ((x, a) :: bv) in
        let ae2 = annotate' e2 ((x, type_of ae1) :: bv) in
        ALetIn (x, ae1, ae2, type_of ae2)
    | Cons (h, t) ->
        let ah = annotate' h bv in
        let at = annotate' t bv in
        ACons (ah, at, TStruct ("list", type_of ah))
    | Nil ->
        ANil (TStruct ("list", next_type_var ()))
    | Tuple l ->
        let aexprs = List.map (fun x -> annotate' x bv) l in
        let types = List.map type_of aexprs in
        ATuple (aexprs, TTuple types)
    | Infix (x, e1, e2) ->
          let a = next_type_var () in
          AInfix (x, annotate' e1 bv, annotate' e2 bv, a)

  in annotate' e []

(* collect constraints for unification *)
let rec collect (aexprs : aexpr list) (u : (typing * typing) list) : (typing * typing) list =
  match aexprs with
  | [] -> u
  | AVar (_, _) :: r | AConst _ :: r | ANil _ :: r ->
      collect r u
  | AFun (_, ae, _) :: r | ACons (_, ae, _) :: r  | ALet (_, ae, _) :: r ->
      collect (ae :: r) u
  | ALetIn (_, ae1, ae2, b) :: r ->
      collect (ae1 :: ae2 :: r) u
  | AApp (ae1, ae2, a) :: r ->
      let (f, b) = (type_of ae1, type_of ae2) in
      collect (ae1 :: ae2 :: r) ((f, TArrow (b, a)) :: u)
  | ATuple (aes, types) :: r ->
      collect (aes @ r) u
  | AInfix (s, ae1, ae2, a) :: r ->
      try
        let unknowns = [type_of ae1; type_of ae2; a] in
        let knowns = Hashtbl.find built_ins s in
        let additions = List.map2 (fun x y -> (x, y)) unknowns knowns in
        collect (ae1 :: ae2 :: r) (additions @ u)
      with Not_found ->
        let (f, b) = (type_of ae1, type_of ae2) in
        collect (ae1 :: ae2 :: r) ((f, TArrow (b, a)) :: u)


(* collect the constraints and perform unification *)
let infer (e : expr) : typing =
  reset_type_vars ();
  let ae = annotate e in
  let cl = collect [ae] [] in
  let s = Unification.unify_list cl in
  Unification.apply_env s (type_of ae)
