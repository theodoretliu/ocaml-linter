
type varid = string

type typing =
  | TVar of varid
  | TSpec of string * typing
  | TArrow of typing * typing

type environment = (varid * typing) list

(* If in b we have Var id, substitute a for Var id *)
let rec sub (a : typing) (id : varid) (b : typing) : typing =
  match b with
  | TVar x -> if x = id then a else b
  | TArrow (x, y) -> TArrow (sub a id x, sub a id y)
  | TSpec (t, x) -> TSpec (t, sub a id x)

(* 
  Apply our environment of appropriate subs
  to a typing to get a new typing
*)
let apply_env (e : environment) (t : typing) : typing =
  List.fold_right (fun (v, t) -> sub t v) e t

(*
  Identify the list of substitutions we need to make in order
  to unify a pair of typing elements a and b
*)
let rec unify (a : typing) (b : typing) : environment =
  match a, b with
  | TVar x, TVar y -> if x = y then [] else [(x, b)]
  | TArrow (w, x), TArrow (y, z) -> (unify w y) @ (unify x z)
  | TVar x, ar | ar, TVar x -> [(x, ar)]
  | TSpec (_, x), ar | ar, TSpec (_, x) -> unify x ar

let rec unify_list (l : (typing * typing) list) : environment =
  match l with
  | [] -> []
  | (a, b) :: t -> (unify a b) @ (unify_list t)

(* 
  I think the idea here is now we have
  parts of expr hash to unique characters
  and hash these unique characters to
  their appropriate data types or
  "unassigned", and then perform a unification
  and go back on the hash table to get the
  appropriate types.

  2 hash tables
*)