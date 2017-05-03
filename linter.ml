(*
  INPUT: file_name, a string that is the path to the file
  OUTPUT: str, a string that contains the contents of the file at file_name
 *)
let read_file (file_name : string) : string =
  let in_channel = open_in file_name in
  let len = in_channel_length in_channel in
  let str = Bytes.create len in
  really_input in_channel str 0 len;
  close_in in_channel;
  str ;;

let last (n : int) (s : string) : string =
  let s = String.trim s in
  String.sub s (String.length s - n) n

let main () =
  if Array.length Sys.argv != 2 then
    print_endline "Usage: linter.byte filename"
  else begin
    let s = read_file Sys.argv.(1) in

    (* style checks *)
    let str = Style.contains_tabs_check s in
    Style.line_length_check str ;
    Style.trailing_whitespace_check str ;
    Style.delimiter_mismatch_check str ;
    Style.quote_mismatch_check str ;
    Style.spacing_around_operators_check str ;

    (* appending a ';;..' to the end of the file to enable it to be parsed *)
    let parse_ready =
      if last 2 s = ";;" then
        (String.trim s) ^ ".."
      else (String.trim s) ^ ";;.." in

    (* design/error checks *)
    let lexbuf = Lexing.from_string parse_ready in
    try
      let tree = Parser.input Lexer.token lexbuf in
      List.iter Ast.find_singular_match tree ;
      if !Style.problem_free && !Ast.problem_free then
        print_endline "No problems detected!"
      else ()
    with _ ->
      print_endline ("We were unable to correctly parse your syntax. Look" ^
                     " at our recommendations for unmatched delimiters!")
  end ;;

main () ;;
