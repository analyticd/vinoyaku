(cl:in-package :cl-user)


#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload 'swank)
(swank:create-server)
(ql:quickload :vinoyaku)


(defun target-file ()
  (loop for arg on *command-line-argument-list*
     until (equal (first arg) "--")
     finally (return (cadr arg))))


(defun build ()
  (ccl:save-application (target-file) :toplevel-function #'vinoyaku::main :prepend-kernel t))


(build)
