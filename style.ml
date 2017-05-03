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

let spacing_around_operators_check (str : string) : unit =
  let operator = "[:=&*+\\-./<=>@^|]+" in
  let setoff = "[^ \n'\"]" in
  let re = Str.regexp (setoff ^ operator ^ setoff) in
  let rec helper i issues line str =
    try
      let s = Str.search_forward re str i in
      helper (s + 2) ((line + 1, s) :: issues) line str
    with Not_found -> issues
  in
  let lines = Str.split (Str.regexp "\n") str in
  let issues = List.mapi (helper 0 []) lines in
  let all = List.fold_right ( @ ) issues [] in
  let len = List.length all in
  if len > 0 then
    begin
      let (line, start) = List.nth all (len - 1) in
      let wrong = String.sub (List.nth lines (line - 1)) start 3 in
      printf "%d: %s\n" line wrong;
      let right = String.sub wrong 0 1 ^ " " ^ String.sub wrong 1 1 ^ " " ^ String.sub wrong 2 1 in
      printf "Warning: %d instance(s) of operators that are not delimited by spaces.\n" len;
      printf "Example: on line %d, at char %d, %s should look like %s\n" line (start + 1) wrong right
    end
  else () ;;

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
