(* 
INPUT: file_name, a string that is the path to the file
OUTPUT: str, a string that contains the contents of the file at file_name
 *)
let read_file (file_name : bytes) : bytes =
    let in_channel = open_in file_name in
    let len = in_channel_length in_channel in
    let str = Bytes.create len in
    really_input in_channel str 0 len;
    close_in in_channel;
    str
;;