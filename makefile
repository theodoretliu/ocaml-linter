all: use linter

use: use.ml
	ocamlbuild use.byte

linter: linter.ml
	ocamlbuild linter.byte

clean:
	rm -rf _build
	rm -rf *.byte
	rm -rf lexer.ml
	rm -rf parser.ml
	rm -rf parser.mli