(in-package :system-font)

(defparameter +swift-command+ "swift")
(defparameter +swift-options+ '("repl"))

(defparameter +swift-program+ "
import CoreFoundation
import CoreText

func printFontInfo(fd: CTFontDescriptor) {
  let fontAttrs = [
    kCTFontURLAttribute,
    kCTFontDisplayNameAttribute,
    kCTFontFamilyNameAttribute,
    kCTFontStyleNameAttribute,
    kCTFontLanguagesAttribute,
  ]

  let fontAttrNames = [
    \"pathname\",
    \"fullname\",
    \"family\",
    \"style\",
    \"language\",
  ]

  print(\"{ \", terminator: \"\")

  let len = fontAttrs.count
  for i in 0..<len {
    let name = fontAttrNames[i]
    let attr = CTFontDescriptorCopyAttribute(fd, fontAttrs[i])!

    if fontAttrs[i] == kCTFontLanguagesAttribute {
      let array = attr as! [String]
      let joined = array.joined(separator: \",\")
      print(\"\\\"\\(name)\\\": \\\"\\(joined)\\\"\", terminator: \"\")

    } else {
      print(\"\\\"\\(name)\\\": \\\"\\(attr)\\\"\", terminator: \"\")
    }

    print(\", \", terminator: \"\")
  }

  // font format
  let nameFormat = \"format\"
  let format = CTFontDescriptorCopyAttribute(fd, kCTFontFormatAttribute)! as! UInt32
  switch format {
  case CTFontFormat.unrecognized.rawValue:
    print(\"\\\"\\(nameFormat)\\\": \\\"unrecognized\\\", \", terminator: \"\")
  case CTFontFormat.openTypePostScript.rawValue:
    print(\"\\\"\\(nameFormat)\\\": \\\"OpenType\\\", \", terminator: \"\")
  case CTFontFormat.openTypeTrueType.rawValue:
    print(\"\\\"\\(nameFormat)\\\": \\\"OpenType\\\", \", terminator: \"\")
  case CTFontFormat.trueType.rawValue:
    print(\"\\\"\\(nameFormat)\\\": \\\"TrueType\\\", \", terminator: \"\")
  case CTFontFormat.postScript.rawValue:
    print(\"\\\"\\(nameFormat)\\\": \\\"PostScript\\\", \", terminator: \"\")
  case CTFontFormat.bitmap.rawValue:
    print(\"\\\"\\(nameFormat)\\\": \\\"Bitmap\\\", \", terminator: \"\")
  default:
    print(\"\\\"\\(nameFormat)\\\": null, \", terminator: \"\")
  }

  // is this font monospaced?
  let nameMonospaced = \"monospaced\"
  let traits = CTFontDescriptorCopyAttribute(fd, kCTFontTraitsAttribute)! as! Dictionary<CFString, AnyObject>
  let symTraits  = traits[kCTFontSymbolicTrait]! as! UInt32
  let monospaced = (symTraits & CTFontSymbolicTraits.traitMonoSpace.rawValue) != 0
  print(\"\\\"\\(nameMonospaced)\\\": \\(monospaced)\", terminator: \"\")

  print(\" }\")
}

func printAvailableFontInfo() {
  let fontCollection = CoreText.CTFontCollectionCreateFromAvailableFonts(nil)
  let fonts = CoreText.CTFontCollectionCreateMatchingFontDescriptors(fontCollection)
  let len = CFArrayGetCount(fonts)

  print(\"[\")

  for i in 0..<len {
    let fd = CFArrayGetValueAtIndex(fonts, i)
    let d = Unmanaged<CTFontDescriptor>.fromOpaque(fd!).takeUnretainedValue()

    printFontInfo(fd: d)

    if i != len - 1 {
      print(\",\")
    }
  }

  print(\"]\")
}

printAvailableFontInfo()
")

(defun run-swift-script ()
  (let ((swift-repl-command (format nil "~a ~{~a ~}"
                               +swift-command+
                               +swift-options+)))
    (with-output-to-string (s)
      (with-input-from-string (in +swift-program+)
        (uiop:run-program swift-repl-command :output s :input in)))))

(defun make-font-info-from-raw (font-info)
  (make-font-info :pathname (gethash "pathname" font-info)
                  :format (gethash "format" font-info)
                  :fullname (gethash "fullname" font-info)
                  :style (gethash "style" font-info)
                  :language (split-sequence:split-sequence #\, (gethash "language" font-info))
                  :family (gethash "family" font-info)
                  :monospace-p (gethash "monospaced" font-info)))

(defun list-fonts.macos ()
  (let ((raw-font-list (com.inuoe.jzon:parse (run-swift-script)))
        (font-list ()))
    (loop
      :for font-info :across raw-font-list
      :do (push (make-font-info-from-raw font-info) font-list))
    (nreverse font-list)))
