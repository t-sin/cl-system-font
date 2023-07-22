(in-package :system-font)

(defparameter *font-info-list-cache* nil)

(defun font-info-list (&key cache)
  (when (and *font-info-list-cache* cache)
    *font-info-list-cache*)
  (let ((font-info-list #+linux
                        (font-info-list.linux)))
    (prog1 font-info-list
      (setf *font-info-list-cache* font-info-list))))
