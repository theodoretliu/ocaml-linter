let last_word = Str.regexp "[^' ']*$" ;;
let first_word = Str.regexp "[^' ']*" ;;

let find (s : string) (r : Str.regexp) : string =
  let trim_s = String.trim s in
  ignore (Str.search_forward r trim_s 0) ;
  Str.matched_string trim_s ;;
(* else, end, with, in, and *)
let rec find_indent_errors' (start : int)
                            (e : int)
                            (line : int)
                            (indents : (string * int) list)
                            (s : string list)
                          : int list =
  match s with
  | [] -> []
  | h :: t ->
      if String.trim h = "" then find_indent_errors' start e (line + 1)
                                                     let_indents t
      else
        let counter = ref 0 in
        while h.[!counter] = ' ' do
          counter := !counter + 1
        done ;
        let indent = !counter in
        Printf.printf "%d %d %d %d" line indent start e;
        print_newline () ;
        let first = find h first_word in
        let last = find h last_word in
        let indents =
          match first with
          | "let" ->
              print_int start ; print_endline "let" ; ("let", start) :: indents
          | "if" -> ("if", start) :: indents
          | _ -> indents in
        let start, e =
          match first with
          | "end" | "with" | ":"
          | "and" | "done" | "struct" | "sig" -> start - 2, e - 2
          | "else" ->
              begin match List.filter (fun (x, _y) -> x = "if") indent with
              | h :: t -> h, h
              | [] -> failwith "Unmatched else" end
          | "in" ->
              begin match List.filter (fun (x, _y) -> x = "let") indent with
              | h :: t -> h, h
              | [] -> failwith "Unmatched in"
          | _ -> start, e in
        print_string "start end " ;
        Printf.printf "%d %d\n" start e ;
        let new_start, new_end, let_indents =
          match first, last with
          | _, "with" -> start, e, let_indents
          | "|", "->" -> start + 4, e + 4, let_indents
          | "|", _ -> start, e, let_indents
          | _, "->" | _, "then" | _, "do" | _, "else" ->
              start + 2, e + 2, let_indents
          | _, ";;" -> 0, 0, let_indents
          | _, "=" ->
              begin match let_indents with
              | [] -> start + 2, e + 2, let_indents
              | h :: _t -> h + 2, h + 2, let_indents end
          | _, "in" ->
              begin match let_indents with
              | [] -> failwith "Unmatched in"
              | h :: _t -> print_int h ; print_newline () ; h, h, let_indents end
          | _ ->
              begin match first.[0], last.[String.length last - 1] with
              | _, ';' -> start, start, let_indents
              | '(', ')' -> start, 80, let_indents
              | _ -> start + 2, 80, let_indents end in
        if indent < start || indent > e then
          line :: (find_indent_errors' new_start new_end (line + 1)
                                       let_indents t)
        else find_indent_errors' new_start new_end (line + 1) let_indents t ;;

let find_indent_errors (s : string) =
  let l = Str.split (Str.regexp "\n") s in
  find_indent_errors' 0 0 1 [] l ;;
