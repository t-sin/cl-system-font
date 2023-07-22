(asdf:defsystem :cl-system-font
  :description "Simple system font configuration accessor"
  :author "t-sin <shinichi.tanaka45@gmail.com>"
  :license "MIT"
  :depends-on ("uiop"
               "split-sequence")
  :serial t
  :components ((:file "package")
               #+linux
               (:file "linux")
               (:file "api")))
