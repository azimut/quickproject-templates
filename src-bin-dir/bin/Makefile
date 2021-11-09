SBCL:=/usr/bin/sbcl
SBCL_HOME:=/usr/lib/sbcl
export SBCL_HOME

.PHONY: strip clean run simple deploy standalone

simple:
	$(SBCL) --non-interactive \
             --eval '(load "~/quicklisp/setup.lisp")' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#))' \
             --eval "(sb-ext:save-lisp-and-die \"(#| TMPL_VAR name |#)\" :toplevel #'(#| TMPL_VAR name |#):start :executable t :compression 9 :purify t)"

deploy:
	$(SBCL) --non-interactive \
             --eval '(load "~/quicklisp/setup.lisp")' \
             --eval '(ql:quickload :deploy)' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/deploy)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/deploy :verbose t :force t)'

standalone:
	$(SBCL) --non-interactive \
             --eval '(load "~/quicklisp/setup.lisp")' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/static)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/static :verbose t :force t)'

strip:
	find . -name '*.so*' -exec strip {} \;

tar:
	tar cvf ../(#| TMPL_VAR name |#).tar ../bin --transform s/bin/(#| TMPL_VAR name |#)/

clean:
	rm -v -f ../(#| TMPL_VAR name |#).zip
	rm -v -f ./*.so*
	rm -v -f ./(#| TMPL_VAR name |#)

run:
	LD_PRELOAD="$(shell echo ./*.so*)" ./(#| TMPL_VAR name |#)
