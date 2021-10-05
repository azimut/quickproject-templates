.PHONY: strip zip clean run

(#| TMPL_VAR name |#):
	sbcl --disable-debugger \
             --eval '(load "~/quicklisp/setup.lisp")' \
             --eval '(ql:quickload :deploy)' \
             --load ../(#| TMPL_VAR name |#).asd \
             --eval '(ql:quickload :(#| TMPL_VAR name |#))' \
             --eval '(asdf:make :(#| TMPL_VAR name |#) :force t)' \
             --quit

strip:
	find . -name '*.so*' -exec strip {} \;

tar:
	tar cvf ../(#| TMPL_VAR name |#).tar ../bin --transform s/bin/(#| TMPL_VAR name |#)/

clean:
	rm -v -f ../(#| TMPL_VAR name |#).zip
	rm -v -f ./*.so*
	rm -v -f ./(#| TMPL_VAR name |#)

run:
	chmod +x ./(#| TMPL_VAR name |#)
	LD_PRELOAD="$(shell echo ./*.so*)" ./(#| TMPL_VAR name |#)
