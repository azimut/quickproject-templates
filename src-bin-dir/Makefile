zip:
	cd bin/ && zip -r ../(#| TMPL_VAR name |#).zip .

clean:
	rm -v -f ./*.zip
	rm -v -f ./bin/*.so*
	rm -v -f ./bin/(#| TMPL_VAR name |#)

strip:
	find . -name '*.so*' -exec strip {} \;

build:
	/usr/local/bin/sbcl \
		--eval '(ql:quickload :(#| TMPL_VAR name |#))' \
		--eval '(asdf:make :(#| TMPL_VAR name |#))'

dump: clean build strip

run:
	./(#| TMPL_VAR name |#)
