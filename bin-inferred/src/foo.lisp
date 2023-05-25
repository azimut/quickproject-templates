(uiop:define-package #:(#| TMPL_VAR name |#)/foo
  (:export #:bar))

(in-package #:(#| TMPL_VAR name |#)/foo)

(defun bar ()
  (print "BAR"))
