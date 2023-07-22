(defpackage :system-font
  (:nicknames :sysfont)
  (:use :cl)
  (:export :font-info
           :font-info-p
           :font-info-pathname
           :font-info-fullname
           :font-info-format
           :font-info-style
           :font-info-language
           :font-info-family

           :font-info-list))
(in-package :system-font)

(defstruct font-info
  pathname fullname format style
  language family)
