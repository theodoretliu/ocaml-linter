{
  open Printf ;;
  open Parser ;; (* need access to parser's token definitions *)

  let create_hashtable size init =
    let tbl = Hashtbl.create size in
    List.iter (fun (key, data) -> Hashtbl.add tbl key data) init;
    tbl

  let split_on_char lst chr =
    let open Str in
    let alst = split (regexp ("[' ']*" ^ chr ^ "[' ']*")) lst in
    List.map Lexing.from_string alst

  let keyword_table =
    create_hashtable 8 [
               ("if", IF);
               ("in", IN);
               ("then", THEN);
               ("else", ELSE);
               ("let", LET);
               ("rec", REC);
               ("true", TRUE);
               ("false", FALSE);
               ("fun", FUNCTION);
               ("function", FUNCTION);
               ("begin", OPEN);
               ("end", CLOSE);
               ("match", MATCH);
               ("with", WITH);

               (* explicit infix operators *)
               ("or", INFIX "or");
               ("mod",  INFIX "mod");
               ("land", INFIX "land");
               ("lor",  INFIX "lor");
               ("lxor", INFIX "lxor");
               ("lsl",  INFIX "lsl");
               ("lsr",  INFIX "lsr");
               ("asr",  INFIX "asr");
             ]

  let sym_table =
    create_hashtable 8 [
               (".",  DOT);
               (",", COMMA);
               ("->", DOT);
               (";;", EOF);
               ("=", EQUALS);
               ("::", CONS);
               (";;..", END);


               ("(", OPEN);
               (")", CLOSE);
               (";", SEMICOLON);
               ("[", OPENBRACKET);
               ("]", CLOSEBRACKET);
               ("|", PIPE);
             ]
}

let letter = ['a'-'z' 'A'-'Z']

let id = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

let sym = ['(' ')' '+' '*' '/' '.' '=' '~' ';' '<' '>' '[' ']' '|' ',']

let two_sym = "->" | ";;.." | ";;" | "::"

let hex = ['0'-'9' 'A'-'F' 'a'-'f']

let escape_sequence = '\\'['\\' '"' '\'' 'n' 't' 'b' 'r' ' ']
                      | '\\'['0'-'9']['0'-'9']['0'-'9']
                      | '\\' 'x' hex hex hex

let regular_char = _

let operator_char = ['!' '$' '%' '&' '*' '+' '-' '.' '/' ':' '<' '=' '>' '?' '@' '^' '|' '~']

let infix_symbol = ['=' '<' '>' '@' '^' '|' '&' '+' '-' '*' '/' '$' '%']

rule token = parse
  | (letter | '_') (letter | ['0'-'9'] | '_' | '\'')* as ident
    {
      try
        let token = Hashtbl.find keyword_table ident in
        token
      with Not_found ->
        ID ident
    }

  (* capitalized ident *)

  | '\''(regular_char | escape_sequence)'\'' as char_literal
    {
      CHAR (String.get char_literal 1)
    }
  | '"'(regular_char | escape_sequence)*'"' as string_literal
    {
      STRING (String.sub string_literal 1 (String.length string_literal - 2))
    }
  | ','
    {
      COMMA
    }
  | two_sym as symbol
    { try
        let token = Hashtbl.find sym_table symbol in
        token
      with Not_found ->
        token lexbuf
    }
  | sym as symbol
    { try
        let token = Hashtbl.find sym_table (String.make 1 symbol) in
        token
      with Not_found ->
        INFIX (String.make 1 symbol)
    }
  | '(' ' '+ '*' infix_symbol* operator_char* ' '* ')'
  | '(' ' '*  ['=' '<' '>' '@' '^' '|' '&' '+' '-' '/' '$' '%'] operator_char* ' '* ')'
  | '(' ' '* (('!' operator_char*) | (['?' '~'] operator_char+)) ' '* ')' as xfix_func
      {
        let re = Str.regexp "[\\( \\)]" in
        let s = Str.global_replace re "" xfix_func in 
        ID s
      } 
  | infix_symbol operator_char* as infix_op
    {
      INFIX infix_op
    }
  | ('!' operator_char*) | (['?' '~'] operator_char+) as prefix_op
    {
      PREFIX prefix_op
    }
  | ((['0'-'9'] ['0'-'9' '_']*)
         | ('0' ['x' 'X'] ['0'-'9' 'A'-'F' 'a'-'f'] ['0'-'9' 'A'-'F' 'a'-'f' '_']*)
         | ('0' ['o' 'O'] ['0'-'7'] ['0'-'7' '_']*)
         | ('0' ['b' 'B'] ['0'-'1'] ['0'-'1' '_']*)) as integer_literal
    {
      INT (int_of_string integer_literal)
    }
  | ['0'-'9'] ['0'-'9' '_']* ('.' ['0'-'9' '_']*)? (['e' 'E'] ['+' '-'] ['0'-'9'] ['0'-'9' '_']*)? as float_literal
    {
      FLOAT (float_of_string float_literal)
    }
  | id as word
    { try
          let token = Hashtbl.find keyword_table word in
          token
        with Not_found ->
          ID word
      }
  | '{' [^ '\n']* '}'   { token lexbuf }    (* skip one-line comments *)
  | [' ' '\t' '\n'] { token lexbuf }    (* skip whitespace *)
  | _ as c                                  (* warn and skip unrecognized characters *)
    { printf "Unrecognized character: %c\n" c;
      token lexbuf
    }
  | eof
        { raise End_of_file }
