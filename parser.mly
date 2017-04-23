%{
  open Expr ;;
%}

%token EOF
%token OPEN CLOSE
%token LET DOT IN REC
%token NEG
%token PLUS MINUS /* differentiate int plus and int minus and float plus and float minus */
%token TIMES DIVIDE /* also have arithmetic operations for floats */
%token LESSTHAN GREATERTHAN
%token LEQ GEQ EQUALS
%token IF THEN ELSE 
%token FUNCTION
%token RAISE FAILWITH
%token <string> ID
%token <int> INT
%token <float> FLOAT
%token TRUE FALSE

%nonassoc LESSTHAN
%nonassoc GREATERTHAN
%nonassoc LEQ
%nonassoc GEQ
%nonassoc EQUALS
%left PLUS MINUS
%left TIMES DIVIDE

%start input
%type <Expr.expr> input

/* Grammar follows */
%%
input:	exp EOF			{ $1 }

exp: 
	| exp expnoapp   { App($1, $2) }
	| expnoapp		{ $1 }

expnoapp: 
	| INT							{ Num $1 }
	| TRUE							{ Bool true }
	| FALSE							{ Bool false }
	| ID							{ Var $1 }
	| exp PLUS exp					{ Binop(Plus, $1, $3) }
	| exp MINUS exp					{ Binop(Minus, $1, $3) }
	| exp TIMES exp					{ Binop(Times, $1, $3) }
	| exp DIVIDE exp				{ Binop(Divide, $1, $3) }
	| exp EQUALS exp				{ Binop(Equals, $1, $3) }
	| exp LESSTHAN exp				{ Binop(LessThan, $1, $3) }
	| exp GREATERTHAN exp 			{ Binop(GreaterThan, $1, $3) }
	| exp LEQ exp 					{ Binop(LessThanEqual, $1, $3) }
	| exp GEQ exp 					{ Binop(GreaterThanEqual, $1, $3) }
	| NEG exp   					{ Unop(Negate, $2) }
	| IF exp THEN exp ELSE exp   	{ Conditional($2, $4, $6) }
	| LET ID EQUALS exp IN exp		{ Let($2, $4, $6) }
	| LET REC ID EQUALS exp IN exp	{ Letrec($3, $5, $7) }
	| FUNCTION ID DOT exp			{ Fun($2, $4) }	
	| RAISE							{ Raise }
	| OPEN exp CLOSE				{ $2 }
;

%%
