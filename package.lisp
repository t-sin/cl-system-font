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
           :font-info-monospace-p

           :list-fonts))
(in-package :system-font)

(deftype monospace-p ()
  (or nil t))

(defstruct font-info
  (pathname #P"/" :type pathname :read-only t)
  (fullname "" :type string :read-only t)
  format style
  language family
  (monospace-p nil :type monospace-p :read-only t))
