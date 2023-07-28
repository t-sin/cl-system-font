(in-package :system-font)

(defparameter *font-info-list-cache* nil)

(defun font-info-list (&key (cache t))
  (when (and *font-info-list-cache* cache)
    (return-from font-info-list *font-info-list-cache*))
  (let ((font-info-list #+linux
                        (font-info-list.linux)
                        #+darwin
                        (font-info-list.macos)))
    (prog1 font-info-list
      (setf *font-info-list-cache* font-info-list))))
