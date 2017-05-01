open Printf ;;
let problem_free = ref true ;;

(* 
  INPUT: a string
  OUTPUT: a list of 'line's
  note: assuming that tabs = 2 spaces for the purpose of counting line lengths
*)
let line_length_check (str : string) : unit =
  if String.contains str '\t' then
    begin
      print_endline "Warning: You're using tabs. Spaces are preferred.";
      problem_free := false;
    end
  else ();
  let str = Str.global_replace (Str.regexp "\t") "  " str in
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

let operator_char = ['!' '$' '%' '&' '*' '+' '-' '.' '/' ':' '<' '=' '>' '?' '@' '^' '|' '~']

let infix_symbol = ['=' '<' '>' '@' '^' '|' '&' '+' '-' '*' '/' '$' '%']