(in-package :system-font)

(defparameter +fc-list-command-path+ "")
(defparameter +fc-list-command+ "fc-list")
;; fc-list's property names are listed in "Font Properties" section in this document:
;;
;;   https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
;;
(defparameter +fc-list-options+
  '("-f" "'%{file}:%{fullname}:%{fontformat}:%{family}:%{familylang}:%{style}:%{spacing}\\n'"))

;; spacing values are described like thhis:
;;
;; >     proportional    spacing         0
;; >     dual            spacing         90
;; >     mono            spacing         100
;; >     charcell        spacing         110
;;
;; from "const" table in the section "Configuration File Format" in
;;   https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
;;
(defparameter +spacing-map+
  '(:proportional "0"
    :dual "90"
    :mono "100"
    :charcell "110"))

(defun to-spacing (string)
  (when (zerop (length string))
    (return-from to-spacing :proportional))
  (loop
    :for (k v) :on +spacing-map+ :by #'cddr
    :do (when (string= v string)
          (return-from to-spacing k))))

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
  (destructuring-bind (pathname name format family language style spacing)
      (split-sequence:split-sequence #\: line)
    (make-font-info :pathname pathname
                    :fullname name
                    :format format
                    :family (parse-fc-list-output-item family)
                    :language (parse-fc-list-output-item language)
                    :style (parse-fc-list-output-item style)
                    :spacing (to-spacing spacing))))

(defun split-fc-list-output-into-lines (string)
  (remove-if (lambda (line) (zerop (length line)))
             (split-sequence:split-sequence #\newline string)))

(defun list-fonts.linux ()
  (loop
    :for line :in (split-fc-list-output-into-lines (run-fc-list))
    :collect (parse-fc-list-output-line line)))