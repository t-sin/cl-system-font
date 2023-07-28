(in-package :system-font)

(defparameter +system-profiler-command+ "system_profiler")
(defparameter +system-profiler-options+ '("-json" "SPFontsDataType"))

;; NOTE: this system_profiler command is very slow
(defun run-system-profiler ()
  (let ((system-profiler-command (format nil "~a ~{~a ~}"
                                         +system-profiler-command+
                                         +system-profiler-options+)))
    (with-output-to-string (s)
      (uiop:run-program system-profiler-command :output s))))

(defun make-font-info-from-file (font-file push-fn)
  (let ((typefaces (gethash "typefaces" font-file)))
    (loop
      :for typeface :across typefaces
      :for font-info := (make-font-info :pathname (gethash "path" font-file)
                                        :format (gethash "type" font-file)
                                        :fullname (gethash "fullname" typeface)
                                        ;; style is localized value like Japanese
                                        :style (gethash "style" typeface)
                                        ;; no infomation in system_profiler's output
                                        :language nil
                                        :family (gethash "family" typeface)
                                        ;; no infomation in system_profiler's output
                                        :spacing nil)
      :do (funcall push-fn font-info))))

(defun collect-font-info (system-profiler-output)
  (let ((font-list (gethash "SPFontsDataType" (com.inuoe.jzon:parse system-profiler-output))))
    (let ((result-font-list nil))
      (flet ((push-font-info (font-info)
               (push font-info result-font-list)))
        (loop
          :for font-file :across font-list
          :do (make-font-info-from-file font-file #'push-font-info)))
      (nreverse result-font-list))))

(defun font-info-list.macos ()
  (collect-font-info (run-system-profiler)))
