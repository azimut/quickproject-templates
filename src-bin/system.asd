(asdf:defsystem #:(#| TMPL_VAR name |#)
  ;;:class :package-inferred-system ; REMOVE :components
  ;;:depends-on (#:trivial-package-local-nicknames #:(#| TMPL_VAR name |#)/main)
  :description "Describe (#| TMPL_VAR name |#) here"
  :author "(#| TMPL_VAR author |#)"
  :license  "(#| TMPL_VAR license |#)"
  :version "0.0.1"
  :serial t
  :depends-on (#:defpackage-plus)
  :pathname "src"
  :components ((:file "package")
               (:file "(#| TMPL_VAR name |#)")))

(asdf:defsystem #:(#| TMPL_VAR name |#)/standalone
  :depends-on (#:(#| TMPL_VAR name |#))
  :defsystem-depends-on (:cffi-grovel)
  :build-operation :static-program-op
  :build-pathname "bin/standalone/(#| TMPL_VAR name |#)"
  :entry-point "(#| TMPL_VAR name |#):start")

(asdf:defsystem #:(#| TMPL_VAR name |#)/deploy
  :depends-on (#:(#| TMPL_VAR name |#))
  :defsystem-depends-on (:deploy)
  :build-operation :deploy-op
  :build-pathname "deploy/(#| TMPL_VAR name |#)"
  :entry-point "(#| TMPL_VAR name |#):start")
