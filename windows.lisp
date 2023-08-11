(in-package :system-font)

(defparameter +powershell-command+ "powershell.exe")
(defparameter +powershell-options+ '())

(defparameter +powershell-script+ "
using namespace System.CodeDom.Compiler
using namespace System.ComponentModel
using namespace System.Drawing
using namespace System.Drawing.Interop
using namespace System.Drawing.Text
using namespace System.Windows.Media

$sDots = \"....\"
$sWs = \"WWWW\"

Function IsFontMonospaced($name) {
  $conv = [System.ComponentModel.TypeDescriptor]::GetConverter([System.Drawing.Font])
  $font = $conv.ConvertFromString(\"$($name), 14pt\")

  if ($font -eq $null) {
    return $false
  }

  $img = New-Object Bitmap(400, 100)
  $g = [Graphics]::FromImage($img)
  if ($g -eq $null) {
    return $false
  }

  $wDots = $g.MeasureString($sDots, $font, 14)
  $wWs = $g.MeasureString($sWs, $font, 14)
  $g.Dispose()

  return $wDots -eq $wWs
}

Function MakeFontInfo($typeface, $glyphTypeface) {
  $locale = \"en-us\"
  $family = $typeface.FontFamily

  $familyname = \"$($family.FamilyNames[$locale])\"
  $fullname = \"$($family.FamilyNames[$locale]) $($typeface.FaceNames[$locale])\"
  $format = ($glyphTypeface.FontUri -split \"\\.\")[-1]
  $langs = \"$($typeface.FaceNames.Keys)\" -split \" \"

  $fontInfo = @{
    \"pathname\" = $glyphTypeface.FontUri
    \"fullname\" = $fullname
    \"format\" = $format
    \"family\" = $familyname
    \"style\" = \"$($typeface.Style)\"
    \"language\" = $langs
    \"monospaced\" = IsFontMonospaced $familyname
  }

  return $fontInfo
}

Function CollectFontInfo($typeface) {
  $glyphTypeface = New-Object GlyphTypeface
  $ret = $typeface.TryGetGlyphTypeface([ref]$glyphTypeface)

  if ($ret -eq  $false) {
    return $null
  }

  return MakeFontInfo $typeface $glyphTypeface
}

Function CollectSystemFontInfo() {
  $systemTypefaces = [Fonts]::SystemTypefaces
  $fontInfoList = @()

  foreach ($tf in $systemTypefaces) {
    $fi = CollectFontInfo $tf

    if ($fi -ne $null) {
      $fontInfoList += $fi
    }
  }

  return $fontInfoList
}

Function PrintFontInfoListAsJson($list) {
  $list | ConvertTo-Json | Write-Output
}

Function Main() {
  DefineLogFontType

  $list = CollectSystemFontInfo
  PrintFontInfoListAsJson($list)
}

Main
")

(defun run-powershell-script ()
  (let ((powershell-command (format nil "~a ~{~a ~}"
                                    +powershell-command+
                                    +powershell-options+)))
    (with-output-to-string (s)
      (with-input-from-string (in +powershell-script+)
        (uiop:run-program powershell-command :output s :input in)))))

(defun make-font-info-from-raw (font-info)
  (make-font-info :pathname (gethash "pathname" font-info)
                  :format (gethash "format" font-info)
                  :fullname (gethash "fullname" font-info)
                  :style (gethash "style" font-info)
                  :language (split-sequence:split-sequence #\, (gethash "language" font-info))
                  :family (gethash "family" font-info)
                  :monospace-p (gethash "monospaced" font-info)))

(defun list-fonts.windows ()
  (let ((raw-font-list (com.inuoe.jzon:parse (run-powershell-script)))
        (font-list ()))
    (loop
      :for font-info :across raw-font-list
      :do (push (make-font-info-from-raw font-info) font-list))
    (nreverse font-list)))
