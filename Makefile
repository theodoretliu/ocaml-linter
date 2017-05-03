.PHONY: all use linter style inference clean lexer parser

all: linter inference style use

use: lexer parser
	cp use.ml _build/use.ml

lexer: lexer.mll
	ocamlbuild -use-ocamlfind lexer.ml

parser: parser.mly
	ocamlbuild -use-ocamlfind parser.ml

linter: linter.ml
	ocamlbuild -use-ocamlfind linter.byte

style: style.ml
	ocamlbuild -use-ocamlfind style.byte

inference: inference.ml
	ocamlbuild -use-ocamlfind inference.byte

clean:
	rm -r _build
	rm *.byte
