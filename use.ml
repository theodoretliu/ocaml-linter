#load "str.cma" ;;
#mod_use "expr.ml" ;;
#mod_use "parser.ml" ;;
#mod_use "lexer.ml" ;;
module Ex = Expr ;;
module MP = Parser ;;
module ML = Lexer ;;

let test str =
	let lexbuf = Lexing.from_string str in
	MP.input ML.token lexbuf ;;

(* ocamlyacc parser.mly *)
(* ocamllex lexer.mli *)