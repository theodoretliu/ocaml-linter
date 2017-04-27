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

%nonassoc COMPAREBINOP

%left SEMICOLON
%right INTBINOP FLOATBINOP

%start input
%type <Expr.expr> input

/* Grammar follows */
%%
input:	exp EOF			{ $1 }

exp: 
	| exp expnoapp  { App($1, $2) }
	| expnoapp		{ $1 }

/*
need:
typed expressions
generalized tuple
*/
listexp:
	| exp SEMICOLON listexp { $1 :: $3 }
	| exp 					{ [$1] }
	| 						{ [] }

expnoapp:
	| INT 							{ Int $1 }
	| FLOAT 						{ Float $1 }
	| STRING						{ String $1 }
	| CHAR 							{ Char $1 }
	| OPEN exp CLOSE 				{ $2 }
	| OPENBRACKET listexp CLOSEBRACKET { List.fold_right (fun x y -> Cons(x, y)) $2 Nil }
	| OPENBRACKET CLOSEBRACKET 		{ Nil }
	| exp CONS exp 					{ Cons($1, $3) }
	
%%
