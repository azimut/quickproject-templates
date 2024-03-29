(asdf:defsystem #:(#| TMPL_VAR name |#)
  :description "Describe (#| TMPL_VAR name |#) here"
  :author "(#| TMPL_VAR author |#)"
  :license  "(#| TMPL_VAR license |#)"
  :source-control (:git "https://github.com/azimut/(#| TMPL_VAR name |#)")
  :bug-tracker "https://github.com/azimut/(#| TMPL_VAR name |#)/issues"
  :homepage "https://azimut.github.io/(#| TMPL_VAR name |#)/"
  :version "0.0.1"
  :serial t
  :depends-on (#:defpackage-plus)
  :pathname "src"
  :components ((:file "package")
               (:file "(#| TMPL_VAR name |#)"))
  :in-order-to ((asdf:test-op (asdf:test-op :(#| TMPL_VAR name |#)/test))))

(asdf:defsystem #:(#| TMPL_VAR name |#)/test
  :depends-on (#:(#| TMPL_VAR name |#) #:parachute)
  :pathname "t"
  :components ((:file "package")
               (:file "tests"))
  :perform (asdf:test-op (op c) (uiop:symbol-call :parachute :test :(#| TMPL_VAR name |#)-test)))
