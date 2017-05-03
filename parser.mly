%{
  open Expr ;;
%}

%token <string> PREFIX
%token <string> INFIX
%token EOF
%token OPEN CLOSE
%token OPENBRACKET CLOSEBRACKET
%token LET DOT IN REC
%token EQUALS
%token CONS NIL APPEND
%token IF THEN ELSE
%token FUNCTION
%token RAISE FAILWITH
%token <string> ID
%token <int> INT
%token <float> FLOAT
%token <string> STRING
%token <char> CHAR
%token TRUE FALSE
%token LISTOPEN LISTCLOSE
%token DELIMITER
%token TUPLEDELIMITER
%token MATCH WITH
%token SEMICOLON
%token COMMA
%token PIPE
%token UNIT
%token END

%nonassoc IN
%nonassoc LET
%nonassoc FUNCTION WITH
%nonassoc THEN
%nonassoc ELSE
%left     PIPE
%left     COMMA
%right    DOT
%left     INFIX EQUAL
%right    CONS
%nonassoc BEGIN UNIT CHAR TRUE FALSE FLOAT INT
          OPENBRACKET CLOSEBRACKET OPEN CLOSE
          PREFIX STRING ID

%start input
%type <Expr.expr list> input

/* Grammar follows */
%%
treeexp:
  | exp EOF treeexp       { $1 :: $3 }
  | exp                   { [$1] }

input:  treeexp END       { $1 }

exp:
  | exp expnoapp          { App ($1, $2) }
  | expnoapp              { $1 }

/*
need:
typed expressions
generalized tuple
*/
listexp:
  | exp SEMICOLON listexp { $1 :: $3 }
  | exp                   { [$1] }
  |                       { [] }

tupleexp:
  | exp COMMA tupleexp    { $1 :: $3 }
  | exp                   { [$1] }

matchexp:
  | PIPE exp DOT exp PIPE matchexp    { ($2, $4) :: $6 }
  | exp DOT exp PIPE matchexp         { ($1, $3) :: $5 }
  | PIPE exp DOT exp                  { [($2, $4)] }
  | exp DOT exp                       { [($1, $3)] }

expnoapp:
  | ID                                { Var $1 }
  | INT                               { Const "int" }
  | TRUE                              { Const "bool" }
  | FALSE                             { Const "bool" }
  | FLOAT                             { Const "float" }
  | STRING                            { Const "string" }
  | CHAR                              { Const "char" }
  | OPEN CLOSE                        { Const "unit" }
  | OPEN exp CLOSE                    { $2 }
  | OPENBRACKET listexp CLOSEBRACKET  { List.fold_right
                                          (fun x y -> Cons (x, y)) $2 Nil }
  | exp CONS exp                      { Cons ($1, $3) }
  | exp INFIX exp                     { Infix ($2, $1, $3) }
  | OPEN tupleexp CLOSE               { Tuple $2 }
  | PREFIX exp                        { Prefix ($1, $2) }
  | FUNCTION x=ID+ DOT exp            { List.fold_right
                                          (fun x y -> Fun (x, y)) x $4 }
  | x=INFIX exp                       { let y =
                                          match x with
                                          | "+" | "+." | "-" | "-." as x -> x
                                          | _ as x -> failwith "Invalid prefix"
                                        in Prefix ("~" ^ y, $2) }
  | IF exp THEN exp
      x=option(pair(ELSE, exp))       { let el =
                                          match x with
                                          | None -> None
                                          | Some (_, b) -> Some b in
                                        Conditional ($2, $4, el) }
  | LET x=boption(REC) y=nonempty_list(ID)
      EQUALS z=exp a=option(preceded(IN, exp))
      { let h :: t = y in
        let l = List.fold_right (fun x y -> Fun (x, y)) t z in
        match x, a with
        | false, None -> Let (h, l)
        | false, Some b -> LetIn (h, l, b)
        | true, None -> LetRec (h, l)
        | true, Some b -> LetRecIn (h, l, b) }
  | MATCH exp WITH matchexp           { let l = List.fold_right
                                                  (fun (x1, x2) y ->
                                                     MCons (x1, x2, y))
                                                  $4 MNil in
                                        Match ($2, l) }

%%
