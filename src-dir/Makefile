SRCS = $(wildcard src/*.lisp)

docs/index.html: $(SRCS)
	@sbcl --non-interactive --no-sysinit --no-userinit \
	--load ~/quicklisp/setup.lisp \
	--load '(#| TMPL_VAR name |#).asd' \
	--eval "(ql:quickload '(:staple :staple-markdown :(#| TMPL_VAR name |#)))" \
	--eval '(staple:generate :(#| TMPL_VAR name |#) :if-exists :supersede)'
