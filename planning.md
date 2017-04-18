I'm hoping that we can use this as a file to plan out what to do.

Go ahead and take a look at [this](http://lisperator.net/pltut/), a website I looked at a while back when I wanted to write a programming language in Javascript. I think the base is similar.

For a strong base, we want to be able to:

- Read the input stream
- From the input stream, tokenize the input stream
- Form the AST from the token stream

We should be able to run and test the above on well-formed, rule-following OCaml. For potentially malformed OCaml, I think we should be able to:

- Read the input stream
- From the input stream, tokenize the input stream (here, syntax errors will probably be parsed as byte/string types)
- Form the AST from the token stream
  * Catch errors that might have occurred during tokenizing because the AST wouldn't make sense

We should be able to:

- Write a data type that represents the input stream/token stream
- Write a function that reads the input
- Define a well-defined data type that describes the set a character or a group of characters belongs to
  * punctuation
  * numbers
  * bytes/strings
  * reserved keywords
  * variables
  * operators
  * possibly whitespace and newlines (the link I put above doesn't return a token for whitespace, but it might be useful for our purposes)
- Furthermore, define a proper BNF grammar that describes the syntax of OCaml
- Write a function that parses the input stream, returning a token stream

Issues we'll probably run into:

- Javascript is nice because function blocks are well-defined, but `match` statements might pose an issue here (where does a `match` statement end? If I nest two `match` statements, is it easy to see where a category of match belongs to?)
- Javascript is loose about how it handles numbers, but we should differentiate between integers and floats at the very least
- Locally scoped vs. globally scoped variables
- Do we make assumptions about partially applied functions? If we assume that whatever application exists is correct, we risk making a mistake. If we rigorously check partially applied functions, we might overcomplicate things.
- How do we handle functions from other modules?
