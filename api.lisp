(in-package :system-font)

(defparameter *font-info-list-cache* nil)

(defun list-fonts (&key (cache t))
  (when (and *font-info-list-cache* cache)
    (return-from list-fonts *font-info-list-cache*))
  (let ((font-info-list #+linux
                        (list-fonts.linux)
                        #+darwin
                        (list-fonts.macos)))
    (prog1 font-info-list
      (setf *font-info-list-cache* font-info-list))))
