#load "str.cma" ;;
#mod_use "expr.ml" ;;
#mod_use "parser.ml" ;;
#mod_use "lexer.ml" ;;
#mod_use "unification.ml"
#mod_use "builtins.ml"
#mod_use "inference.ml"

open Expr ;;
module MP = Parser ;;
module ML = Lexer ;;

open Unification ;;
open Inference ;;
open Builtins ;;

let test str =
  let lexbuf = Lexing.from_string (str ^ ";;..") in
  MP.input ML.token lexbuf ;;

let testt str = List.hd (test str) 

let tok = Lexing.from_string 

let next = ML.token

(* ocamlyacc parser.mly *)
(* ocamllex lexer.mli *)

let ae e = reset_type_vars (); annotate e
let cl e = reset_type_vars (); collect [ae e] []
let ul e = reset_type_vars (); unify_list (cl e)
let ap e = reset_type_vars (); apply_env (ul e) (type_of (ae e))