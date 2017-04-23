type token =
  | EOF
  | OPEN
  | CLOSE
  | LET
  | DOT
  | IN
  | REC
  | EQUALS
  | INTUNOP
  | INTBINOP
  | FLOATUNOP
  | FLOATBINOP
  | BOOLBINOP
  | COMPAREBINOP
  | CONS
  | NIL
  | APPEND
  | IF
  | THEN
  | ELSE
  | FUNCTION
  | RAISE
  | FAILWITH
  | ID of (string)
  | INT of (int)
  | FLOAT of (float)
  | TRUE
  | FALSE

val input :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Expr.expr
