(*
       CS 51 Final Project
      MiniML -- Expressions
           Spring 2017
*)

(* Abstract syntax of OCaml expressions *)

(* Const has: Int, Float, Bool, Char, String, Unit *)
type expr =
  | Var of varid                                (* variables *)
  | Const of varid                              (* literal constant *)
  | Conditional of expr * expr * expr option    (* if then else expressions *)
  | Fun of varid * expr                         (* function definitions *)
  | Let of varid * expr                         (* global naming *)
  | LetIn of varid * expr * expr                (* local naming *)
  | LetRec of varid * expr                      (* recursive local naming *)
  | LetRecIn of varid * expr * expr             (* recursive global naming *)
  | Raise                                       (* exceptions *)
  | App of expr * expr                          (* function applications *)
  | Cons of expr * expr                         (* list Cons *)
  | Nil                                         (* list Nil *)
  | Prefix of string * expr                     (* prefixed operators *)
  | Infix of string * expr * expr               (* infixed operators *)
  | Match of expr * expr
  | MNil
  | MCons of expr * expr * expr
  | Tuple of expr list
  | Unassigned                                  (* (temporarily) unassigned *)
 and varid = string ;;
