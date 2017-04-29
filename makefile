all: use linter inference

use: use.ml
	ocamlbuild use.byte

linter: linter.ml
	ocamlbuild linter.byte

inference: inference.ml
	ocamlbuild inference.byte

clean:
	rm -rf _build
	rm -rf *.byte
	rm -rf lexer.ml
	rm -rf parser.ml
	rm -rf parser.mli