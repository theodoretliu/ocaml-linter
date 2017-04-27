%{
  open Expr ;;
%}

%token <string> INFIX
%token <string> PREFIX
%token EOF
%token OPEN CLOSE
%token OPENBRACKET CLOSEBRACKET
%token LET DOT IN REC
%token EQUALS
%token BOOLBINOP COMPAREBINOP
%token INTBINOP FLOATBINOP
%token INTUNOP FLOATUNOP
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
%token MATCH WITH
%token SEMICOLON
%token PIPE
%token UNIT

%nonassoc COMPAREBINOP

%left SEMICOLON
%right INTBINOP FLOATBINOP

%start input
%type <Expr.expr> input

/* Grammar follows */
%%
input:  exp EOF         { $1 }

exp: 
  | exp expnoapp  { App ($1, $2) }
  | expnoapp      { $1 }

/*
need:
typed expressions
generalized tuple
*/
listexp:
  | exp SEMICOLON listexp { $1 :: $3 }
  | exp                   { [$1] }
  |                       { [] }

expnoapp:
  | ID                                { Var $1 }
  | INT                               { Int $1 }
  | TRUE                              { Bool true }
  | FALSE                             { Bool false }
  | FLOAT                             { Float $1 }
  | STRING                            { String $1 }
  | CHAR                              { Char $1 }
  | OPEN CLOSE                        { Unit }
  | OPEN exp CLOSE                    { $2 }
  | OPENBRACKET listexp CLOSEBRACKET  
      { List.fold_right (fun x y -> Cons (x, y)) $2 Nil }
  | OPENBRACKET CLOSEBRACKET          { Nil }
  | exp CONS exp                      { Cons ($1, $3) }
  | PREFIX exp                        { Prefix ($1, $2) }
  | exp INFIX exp                      { Infix ($2, $1, $3) }
  | LET ID EQUALS exp             { Let ($2, $4) }
  | LET ID EQUALS exp IN exp      { LetIn ($2, $4, $6) }
  | LET REC ID EQUALS exp         { LetRec ($3, $5) }
  | LET REC ID EQUALS exp IN exp  { LetRecIn ($3, $5, $7) }
  | IF exp THEN exp x=option(pair(ELSE, exp)) 
      { let el = 
          match x with
          | None -> None
          | Some (_, b) -> Some b in
        Conditional ($2, $4, el) }
 

%%
