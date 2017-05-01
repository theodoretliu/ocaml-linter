(* 
       CS 51 Final Project
      MiniML -- Expressions
           Spring 2017
*)

(* Abstract syntax of MiniML expressions *)

type unop =
  | IntUnop
  | FloatUnop
  | BoolUnop
;;
    
type binop =
  | IntBinop
  | FloatBinop
  | CompareBinop
  | BoolBinop
;;

type expr =
  | Var of varid                                (* variables *)
  | Int of int                                  (* integers *)
  | Float of float                              (* floats *)
  | Bool of bool                                (* booleans *)
  | Char of char                                (* chars *)
  | String of string                            (* strings *)
  | Unit                                        (* units *)
  | Unop of unop * expr                         (* unary operators *)
  | Binop of binop * expr * expr                (* binary operators *)
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
  | Const of varid
  | Unassigned                                  (* (temporarily) unassigned *)
 and varid = string ;;
