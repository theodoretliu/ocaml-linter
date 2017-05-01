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
%token END

%nonassoc COMPAREBINOP

%right INTBINOP FLOATBINOP

%start input
%type <Expr.expr list> input

/* Grammar follows */
%%
treeexp:
  | exp EOF treeexp      { $1 :: $3 }
  | exp                  { [$1] }

input:  treeexp END      { $1 }

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

matchexp:
  | PIPE exp DOT exp PIPE matchexp    { ($2, $4) :: $6 }
  | exp DOT exp PIPE matchexp         { ($1, $3) :: $5 }
  | PIPE exp DOT exp                  { [($2, $4)] }
  | exp DOT exp                       { [($1, $3)] }

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
  | exp INFIX exp                     { Infix ($2, $1, $3) }
  | FUNCTION ID DOT exp               { Fun ($2, $4) }
  | LET x=boption(REC) y=nonempty_list(ID) EQUALS z=exp a=option(preceded(IN, exp)) 
      { let h :: t = y in
        let l = List.fold_right (fun x y -> Fun (x, y)) t z in
        match x, a with
        | false, None -> Let (h, l)
        | false, Some b -> LetIn (h, l, b)
        | true, None -> LetRec (h, l) 
        | true, Some b -> LetRecIn (h, l, b) }
  | exp INFIX exp                     { Infix ($2, $1, $3) }
  | IF exp THEN exp x=option(pair(ELSE, exp)) 
      { let el = 
          match x with
          | None -> None
          | Some (_, b) -> Some b in
        Conditional ($2, $4, el) }
  | MATCH exp WITH matchexp           
      { let l = List.fold_right (fun (x1, x2) y -> MCons (x1, x2, y)) $4 MNil in 
        Match ($2, l) }

%%
