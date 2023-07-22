(in-package :system-font)

(defun font-info-list ()
  #+linux
  (font-info-list.linux))
