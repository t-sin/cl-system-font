(asdf:defsystem :cl-system-font
  :description "Simple system font configuration accessor"
  :author "t-sin <shinichi.tanaka45@gmail.com>"
  :version "0.1.0"
  :license "MIT"
  :depends-on ("uiop"
               "split-sequence"
               #+(or darwin win32)
               "com.inuoe.jzon"
               #+win32
               "cl-ppcre")
  :serial t
  :components ((:file "package")
               #+linux
               (:file "linux")
               #+darwin
               (:file "macos")
               #+win32
               (:file "windows")
               (:file "api")))
