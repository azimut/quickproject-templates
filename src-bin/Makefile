SBCL_BIN ?= /usr/bin/sbcl
SBCL_HOME ?= /usr/lib/sbcl
SBCL_COMPRESSION ?= nil
export SBCL_HOME

bin/(#| TMPL_VAR name |#):
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load './(#| TMPL_VAR name |#).asd' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#))' \
             --eval "(sb-ext:save-lisp-and-die \"bin/(#| TMPL_VAR name |#)\" :toplevel #'(#| TMPL_VAR name |#):start :executable t :compression $(SBCL_COMPRESSION) :purify t)"

bin/deploy/(#| TMPL_VAR name |#):
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load './(#| TMPL_VAR name |#).asd' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/deploy)' \
             --eval '(push :deploy-console *features*)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/deploy :verbose t :force t)'
	echo 'chmod +x (#| TMPL_VAR name |#); LD_PRELOAD="`echo ./*.so*`" ./(#| TMPL_VAR name |#)' > bin/deploy/run.sh

bin/appimagetool:
	wget -c -O bin/appimagetool 'https://github.com/AppImage/AppImageKit/releases/download/12/appimagetool-x86_64.AppImage'
	chmod +x bin/appimagetool

bin/(#| TMPL_VAR name |#).AppImage: bin/appimagetool bin/deploy/(#| TMPL_VAR name |#) bin/AppRun bin/iconfile.svg bin/default.desktop
	install -D bin/default.desktop bin/deploy/(#| TMPL_VAR name |#).desktop
	install -D bin/AppRun          bin/deploy/AppRun
	install -D bin/iconfile.svg    bin/deploy/iconfile.svg
	ARCH=x86_64 ./bin/appimagetool -v bin/deploy bin/(#| TMPL_VAR name |#).AppImage

bin/standalone/(#| TMPL_VAR name |#):
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
             --load ~/quicklisp/setup.lisp \
             --load './(#| TMPL_VAR name |#).asd' \
             --eval '(ql:quickload :(#| TMPL_VAR name |#)/standalone)' \
             --eval '(asdf:make :(#| TMPL_VAR name |#)/standalone :verbose t :force t)'

bin/(#| TMPL_VAR name |#)-static:
	$(SBCL_BIN) --non-interactive --no-sysinit --no-userinit \
	     --load ~/quicklisp/setup.lisp \
	     --eval "(pushnew \"$PWD/\" ql:*local-project-directories*)" \
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
		--eval '(sb-ext:save-lisp-and-die "bin/(#| TMPL_VAR name |#)-static" :executable t :toplevel (lambda () ((#| TMPL_VAR name |#):start)) :compression $(SBC_COMPRESSION) :purify t)'

.PHONY: simple deploy standalone static appimage
simple:     bin/(#| TMPL_VAR name |#)
deploy:     bin/deploy/(#| TMPL_VAR name |#)
appimage:   bin/(#| TMPL_VAR name |#).AppImage
standalone: bin/standalone/(#| TMPL_VAR name |#)
static:     bin/(#| TMPL_VAR name |#)-static

.PHONY: clean tar
tar: (#| TMPL_VAR name |#).tgz
clean:; rm -vrf ./bin/deploy ./bin/standalone ./bin/(#| TMPL_VAR name |#) ./*tgz
(#| TMPL_VAR name |#).tgz: bin/deploy/(#| TMPL_VAR name |#)
	tar cvzf (#| TMPL_VAR name |#).tgz bin/deploy --transform s/bin\\/deploy/(#| TMPL_VAR name |#)/
