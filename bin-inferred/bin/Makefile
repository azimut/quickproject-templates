SBCL_BIN ?= /usr/bin/sbcl
SBCL_HOME ?= /usr/lib/sbcl
SBCL_COMPRESSION ?= nil
export SBCL_HOME

.PHONY: simple deploy standalone static

simple:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load '../(#| TMPL_VAR name |#).asd' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#))' \
             --eval "(sb-ext:save-lisp-and-die \"(#| TMPL_VAR name |#)\" :toplevel #'(#| TMPL_VAR name |#):main :executable t :compression $(SBCL_COMPRESSION) :purify t)"

deploy:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load '../(#| TMPL_VAR name |#).asd' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/deploy)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/deploy :verbose t :force t)'
	echo 'chmod +x (#| TMPL_VAR name |#); LD_PRELOAD="`echo ./*.so*`" ./(#| TMPL_VAR name |#)' > deploy/run.sh

standalone:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load '../(#| TMPL_VAR name |#).asd' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/standalone)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/standalone :verbose t :force t)'

appimagetool:
	wget -c -O appimagetool 'https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage'
	chmod +x appimagetool

(#| TMPL_VAR name |#).AppImage: appimagetool AppDir/(#| TMPL_VAR name |#) AppRun iconfile.svg default.desktop
	install -D default.desktop AppDir/(#| TMPL_VAR name |#).desktop
	install -D AppRun          AppDir/AppRun
	install -D iconfile.svg    AppDir/iconfile.svg
	ARCH=x86_64 ~/Downloads/appimagetool -v AppDir (#| TMPL_VAR name |#).AppImage

static:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
	     --load ~/quicklisp/setup.lisp \
	     --eval "(pushnew \"$PWD/../\" ql:*local-project-directories*)" \
	     --eval '(ql:quickload :(#| TMPL_VAR name |#))' \
	     --load $(SBCL_HOME)/tools-for-build/dump-linkage-info.lisp \
	     --eval '(sb-dump-linkage-info:dump-to-file "/tmp/linkage-info.sexp")' \
	     --eval '(sb-ext:save-lisp-and-die "/tmp/(#| TMPL_VAR name |#).core")'
	$(SBCL_BIN) --script $(SBCL_HOME)/tools-for-build/create-linkage-table-prelink-info-override.lisp \
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
		--eval '(sb-ext:save-lisp-and-die "/tmp/(#| TMPL_VAR name |#)" :executable t :toplevel (lambda () ((#| TMPL_VAR name |#):main)) :compression $(SBC_COMPRESSION) :purify t)'
