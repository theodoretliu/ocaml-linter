type line = {line_num : int; length : int}
let problem_free = ref true

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
  str

(* 
  INPUT: a string
  OUTPUT: a list of 'line's
  note: assuming that tabs = 2 spaces for the purpose of counting line lengths
*)
let find_overlength_lines (str : string) : line list =
  if String.contains str '\t' then
    begin
      print_endline "Warning: You're using tabs. Spaces are preferred.";
      problem_free := false;
    end
  else ();
  let str = Str.global_replace (Str.regexp "\t") "  " str in
  let lines = Str.split (Str.regexp "\n") str in
  let to_line index s = {line_num = index + 1; length = String.length s} in
  let lengths = List.mapi to_line lines in
  List.filter (fun {length; _} -> length > 80) lengths
;;

(*
  INPUT: a line
  OUTPUT: unit. prints the line warning
*)
let report {line_num; length} =
  problem_free := false;
  Printf.printf "Warning: Line %d is %d chars long.\n" line_num length ;;


if Array.length Sys.argv = 2 then
  begin
    let s = read_file Sys.argv.(1) in
    let lines = find_overlength_lines s in
    List.iter report lines;

    if !problem_free then
      print_endline "No problems detected!"
    else ()
  end
else
  print_endline "Usage: linter.byte filename"