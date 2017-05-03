(*
       CS 51 Final Project
      MiniML -- Expressions
           Spring 2017
*)

(* Abstract syntax of OCaml expressions *)

(* Const has: Int, Float, Bool, Char, String, Unit *)
type expr =
  | App of expr * expr                          (* function applications *)
  | Conditional of expr * expr * expr option    (* if then else expressions *)
  | Cons of expr * expr                         (* list Cons *)
  | Const of varid                              (* literal constant *)
  | Fun of varid * expr                         (* function definitions *)
  | Infix of string * expr * expr               (* infixed operators *)
  | Let of varid * expr                         (* global naming *)
  | LetIn of varid * expr * expr                (* local naming *)
  | LetRec of varid * expr                      (* recursive local naming *)
  | LetRecIn of varid * expr * expr             (* recursive global naming *)
  | Match of expr * expr
  | MCons of expr * expr * expr
  | MNil
  | Nil                                         (* list Nil *)
  | Prefix of string * expr                     (* prefixed operators *)
  | Raise                                       (* exceptions *)
  | Tuple of expr list
  | Unassigned                                  (* (temporarily) unassigned *)
  | Var of varid                                (* variables *)
 and varid = string ;;
