%{
  open Expr ;;
%}

%token <string> INFIX
%token EOF
%token OPEN CLOSE
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
%token <char> CHAR
%token TRUE FALSE
%token LISTOPEN LISTCLOSE
%token DELIMITER
<<<<<<< HEAD
=======
%token MATCH WITH
%token SEMICOLON
>>>>>>> b7311b870e3ab5a775088ef27c3f2bb000a6f572
%nonassoc COMPAREBINOP

%right INTBINOP FLOATBINOP

%start input
%type <Expr.expr> input

/* Grammar follows */
%%
input:	exp EOF			{ $1 }

exp: 
	| exp expnoapp  { App($1, $2) }
	| expnoapp		{ $1 }

expnoapp: 
	| INT							{ if $1 = 4 then Int $1 else Int 5 }
	| FLOAT 						{ Float $1 }
	| TRUE							{ Bool true }
	| FALSE							{ Bool false }
	| ID							{ Var $1 }
<<<<<<< HEAD
	| FLOATUNOP x=exp*				{ Unop(FloatUnop, Int (List.length x)) }
=======
	| FLOATUNOP exp 				{ Unop(FloatUnop, $2) }
>>>>>>> b7311b870e3ab5a775088ef27c3f2bb000a6f572

	| exp INTBINOP exp				{ Binop(IntBinop, $1, $3) }
	| exp FLOATBINOP exp			{ Binop(FloatBinop, $1, $3) }
	| exp EQUALS exp 				{ Binop(CompareBinop, $1, $3) }
	| exp COMPAREBINOP exp			{ Binop(CompareBinop, $1, $3) }
	| exp BOOLBINOP exp 			{ Binop(BoolBinop, $1, $3) }


	| IF exp THEN exp ELSE exp   	{ Conditional($2, $4, $6) }
	| LET ID EQUALS exp 			{ Let($2, $4) }
	| LET ID EQUALS exp IN exp		{ LetIn($2, $4, $6) }
	| LET REC ID EQUALS exp			{ LetRec($3, $5) }
	| LET REC ID EQUALS exp IN exp	{ LetRecIn($3, $5, $7) }
	| FUNCTION ID DOT exp			{ Fun($2, $4) }	
	| RAISE							{ Raise }
	| OPEN exp CLOSE				{ $2 }
	| LISTOPEN LISTCLOSE			{ Nil }
	| LISTOPEN exp        			{ $2 }
	| exp DELIMITER exp 			{ Cons($1, $3) }
	| exp LISTCLOSE 				{ Cons($1, Nil) }
	| CHAR 							{ Char $1}

%%
