(uiop:define-package #:(#| TMPL_VAR name |#)
  (:nicknames #:(#| TMPL_VAR name |#)/main)
  (:use #:cl)
  (:export #:start))

(in-package #:(#| TMPL_VAR name |#))

(defun start ()
  (print "hello from (#| TMPL_VAR name |#) package!"))
