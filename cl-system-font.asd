(asdf:defsystem :cl-system-font
  :description "Simple system font configuration accessor"
  :author "t-sin <shinichi.tanaka45@gmail.com>"
  :license "MIT"
  :depends-on ("uiop"
               "split-sequence"
               #+(or darwin win32)
               "com.inuoe.jzon")
  :serial t
  :components ((:file "package")
               #+linux
               (:file "linux")
               #+darwin
               (:file "macos")
               #+win32
               (:file "windows")
               (:file "api")))
