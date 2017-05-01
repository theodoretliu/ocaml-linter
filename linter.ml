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