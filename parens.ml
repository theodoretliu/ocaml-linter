open Printf

let create_hashtable size init =
  let tbl = Hashtbl.create size in
  List.iter (fun (key, data) -> Hashtbl.add tbl key data) init;
  tbl

let delimiters = create_hashtable 6 ['(', ')'; '[', ']'; '{', '}'; ')', ' ';
                                     ']', ' '; '}', ' ']]

let rest s = String.sub s 1 (String.length s - 1)

let rec find_mismatch (s : string)
                      (line : int)
                      (column : int)
                      (stack : (char * int * int) list)
                      (problem_free : bool ref)
                    : unit =
  if s = "" then
    if stack <> [] then
      begin
        problem_free := false ;
        List.iter (fun (h, l, c) -> Printf.printf "The '%c' at line %d, column %d is unmatched\n" h l c) (List.rev stack)
      end
    else ()
  else
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


(*"\\\\'\\|\\\\\"" *)
(* let rec find_mismatch_quotes (s : string)
                             (l : int)
                             (c : int)
                             (stack : (char * int * int) list)
                             (in_quotes : bool)
                             (problem_free : bool ref)
                           : unit =
  if s = "" then
    if stack <> [] then
      begin
        problem_free := false ;
        List.iter (fun (x, l, c) ->
                     printf "The %c at line %d, column %d is unmatched" x l c)
                  (List.rev stack)
      end
    else ()
  else if String.length s = 1 then
    let x = s.[0] in
    if x = '"' || x = '\'' then
      begin match stack with
      | h :: t ->
          if x = h then find_mismatch_quotes (rest s) l (c + 1) t
                                             false problem_free
          else find_mismatch_quotes (rest s) l (c + 1) stack true
                                    problem_free
      | [] -> find_mismatch_quotes (rest s) l c [x] true problem_free end
  else
    let first, second = s.[0], s.[1] in
    match first, second with
    | '\\', '"' | '\\', '\'' ->
        if not in_quotes then
          printf "Trying to escape quotes when not in string or character literal at line %d, column %d or mismatched quotes" l c
        find_mismatch_quotes (rest s) l (c + 1) stack in_quotes problem_free
    | _, '"' ->
        begin match stack with
        | h :: t ->
            if h = '"' then find_mismatch_quotes (rest s) l (c + 1) t
                                                 false problem_free
            else find_mismatch_quotes (rest s) l (c + 1) stack
                                      true problem_free
        | [] ->
            find_mismatch_quotes (rest s) l (c + 1) (('"', l, c + 1) :: stack)
                                 true problem_free end
    | _, '\'' ->
        begin match stack with
        | h :: t ->
            if h = '\'' then find_mismatch_quotes (rest s) l (c + 1) t
                                                  false problem_free
            else find_mismatch_quotes (rest s) l (c + 1) t true problem_free
        | [] ->
            begin
              let len = String.length s in
              if len = 2 then
                let third = s.get[2] in

            end *)



