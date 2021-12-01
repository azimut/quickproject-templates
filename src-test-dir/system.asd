(asdf:defsystem #:(#| TMPL_VAR name |#)
  :description "Describe (#| TMPL_VAR name |#) here"
  :author "(#| TMPL_VAR author |#)"
  :license  "(#| TMPL_VAR license |#)"
  :version "0.0.1"
  :serial t(#| TMPL_IF depends-on |#)
  :depends-on (#| TMPL_VAR dependencies-string |#)(#| /TMPL_IF |#)
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
