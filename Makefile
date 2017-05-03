.PHONY: all use linter style inference clean lexer parser

all: linter inference style use

use: lexer parser
	cp use.ml _build/use.ml

lexer: lexer.mll
	ocamlbuild lexer.ml

parser: parser.mly
	ocamlbuild parser.ml

linter: linter.ml
	ocamlbuild linter.byte

style: style.ml
	ocamlbuild style.byte

inference: inference.ml
	ocamlbuild inference.byte

clean:
	rm -r _build
	rm *.byte
