SBCL_BIN ?= /usr/bin/sbcl
SBCL_HOME ?= /usr/lib/sbcl
SBCL_COMPRESSION ?= nil
export SBCL_HOME

.PHONY: strip clean tar

.PHONY: simple
simple:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load '../(#| TMPL_VAR name |#).asd' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#))' \
             --eval "(sb-ext:save-lisp-and-die \"(#| TMPL_VAR name |#)\" :toplevel #'(#| TMPL_VAR name |#):start :executable t :compression $(SBCL_COMPRESSION) :purify t)"

.PHONY: deploy
deploy:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load '../(#| TMPL_VAR name |#).asd' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/deploy)' \
             --eval '(push :deploy-console *features*)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/deploy :verbose t :force t)'
	echo 'chmod +x (#| TMPL_VAR name |#); LD_PRELOAD="`echo ./*.so*`" ./(#| TMPL_VAR name |#)' > (#| TMPL_VAR name |#)-deploy/run.sh

.PHONY: standalone
standalone:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load '../(#| TMPL_VAR name |#).asd' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/standalone)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/standalone :verbose t :force t)'

(#| TMPL_VAR name |#).AppImage: AppDir/(#| TMPL_VAR name |#) AppRun iconfile.svg (#| TMPL_VAR name |#).desktop
	wget -c -O ~/Downloads/appimagetool https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage
	chmod +x ~/Downloads/appimagetool
	install -D (#| TMPL_VAR name |#).desktop AppDir/(#| TMPL_VAR name |#).desktop
	install -D AppRun         AppDir/AppRun
	install -D iconfile.svg   AppDir/iconfile.svg
	ARCH=x86_64 ~/Downloads/appimagetool -v AppDir (#| TMPL_VAR name |#).AppImage

.PHONY: static
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
		--eval '(sb-ext:save-lisp-and-die "/tmp/(#| TMPL_VAR name |#)" :executable t :toplevel (lambda () ((#| TMPL_VAR name |#):start)) :compression $(SBC_COMPRESSION) :purify t)'

strip:
	find . -name '*.so*' -exec strip {} \;

tar:
	tar cvf ../(#| TMPL_VAR name |#).tar ../bin --transform s/bin/(#| TMPL_VAR name |#)/

clean:
	rm -v -f ../(#| TMPL_VAR name |#).zip
	rm -v -f ./*.so*
	rm -v -f ./(#| TMPL_VAR name |#)
