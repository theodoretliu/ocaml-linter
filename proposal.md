# CS51 Alternative Final Project Proposal
Nenya Edjah, Theodore Liu, and Richard Wang

## Objective
We would like to build a linter and/or autoformatter for OCaml. In general, the linter would detect for improper styling, including but not limited to going over the 80 character line limit, improper indentation, untyped variables in function declarations, and unnecessary semicolon uses. Additionally, the linter would also check for code "optimizations" including partially applied functions, match statements which could be converted to let statements, and converting if else statements into boolean expressions. Finally, as a stretch goal, our linter would be able to automatically make changes to the code, adjusting the style and other items as it determines is best.

## Goals

### Need to Have
With its most basic functionality, the code should be able to detect lines going over the 80 character limit. This should be trivial to implement. Additionally, the linter should be able to check for improper indentation. Although this is a slightly harder problem, it should still be straightforward to implement. Detection of singular match statements, which can be converted to let statements, should also be a basic functionality of the linter. The linter should also check for unmatched parentheses and warn about runaway match statements.

### Want to Have
Code optimizations would be the next level of difficulty for our project. Getting partially applied functions would be our first step in this direction. In fact, this should not be that difficult since functions that can be partially evaluated have a "common denominator" where the last argument on both sides of the function are the same. The next step in optimizations would be simplifying if-else statements into simple boolean logic. We would also like for the linter to be able to detect repeated code (never write the same code twice) and notify the user of potential refactoring. The linter may also advise on the use of float vs. integer operations.

### Dreams of Beyond
In the most ideal case, the linter would not only be able to detect the above issues but also fix them automatically. It would be able to detect lines going over the 80 character limit and intelligently add newlines and tabs to get it under the limit. It should be able to replace unnecessary if-else statements with boolean logic. This would be an incredible tool, and it would be fantasy to manage to create it.

## Timeline
