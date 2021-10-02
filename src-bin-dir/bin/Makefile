@PHONY: zip clean run

(#| TMPL_VAR name |#): clean
	sbcl --eval '(asdf:make :(#| TMPL_VAR name |#))'
	find . -name '*.so*' -exec strip {} \;

zip:
	zip -r ../(#| TMPL_VAR name |#).zip .

clean:
	rm -v -f ../(#| TMPL_VAR name |#).zip
	rm -v -f ./*.so*
	rm -v -f ./(#| TMPL_VAR name |#)

run:
	LD_PRELOAD="$(shell echo ./*.so*)" ./(#| TMPL_VAR name |#)
