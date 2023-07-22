(in-package :system-font)

(defparameter +fc-list-command-path+ "")
(defparameter +fc-list-command+ "fc-list")
(defparameter +fc-list-options+
  '("-f" "'%{file}:%{fullname}:%{fontformat}:%{family}:%{familylang}:%{style}\\n'"))

(defun run-fc-list ()
  (let ((fc-list-command (format nil "~a~a : ~{~a ~}"
                              +fc-list-command-path+
                              +fc-list-command+
                              +fc-list-options+)))
    (with-output-to-string (s)
      (uiop:run-program fc-list-command :output s))))

(defun parse-fc-list-output-item (item)
  (when (zerop (length item))
    (return-from parse-fc-list-output-item '()))
  (split-sequence:split-sequence #\, item))

(defun parse-fc-list-output-line (line)
  (destructuring-bind (pathname name format family language style)
      (split-sequence:split-sequence #\: line)
    (make-font-info :pathname pathname
                    :fullname name
                    :format format
                    :family (parse-fc-list-output-item family)
                    :language (parse-fc-list-output-item language)
                    :style (parse-fc-list-output-item style))))

(defun split-fc-list-output-into-lines (string)
  (remove-if (lambda (line) (zerop (length line)))
             (split-sequence:split-sequence #\newline string)))

(defun font-info-list.linux ()
  (loop
    :for line :in (split-fc-list-output-into-lines (run-fc-list))
    :collect (parse-fc-list-output-line line)))
