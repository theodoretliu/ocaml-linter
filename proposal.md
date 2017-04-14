# CS51 Alternative Final Project Proposal
Nenya Edjah, Theodore Liu, and Richard Wang

## Objective
We would like to build a linter and/or autoformatter for OCaml. In general, the linter would detect for improper styling, including but not limited to going over the 80 character line limit, improper indentation, untyped variables in function declarations, and unnecessary semicolon uses. Additionally, the linter would also check for code "optimizations" including partially applied functions, match statements which could be converted to let statements, and converting if else statements into boolean expressions. Finally, as a stretch goal, our linter would be able to automatically make changes to the code, adjusting the style and other items as it determines is best.

## Goals

### Need to Have
* Detect lines going over 80 characters
  ```ocaml
  let new_mass = new mass (50. +. Random.float 400.) (50. +. Random.float 400.) 1.0 ;;

  let new_mass = new mass (50. +. Random.float 400.)
                          (50. +. Random.float 400.)
                          1. ;;
  ```
* Check for improper indentation
  ```ocaml
  let add (x : int) (y : int) = 
  if x = 4 then x - y 
  else x + y ;;

  let add (x : int) (y : int) =
    if x = 4 then x - y
    else x + y ;;
  ```
* Detect singular match statements
  ```ocaml
  let x = 
    match y with
    | (_a, b) -> b ;;

  let (_a, x) = y ;;
  ```
* Detect unmatched parentheses
  ```ocaml
  assert (List.fold_left (fun x y -> x + y) 0 [1; 2; 3] = 6 ;;

  assert (List.fold_left (fun x y -> x + y) 0 [1; 2; 3] = 6) ;;
  ```
* Detect no spaces before semicolons or other operators
  ```ocaml
  let x=1+2;;

  let x = 1 + 2 ;;
  ```

### Want to Have
* Detect chances for partially applied functions
  ```ocaml
  let sum l = List.fold_left ( + ) 0 l ;;

  let sum = List.fold_left ( + ) 0 ;;
  ```
* Detect unnecessary if-else statements
  ```ocaml
  let b = 
    if x = y then false
    else true ;;

  let b = x <> y ;;

  ========================================

  let rec f x y =
    if x <= 0 || y <= 0 then false
    else if x = y then true
    else f (x - 1) (y - 2) ;;

  let rec f x y = 
    if x <= 0 || y <= 0 then false
    else x = y || f (x - 1) (y - 2) ;;
  ```
* Detect unnecessary semicolon use
  ```ocaml
  let sum = List.fold_left ( + ) 0 ;;

  let y = sum [1; 2; 3; 4] ;;

  ========================================

  let sum = List.fold_left ( + ) 0 

  let y = sum [1; 2; 3; 4]
  ```
* Detect repeated code
  ```ocaml
  let is_sum_odd l = (List.fold_left ( + ) 0 l) mod 2 = 1 ;;

  let is_sum_even l = (List.fold_left ( + ) 0 l) mod 2 = 0 ;;

  ========================================

  let sum = List.fold_left ( + ) 0 ;;

  let is_sum_odd l = (sum l) mod 2 = 1 ;;

  let is_sum_even l = (sum l) mod 2 = 0 ;;
  ```
* Advise on use of float versus integer operations
  ```ocaml
  let sum_list = List.fold_left ( + ) 0. ;;

  let sum_list = List.fold_left ( + ) 0 ;;

  ========================================

  let x = 1. ;;

  let y = x + 1 ;;
  

  let x = 1. ;;

  let y = x +. 1. ;;
  ```
### Ideals
In the most ideal case, the linter would not only be able to detect the above issues but also fix them automatically, like they were fixed manually above. We predict this would be a very hard problem, but if we accomplish our other goals, we would definitely like to tackle this one.

## Timeline
At the midpoint check-in, we would like to have all the need-to-have goals completed and fully functioning. We plan to have made progress on the want-to-have goals by this time as well. By the end of the project, we plan to have most, if not all, of the want-to-have goals completed and the beginnings of progress on the ideal goals.
