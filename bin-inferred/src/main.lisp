(uiop:define-package #:(#| TMPL_VAR name |#)
  (:nicknames #:(#| TMPL_VAR name |#)/main)
  (:use #:cl)
  (:import-from #:(#| TMPL_VAR name |#)/foo #:bar)
  (:export #:main))

(in-package #:(#| TMPL_VAR name |#))

(defun main ()
  (print "hello from (#| TMPL_VAR name |#) package!")
  (bar))
