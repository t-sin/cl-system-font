(defpackage :system-font.linux
  (:use :cl)
  (:import-from :uiop
                :run-program)
  (:import-from :split-sequence
                :split-sequence)
  (:import-from :system-font.font-info
                :make-font-info)
  (:export :font-info-list))
(in-package :system-font.linux)

(defvar +fc-list-command+ "fc-list")

(defun run-fc-list ()
  (let ((fc-list-path (format nil "~a" +fc-list-command+)))
    (with-output-to-string (s)
      (run-program fc-list-path :output s))))

(defun parse-fc-list-output-styles (styles)
  (destructuring-bind (_ styles)
      (split-sequence #\= styles)
    (declare (ignore _))
    (split-sequence #\, styles)))

(defun parse-fc-list-output-line (line)
  (destructuring-bind (pathname name styles)
      (split-sequence #\: line)
    (make-font-info :pathname pathname
                    :fullname (string-trim " " name)
                    :styles (parse-fc-list-output-styles styles))))

(defun split-fc-list-output-into-lines (string)
  (remove-if (lambda (line) (zerop (length line)))
             (split-sequence #\newline string)))

(defun font-info-list ()
  (loop
    :for line :in (split-fc-list-output-into-lines (run-fc-list))
    :collect (parse-fc-list-output-line line)))
