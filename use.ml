#load "str.cma" ;;
#mod_use "expr.ml" ;;
#mod_use "parser.ml" ;;
#mod_use "lexer.ml" ;;
module Ex = Expr ;;
module MP = Parser ;;
module ML = Lexer ;;

#mod_use "unification.ml"
#mod_use "inference.ml"

open Unification ;;
open Inference ;;

let test str =
  let lexbuf = Lexing.from_string (str ^ ";;..") in
  MP.input ML.token lexbuf ;;

let tok = Lexing.from_string 

let next = ML.token

(* ocamlyacc parser.mly *)
(* ocamllex lexer.mli *)
