SRCS  = $(wildcard src/*.lisp)
TESTS = $(wildcard t/*.lisp)

.PHONY: all
all: docs/index.html deps.svg

.PHONY: test
test: $(SRCS) $(TESTS)
	@sbcl --non-interactive --no-sysinit --no-userinit \
	--load ~/quicklisp/setup.lisp \
	--load '(#| TMPL_VAR name |#).asd' \
	--eval "(ql:quickload :(#| TMPL_VAR name |#)/test)" \
	--eval "(parachute:test-toplevel '(#| TMPL_VAR name |#)-test)"

.PHONY: doc
doc: docs/index.html

docs/index.html: $(SRCS) deps.svg README.md
	@sbcl --non-interactive --no-sysinit --no-userinit \
	--load ~/quicklisp/setup.lisp \
	--load '(#| TMPL_VAR name |#).asd' \
	--eval "(ql:quickload '(:staple :staple-markdown))" \
	--eval '(staple:generate :(#| TMPL_VAR name |#) :if-exists :supersede)'

deps.svg: (#| TMPL_VAR name |#).asd
	@sbcl --non-interactive --no-sysinit --no-userinit \
	--load ~/quicklisp/setup.lisp \
	--load '(#| TMPL_VAR name |#).asd' \
	--eval '(ql:quickload :asdf-dependency-graph)' \
	--eval '(asdf-dependency-graph:generate "deps.svg" "(#| TMPL_VAR name |#)")'
