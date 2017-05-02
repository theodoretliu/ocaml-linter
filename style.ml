open Printf ;;
let problem_free = ref true ;;

(*
  Determines if a string contains tabs as opposed to spaces,
  converts tabs into two spaces, and returns the modified string
*)
let contains_tabs_check (str : string) : string =
  if String.contains str '\t' then
    begin
      print_endline "Warning: Youre using tabs. Spaces are preferred.";
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

(* let whitespace_check (str : string) : unit =
  let operator_char = Str.regexp "[! $ % & * + \\- . / : < = > ? @ ^ | ~]"
  let infix_symbol = Str.regexp "[= < > @ ^ | & + \\- * / $ %]" *)

let find_mismatch (s : string) = Parens.find_mismatch s 1 1 [] problem_free
