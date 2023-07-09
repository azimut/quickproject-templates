(asdf:defsystem #:(#| TMPL_VAR name |#)
  :description "Describe (#| TMPL_VAR name |#) here"
  :author "(#| TMPL_VAR author |#)"
  :license  "(#| TMPL_VAR license |#)"
  :version "0.0.1"
  :serial t
  :depends-on (#:defpackage-plus)
  :pathname "src"
  :components ((:file "package")
               (:file "(#| TMPL_VAR name |#)")))
