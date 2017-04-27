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
               ("raise", RAISE);
               ("rec", REC);
               ("true", TRUE);
               ("false", FALSE);
               ("fun", FUNCTION);
               ("function", FUNCTION)
             ]
             
  let sym_table = 
    create_hashtable 8 [
               (".",  DOT);
               ("->", DOT);
               (";;", EOF);

               ("=",  EQUALS);
               ("<>", COMPAREBINOP);
               ("==", COMPAREBINOP);
               ("!=", COMPAREBINOP);
               ("<",  COMPAREBINOP);
               (">",  COMPAREBINOP);
               ("<=", COMPAREBINOP);
               (">=", COMPAREBINOP);

               ("&&", BOOLBINOP);
               ("&",  BOOLBINOP);
               ("||", BOOLBINOP);
               ("or", BOOLBINOP);

               ("~",  INTUNOP);
               ("~+", INTUNOP);
               ("~-", INTUNOP);

               ("+", INTBINOP);
               ("-", INTBINOP);
               ("*", INTBINOP);
               ("/", INTBINOP);

               ("mod",  INTBINOP);
               ("land", INTBINOP);
               ("lor",  INTBINOP);
               ("lxor", INTBINOP);
               ("lsl",  INTBINOP);
               ("lsr",  INTBINOP);
               ("asr",  INTBINOP);


               ("~-.", FLOATUNOP);
               ("~+.", FLOATUNOP);
               ("~-.", FLOATUNOP);

               ("+.", FLOATBINOP);
               ("-.", FLOATBINOP);
               ("*.", FLOATBINOP);
               ("/.", FLOATBINOP);
               ("**", FLOATBINOP);

               ("(", OPEN);
               (")", CLOSE)
             ]
}

let letter = ['a'-'z' 'A'-'Z']
let id = ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*
let sym = ['(' ')'] | (['+' '*' '/' '.' '=' '~' ';' '<' '>']+)

let hex = ['0'-'9' 'A'-'F' 'a'-'f']
let escape_sequence = '\\'['\\' '"' '\'' 'n' 't' 'b' 'r' ' '] 
                      | '\\'['0'-'9']['0'-'9']['0'-'9']
                      | '\\' 'x' hex hex hex
let regular_char = _

rule token = parse
  | ('-')? ['0'-'9'] ['0'-'9' '_']* as integer_literal
    {
      INT (int_of_string integer_literal)
    }
  | '\''(regular_char | escape_sequence)'\'' as char_literal
    {
      CHAR (String.get char_literal 1)
    }
  | id as word
    { try
          let token = Hashtbl.find keyword_table word in
          token 
        with Not_found ->
          ID word
      }
  | sym as symbol
    { try
        let token = Hashtbl.find sym_table symbol in
        token
      with Not_found ->
        token lexbuf
    }
  | '{' [^ '\n']* '}'   { token lexbuf }    (* skip one-line comments *)
  | [' ' '\t' '\n'] { token lexbuf }    (* skip whitespace *)
  | _ as c                                  (* warn and skip unrecognized characters *)
    { printf "Unrecognized character: %c\n" c;
      token lexbuf
    }
  | eof
        { raise End_of_file }
