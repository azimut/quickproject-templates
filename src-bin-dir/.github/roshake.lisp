;; Source:
;; https://github.com/roswell/roswell/blob/master/lisp/util-dump.lisp
;; https://github.com/roswell/roswell/blob/master/lisp/dump-sbcl.lisp
;; https://github.com/roswell/roswell/blob/master/lisp/dump.ros


(defvar *package-blacklist*
  `("KEYWORD" #+(or) ,@'())
  "A list of package-designators which is not deleted by delete-all-packages.
The default value contains the minimal blacklist.")


(defun makunbound-symbols-and-delete-package (pkg-designator)
  (format t "Deleting ~a~%" pkg-designator)
  (force-output *standard-output*)
  (handler-case
      (progn
        #-ccl
        (do-symbols (symbol pkg-designator)
          (ignore-errors (makunbound symbol))
          (ignore-errors (fmakunbound symbol))
          (ignore-errors (unintern symbol pkg-designator)))
        #+ccl
        (do-symbols (symbol pkg-designator)
          ;; f/makunbound causes segv
          (ignore-errors (unintern symbol pkg-designator))))
    (package-error ()))
  (handler-case
      (delete-package pkg-designator)
    (package-error ()))
  ;; 
  ;; alternative: more restrictive error handling, handle the name conflict caused during deleting a package
  ;; cf. http://clhs.lisp.se/Body/f_del_pk.htm
  #+(or)
  (handler-bind ((package-error #'continue))
    (delete-package pkg-designator)))

(defun delete-all-packages ()
  ;; push the package name of the main function (== package of the given script)
  ;; (when roswell:*main*
  ;;   (pushnew (package-name (symbol-package roswell:*main*))
  ;;            *package-blacklist* :test #'string=))
  (pushnew (package-name (symbol-package 'szoo8:start))
           *package-blacklist*
           :test #'string=)
  (pushnew (package-name (symbol-package 'cl-user))
           *package-blacklist*
           :test #'string=)
  (map nil #'makunbound-symbols-and-delete-package
       (set-difference (list-all-packages)
                       (mapcar #'find-package *package-blacklist*))))


(defun delete-macro-definitions ()
  "Delete the macro functions assuming no run-time compilation would occur.
This is a portable implementation."
  (#+sbcl sb-ext:without-package-locks
   #-sbcl progn
   (do-all-symbols (s)
     (when (macro-function s)
       (fmakunbound s)))))

(defun delete-compiler-macro-definitions ()
  "Delete the compiler-macros assuming no run-time compilation would occur.
This is a portable implementation."
  (#+sbcl sb-ext:without-package-locks
   #-sbcl progn
   (do-all-symbols (s)
     (when (compiler-macro-function s)
       (setf (compiler-macro-function s) nil)))))

(defun remove-docstrings ()
  "Docstrings are unnecessary when the resulting binary is expected to be a batch program.
With this feature, applications that use docstrings may not work properly."
  (do-all-symbols (s)
    (dolist (doc-type '(function compiler-macro setf
                        method-combination type structure
                        variable))
      (when (documentation s doc-type)
        (setf (documentation s doc-type) nil)))))

(defun safe-clear-info (category kind name)
  (when (cond
          (;; 1.3.x -
           (find-symbol "META-INFO" :sb-int)
           (funcall (find-symbol "META-INFO" :sb-int) category kind nil))
          (;; 1.2.x - 1.3.x
           (find-symbol "META-INFO" :sb-c)
           (funcall (find-symbol "META-INFO" :sb-c) category kind nil))
          (;; - 1.1.18
           (find-symbol "TYPE-INFO-OR-LOSE" :sb-c)
           (ignore-errors
            (funcall (find-symbol "TYPE-INFO-OR-LOSE" :sb-c) category kind))))
    (sb-int:clear-info category kind name)))

(defun delete-compiler-information-sbcl ()
  "This removes the entire compiler information about the functions.
This includes macro/compiler-macro definitions, inline expansions, 
IR1 (deftransform), IR2 (VOP) information in the infodb."
  ;; see src/compiler/globaldb.lisp
  #-sbcl
  (warn "delete-compiler is available only in SBCL")
  #+sbcl
  (declare (sb-ext:muffle-conditions style-warning))
  #+sbcl
  (do-all-symbols (s)
    (when (fboundp s)
      (setf (sb-int:info :function :inlinep s) 'notinline)
      (safe-clear-info :function :inline-expansion-designator s)
      ;; Does this have the same effect as proclaiming notinline?
      ;; --- seems like so. src/compiler/proclaim.lisp
      ;; --- SB-C::PROCESS-INLINE-DECLARATION
      (safe-clear-info :function :source-transform s)
      (safe-clear-info :function :info s)
      (safe-clear-info :function :ir1-convert s)
      (safe-clear-info :function :predicate-truth-constraint s)
      (safe-clear-info :function :macro-function s)
      (safe-clear-info :function :compiler-macro-function s))
    (let ((s `(setf ,s)))
      (when (fboundp s)
        (setf (sb-int:info :function :inlinep s) 'notinline)
        (safe-clear-info :function :inline-expansion-designator s)
        (safe-clear-info :function :source-transform s)
        (safe-clear-info :function :info s)
        (safe-clear-info :function :ir1-convert s)
        (safe-clear-info :function :predicate-truth-constraint s)
        (safe-clear-info :function :macro-function s)
        (safe-clear-info :function :compiler-macro-function s)))))



;; TODO: why not just use delete-package? document it

(defun delete-fun-debug-info (fun)
  ;; cf. src/code/describe.lisp
  ;; function-lambda-expression
  (etypecase fun
    #+sb-eval
    (sb-eval::interpreted-function
     )
    #+sb-fasteval
    (sb-interpreter:interpreted-function
     ;; src/interpreter/function.lisp
     ;; fun-lambda-expression
     )
    (function
     (let* ((fun (sb-impl::%fun-fun fun)) ; obtain the true function from a funcallable-instance
            (code (sb-di::fun-code-header fun)))
       (setf (sb-kernel:%code-debug-info code) nil)))))

(defun delete-debug-info ()
  #-sbcl
  (warn "delete-debug-info is available only in SBCL")
  #+sbcl
  (declare (sb-ext:muffle-conditions style-warning))
  #+sbcl
  (do-all-symbols (s)
    (when (fboundp s)
      (delete-fun-debug-info (symbol-function s)))
    (safe-clear-info :source-location :declaration s)
    (safe-clear-info :type :source-location s)
    (safe-clear-info :source-location :variable s)
    (safe-clear-info :source-location :constant s)
    (safe-clear-info :source-location :typed-structure s)
    (safe-clear-info :source-location :symbol-macro s)
    (safe-clear-info :source-location :vop s)
    (safe-clear-info :source-location :declaration s)
    (safe-clear-info :source-location :alien-type s)
    (safe-clear-info :function :deprecated s)
    (safe-clear-info :variable :deprecated s)
    (safe-clear-info :type :deprecated s)
    (safe-clear-info :function :deprecated s)
    (safe-clear-info :function :deprecated s)
    (safe-clear-info :function :deprecated s)))

(remove-docstrings)
(delete-macro-definitions)
(delete-compiler-macro-definitions)
(delete-compiler-information-sbcl)
(delete-debug-info)
(delete-all-packages)

