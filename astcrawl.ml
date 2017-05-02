open Expr ;;
open Inference ;;

let rec crawl_ast (e : expr) : unit =
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
  | MCons (e1, e2, e3) -> ()
  | Const v -> ()
  | Unassigned -> ()
;;

let detect_singular_match (e : expr) : unit =
  match e with
  | MCons (_, _, e3) ->
      match e3 with
      | MNil -> printf "Warning: single match statement"
      | MCons (_, _, _) -> ()
      | _ -> failwith "Impossible: invalid match construction" ;;
