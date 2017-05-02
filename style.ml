open Printf ;;
open Expr ;;
let problem_free = ref true ;;

(* 
  Determines if a string contains tabs as opposed to spaces,
  converts tabs into two spaces, and returns the modified string
*)
let contains_tabs_check (str : string) : string = 
  if String.contains str '\t' then
    begin
      print_endline "Warning: You're using tabs. Spaces are preferred.";
      problem_free := false;
    end
  else ();
  Str.global_replace (Str.regexp "\t") "  " str
;;

(* 
  Finds lines that have length > 80 and reports them
*)
let line_length_check (str : string) : unit =
  let lines = Str.split (Str.regexp "\n") str in
  let is_overlength index s =
    let len = String.length s in 
    if len > 80 then
      begin
        problem_free := false;
        printf "Warning: line %d is %d chars long\n" (index + 1) len
      end
  in List.iteri is_overlength lines
;;

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
  | MCons (e1, e2, e3) ->
    match e3 with
    | MNil -> printf "Warning: single match statement"
    | MCons (_, _, _) -> ()
    | _ -> failwith "Impossible: not MCons in MCons"
  | Const v -> ()
  | Unassigned -> ()
;;

let whitespace_check (str : string) : unit =
  let operator_char = Str.regexp "[! $ % & * + \\- . / : < = > ? @ ^ | ~]" in
  let infix_symbol = Str.regexp "[= < > @ ^ | & + \\- * / $ %]" in
  ()