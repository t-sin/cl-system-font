(defpackage :system-font.font-info
  (:use :cl)
  (:export :font-info
           :font-info-p
           :make-font-info
           :font-info-pathname
           :font-info-fullname
           :font-info-styles
           :font-info-languages
           :font-info-family))
(in-package :system-font.font-info)

(defstruct font-info
  pathname fullname styles
  languages family)
