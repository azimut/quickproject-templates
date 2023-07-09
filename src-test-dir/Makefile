.PHONY: test
test:
	@sbcl --non-interactive --no-sysinit --no-userinit \
	      --load ~/quicklisp/setup.lisp \
	      --load (#| TMPL_VAR name |#).asd \
	      --eval "(ql:quickload :(#| TMPL_VAR name |#)/test)" \
	      --eval "(parachute:test-toplevel '(#| TMPL_VAR name |#)-test)"
