open Expr

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
        print_endline ("Warning: singular match statement. Consider using let" ^
                       " instead")
      else () ;
      find_singular_match e1 ;
      find_singular_match e2
  | Fun (_v, e) | Let (_v, e) | LetRec (_v, e) | Prefix (_v, e) ->
      find_singular_match e
  | LetIn (_v, e1, e2) | LetRecIn (_v, e1, e2) | Infix (_v, e1, e2) ->
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
  | Var _ | Raise | Nil | TNil | MNil | Const _ | Unassigned -> ()

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
