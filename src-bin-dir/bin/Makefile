SBCL ?= /usr/bin/sbcl
SBCL_HOME ?= /usr/lib/sbcl
SBCL_COMPRESSION ?= nil
export SBCL_HOME

.PHONY: strip clean run simple deploy standalone static

simple:
	$(SBCL) --non-interactive --no-sysinit --no-userinit \
             --eval '(load "~/quicklisp/setup.lisp")' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#))' \
             --eval "(sb-ext:save-lisp-and-die \"(#| TMPL_VAR name |#)\" :toplevel #'(#| TMPL_VAR name |#):start :executable t :compression $(SBCL_COMPRESSION) :purify t)"

deploy:
	$(SBCL) --non-interactive --no-sysinit --no-userinit \
             --eval '(load "~/quicklisp/setup.lisp")' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/deploy)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/deploy :verbose t :force t)'

standalone:
	$(SBCL) --non-interactive --no-sysinit --no-userinit \
             --eval '(load "~/quicklisp/setup.lisp")' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/static)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/static :verbose t :force t)'

static:
	$(SBCL) --non-interactive --no-sysinit --no-userinit \
	     --load ~/quicklisp/setup.lisp \
	     --eval "(pushnew \"$PWD/../\" ql:*local-project-directories*)" \
	     --eval '(ql:quickload :(#| TMPL_VAR name |#))' \
	     --load $(SBCL_HOME)/tools-for-build/dump-linkage-info.lisp \
	     --eval '(sb-dump-linkage-info:dump-to-file "/tmp/linkage-info.sexp")' \
	     --eval '(sb-ext:save-lisp-and-die "/tmp/(#| TMPL_VAR name |#).core")'
	$(SBCL) --script $(SBCL_HOME)/tools-for-build/create-linkage-table-prelink-info-override.lisp \
	     /tmp/linkage-info.sexp \
	     /tmp/linkage-table-prelink-info-override.c
	while read l; do echo "$l"; eval "export ${l%%=*}=\"${l#*=}\""; done < /usr/lib/sbcl/sbcl.mk
	env | sort
	$CC $CFLAGS -Wno-builtin-declaration-mismatch \
	    -o /tmp/linkage-table-prelink-info-override.o \
	    -c /tmp/linkage-table-prelink-info-override.c
	$CC -no-pie -static $LINKFLAGS \
	    -o /tmp/static-sbcl \
	    /usr/lib/sbcl/$LIBSBCL \
	    /tmp/linkage-table-prelink-info-override.o \
	    $LIBS
	/tmp/static-sbcl --non-interactive \
		--core '/tmp/(#| TMPL_VAR name |#).core' \
		--eval '(sb-ext:save-lisp-and-die "/tmp/(#| TMPL_VAR name |#)" :executable t :toplevel (lambda () ((#| TMPL_VAR name |#):start)) :compression $(SBC_COMPRESSION) :purify t)'

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
