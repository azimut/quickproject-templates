SRCS = $(wildcard src/*.lisp)

.PHONY: all
all: docs/index.html deps.svg

.PHONY: test
test: $(SRCS)
	@sbcl --non-interactive --no-sysinit --no-userinit \
	--load ~/quicklisp/setup.lisp \
	--load '(#| TMPL_VAR name |#).asd' \
	--eval "(ql:quickload :(#| TMPL_VAR name |#)/test)" \
	--eval "(parachute:test-toplevel '(#| TMPL_VAR name |#)-test)"

docs/index.html: $(SRCS)
	@sbcl --non-interactive --no-sysinit --no-userinit \
	--load ~/quicklisp/setup.lisp \
	--load '(#| TMPL_VAR name |#).asd' \
	--eval "(ql:quickload '(:staple :staple-markdown :(#| TMPL_VAR name |#)))" \
	--eval '(staple:generate :(#| TMPL_VAR name |#) :if-exists :supersede)'

deps.svg: (#| TMPL_VAR name |#).asd
	@sbcl --non-interactive --no-sysinit --no-userinit \
	--load ~/quicklisp/setup.lisp \
	--load '(#| TMPL_VAR name |#).asd' \
	--eval "(ql:quickload '(:asdf-dependency-graph :(#| TMPL_VAR name |#)))" \
	--eval '(asdf-dependency-graph:generate "deps.svg" "(#| TMPL_VAR name |#)")'
