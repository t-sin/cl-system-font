(defpackage :system-font
  (:nicknames :sysfont)
  (:use :cl)
  (:import-from :system-font.font-info
                :font-info
                :font-info-p
                :make-font-info
                :font-info-pathname
                :font-info-fullname
                :font-info-styles
                :font-info-languages
                :font-info-family)
  (:export :font-info-list
           :font-info
           :font-info-p
           :make-font-info
           :font-info-pathname
           :font-info-fullname
           :font-info-styles
           :font-info-languages
           :font-info-family))
(in-package :system-font)

(defun font-info-list ()
  (system-font.linux:font-info-list))
