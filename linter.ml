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

let main () =
  if Array.length Sys.argv = 2 then
    begin
      let s = read_file Sys.argv.(1) in
      let str = Style.contains_tabs_check s in
      Style.line_length_check str ;
      Style.find_mismatch str ;
      (* let l = Style.find_indent_errors str in
      List.iter (Printf.printf "Line %d has improper indentation\n") l ; *)
      if !Style.problem_free then
        print_endline "No problems detected!"
      else ()
    end
  else
    print_endline "Usage: linter.byte filename" ;;

main () ;;
