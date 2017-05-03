open Expr
open Printf
let problem_free = ref true

let rec expr_to_string (e : expr) : string =
  match e with
  | App (e1, e2) ->
      sprintf "(%s) (%s)" (expr_to_string e1) (expr_to_string e2)
  | Conditional (e1, e2, eo) ->
      let a = sprintf "if %s then %s" (expr_to_string e1) (expr_to_string e2) in
      begin match eo with
      | Some e -> a ^ (sprintf " else %s" (expr_to_string e))
      | None -> a end
  | Cons (e1, e2) ->
      sprintf "%s :: %s" (expr_to_string e1) (expr_to_string e2)
  | Const v -> v
  | Fun (v, e) ->
      sprintf "fun %s -> %s" v (expr_to_string e)
  | Infix (o, e1, e2) ->
      sprintf "(%s) %s (%s)" (expr_to_string e1) o (expr_to_string e2)
  | Let (v, e) ->
      sprintf "let %s = %s" v (expr_to_string e)
  | LetIn (v, e1, e2) ->
      sprintf "let %s = %s in %s" v (expr_to_string e1) (expr_to_string e2)
  | LetRec (v, e) ->
      sprintf "let rec %s = %s" v (expr_to_string e)
  | LetRecIn (v, e1, e2) ->
      sprintf "let rec %s = %s in %s" v (expr_to_string e1) (expr_to_string e2)
  | Match (e1, e2) ->
      sprintf "match %s with %s" (expr_to_string e1) (expr_to_string e2)
  | MCons (e1, e2, e3) ->
      sprintf "| %s -> %s %s" (expr_to_string e1) (expr_to_string e2)
                              (expr_to_string e3)
  | MNil -> ""
  | Nil -> "[]"
  | Prefix (o, e) -> sprintf "%s (%s)" o (expr_to_string e)
  | Raise -> ""
  | TCons (e1, e2) -> sprintf "%s, %s" (expr_to_string e1) (expr_to_string e2)
  | TNil -> ""
  | Unassigned -> ""
  | Var v -> v

let rec find_singular_match (e : expr) : unit =
  let rec depth (e : expr) : int =
    match e with
    | MNil -> 0
    | MCons (_, _, n) -> 1 + depth n
    | _ -> 0 in
  match e with
  | Match (e1, e2) ->
      let d = depth e2 in
      if d = 1 then
        begin
          print_endline ("Warning: singular match statement at "
                         ^ "\"match " ^ (expr_to_string e1) ^ " with\"."
                         ^ " Consider using let instead") ;
          problem_free := false
        end
      else () ;
      find_singular_match e1 ;
      find_singular_match e2
  | Fun (_v, e) | Let (_v, e) | LetRec (_v, e) | Prefix (_v, e) ->
      find_singular_match e
  | Infix (_v, e1, e2) | LetIn (_v, e1, e2) | LetRecIn (_v, e1, e2) ->
      find_singular_match e1 ; find_singular_match e2
  | App (e1, e2) | Cons (e1, e2) | TCons (e1, e2) ->
      find_singular_match e1 ; find_singular_match e2
  | MCons (e1, e2, e3) ->
      find_singular_match e1 ;
      find_singular_match e2 ;
      find_singular_match e3
  | Conditional (e1, e2, eo) ->
      find_singular_match e1 ;
      find_singular_match e2 ;
      begin match eo with
      | Some e3 -> find_singular_match e3
      | None -> () end
  | Const _ | MNil | Nil | Raise | TNil | Unassigned | Var _ -> ()

(* let rec crawl_ast (e : expr) : unit =
  match e with
  | Var v -> ()
  | Conditional (e1, e2, eo) -> ()
  | Fun (v, e) -> ()
  | Let (v, e) -> ()
  | LetIn (v, e1, e2) -> ()
  | LetRec (v, e) -> ()
  | LetRecIn (v, e1, e2) -> ()
  | Raise -> ()
  | App (e1, e2) -> ()
  | Cons (e1, e2) -> ()
  | Nil -> ()
  | Prefix (s, e) -> ()
  | Infix (s, e1, e2) -> ()
  | Match (e1, e2) -> crawl_ast e1; crawl_ast e2
  | MNil -> ()
  | MCons (e1, e2, e3) ->
      match e3 with
      | MNil -> printf "Warning: single match statement"
      | MCons (_, _, _) -> ()
      | _ -> failwith "Impossible: not MCons in MCons"
  | Const v -> ()
  | Unassigned -> ()
;; *)
