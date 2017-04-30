open Unification ;;

let int_var = [TVar "int"]
let int_unop = [TVar "int"; TVar "int"]
let int_binop = [TVar "int"; TVar "int"; TVar "int"]
let float_var = [TVar "float"]
let float_unop = [TVar "float"; TVar "float"]
let float_binop = [TVar "float"; TVar "float"; TVar "float"]
let bool_unop = [TVar "bool"; TVar "bool"]
let bool_binop = [TVar "bool"; TVar "bool"; TVar "bool"]
let string_binop = [TVar "string"; TVar "string"; TVar "string"]
let compare_binop = [TVar "'a"; TVar "'a"; TVar "bool"]
let alpha_binop = [TVar "'a"; TVar "'a"; TVar "'a"]

let built_ins =
  Lexer.create_hashtable 50 [
                    ("raise", [TVar "exn"; TVar "'a"]);
                    ("raise_notrace", [TVar "exn"; TVar "'a"]);
                    ("invalid_arg", [TVar "string"; TVar "'a"]);
                    ("failwith", [TVar "string"; TVar "'a"]);

                    ("=", compare_binop);
                    ("=", compare_binop);
                    ("<>", compare_binop);
                    ("==", compare_binop);
                    ("!=", compare_binop);
                    ("<", compare_binop);
                    (">", compare_binop);
                    ("<=", compare_binop);
                    (">=", compare_binop);
                    ("compare", compare_binop);

                    ("min", alpha_binop);
                    ("max", alpha_binop);

                    ("not", bool_unop);
                    ("&&", bool_binop);
                    ("&", bool_binop);
                    ("||", bool_binop);
                    ("or", bool_binop);

                    ("max_int", int_var);
                    ("min_int", int_var);

                    ("~-", int_unop);
                    ("~+", int_unop);
                    ("succ", int_unop);
                    ("pred", int_unop);
                    ("abs", int_unop);
                    ("lnot", int_unop);

                    ("+", int_binop);
                    ("-", int_binop);
                    ("*", int_binop);
                    ("/", int_binop);
                    ("mod", int_binop);
                    ("land", int_binop);
                    ("lor", int_binop);
                    ("lxor", int_binop);
                    ("lsl", int_binop);
                    ("lsr", int_binop);
                    ("asr", int_binop);

                    ("infinity", float_var);
                    ("neg_infinity", float_var);
                    ("nan", float_var);
                    ("max_float", float_var);
                    ("min_float", float_var);
                    ("epsilon_float", float_var);

                    ("~-.", float_unop);
                    ("~+.", float_unop);
                    ("sqrt", float_unop);
                    ("exp", float_unop);
                    ("log", float_unop);
                    ("log10", float_unop);
                    ("expm1", float_unop);
                    ("log1p", float_unop);
                    ("cos", float_unop);
                    ("sin", float_unop);
                    ("tan", float_unop);
                    ("acos", float_unop);
                    ("asin", float_unop);
                    ("atan", float_unop);
                    ("cosh", float_unop);
                    ("sinh", float_unop);
                    ("tanh", float_unop);
                    ("ceil", float_unop);
                    ("floor", float_unop);
                    ("abs_float", float_unop);

                    ("+.", float_binop);
                    ("-.", float_binop);
                    ("*.", float_binop);
                    ("/.", float_binop);
                    ("**", float_binop);
                    ("atan2", float_binop);
                    ("hypot", float_binop);
                    ("copysign", float_binop);
                    ("mod_float", float_binop);

                    ("float", [TVar "int"; TVar "float"]);
                    ("float_of_int", [TVar "int"; TVar "float"]);
                    ("int_of_float", [TVar "float"; TVar "int"]);

                    ("^", string_binop);

                    ("int_of_char", [TVar "char"; TVar "int"]);
                    ("char_of_int", [TVar "int"; TVar "char"]);

                    ("ignore", [TVar "'a"; TVar "unit"]);

                    ("string_of_bool", [TVar "bool"; TVar "string"]);
                    ("bool_of_string", [TVar "string"; TVar "bool"]);
                    ("string_of_int", [TVar "int"; TVar "string"]);
                    ("int_of_string", [TVar "string"; TVar "int"]);
                    ("string_of_float", [TVar "float"; TVar "string"]);
                    ("float_of_string", [TVar "string"; TVar "float"]);
                  ]