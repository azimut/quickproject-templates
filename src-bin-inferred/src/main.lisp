(uiop:define-package #:(#| TMPL_VAR name |#)
  (:nicknames #:(#| TMPL_VAR name |#)/main)
  (:use #:cl)
  (:import-from #:(#| TMPL_VAR name |#)/foo #:bar)
  (:export #:main))

(in-package #:(#| TMPL_VAR name |#))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (trivial-package-local-nicknames:add-package-local-nickname
   :a :alexandria))

(defun main ()
  (print "hello from (#| TMPL_VAR name |#) package!")
  (a:when-let ((b t))
    (print "when-let"))
  (bar))
