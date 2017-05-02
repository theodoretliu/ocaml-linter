open Printf ;;
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

let trailing_whitespace_check (str : string) : unit =
  let lines = Str.split (Str.regexp "\n") str in
  let re = Str.regexp " +$" in
  let test i s =
    try
      let n = Str.search_forward re s 0 in
      if ((String.length s) - n) > 3 then
        begin
          problem_free := false;
          printf "Warning: line %d has excessive trailing whitespace\n" i
        end
    with Not_found -> ()
  in
  List.iteri test lines ;;



let whitespace_check (str : string) : unit =
  let operator_char = "[! $ % & * + \\- . / : < = > ? @ ^ | ~]" in
  let infix_symbol = "[= < > @ ^ | & + \\- * / $ %]" in
  let re = Str.regexp (operator_char ^ infix_symbol ^ "*") in
  ()

let rec delimiter_mismatch_check (str : string) =
    Parens.find_mismatch str 1 1 [] problem_free
(*
  let len = Bytes.length str in
  let copy = Bytes.copy str in
  let in_double_quotes = ref false in
  let in_single_quotes = ref false in
  for i = 0 to (len - 1) do
    let c = str.[i] in
    if (i = 0 && c = '\'') || (i > 0 && str.[i - 1] <> '\\' && c = '\'') then
      in_single_quotes := not !in_single_quotes
    else ();
    if (i = 0 && c = '\"') || (i > 0 && str.[i - 1] <> '\\' && c = '\"') then
      in_double_quotes := not !in_double_quotes
    else ();
    if !in_single_quotes || !in_double_quotes then
      Bytes.set copy i '*'
  done;
  print_endline copy
  Parens.find_mismatch str *)
