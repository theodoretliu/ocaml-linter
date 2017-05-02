let create_hashtable size init =
  let tbl = Hashtbl.create size in
  List.iter (fun (key, data) -> Hashtbl.add tbl key data) init;
  tbl

let delimiters = create_hashtable 6 ['(', ')'; '[', ']'; '{', '}'; ')', ' ';
                                     ']', ' '; '}', ' ']

let rest s = String.sub s 1 (String.length s - 1)

let rec find_mismatch (s : string)
                      (line : int)
                      (column : int)
                      (stack : (char * int * int) list)
                      (problem_free : bool ref)
                    : unit =
  try
    let c = s.[0] in
    if Hashtbl.mem delimiters c then
      match stack with
      | [] ->
          if Hashtbl.find delimiters c = ' ' then
            begin
              problem_free := false ;
              Printf.printf "The '%c' at line %d, column %d is unmatched\n"
                            c line column ;
              find_mismatch (rest s) line (column + 1) stack problem_free
            end
          else
            find_mismatch (rest s) line (column + 1)
                          ((c, line, column) :: stack) problem_free
      | (h, l, col) :: t ->
          if Hashtbl.find delimiters c <> ' ' then
            find_mismatch (rest s) line (column + 1)
                          ((c, line, column) :: stack) problem_free
          else if c = Hashtbl.find delimiters h then
            find_mismatch (rest s) line (column + 1) t problem_free
          else
            begin
              problem_free := false ;
              Printf.printf "The '%c' at line %d, column %d does not match with the '%c' at line %d, column %d\n" h l col c line column ;
              find_mismatch (rest s) line (column + 1) t problem_free
            end
    else
      if c = '\n' then find_mismatch (rest s) (line + 1) 1 stack problem_free
      else find_mismatch (rest s) line (column + 1) stack problem_free
  with
    Invalid_argument _ ->
      if stack <> [] then
        begin
          problem_free := false ;
          List.iter (fun (h, l, c) -> Printf.printf "The '%c' at line %d, column %d is unmatched\n" h l c) (List.rev stack)
        end
      else ()
