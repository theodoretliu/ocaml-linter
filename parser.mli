type token =
  | EOF
  | OPEN
  | CLOSE
  | LET
  | DOT
  | IN
  | REC
  | NEG
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | LESSTHAN
  | GREATERTHAN
  | LEQ
  | GEQ
  | EQUALS
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
