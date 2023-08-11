(in-package :system-font)

(defparameter +powershell-command+ "powershell.exe")
(defparameter +powershell-options+ '("-Command" "-"))

(defparameter +powershell-script+ "
using namespace System.CodeDom.Compiler
using namespace System.ComponentModel
using namespace System.Drawing
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

  $img = New-Object System.Drawing.Bitmap(400, 100)
  $g = [System.Drawing.Graphics]::FromImage($img)
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
  $json = ConvertTo-Json $list
  Write-Output $json
}

Function PrepareTypes() {
  if (-not ('Windows.Media.Fonts' -as [Type])) {
    Add-Type -AssemblyName 'PresentationCore' 2>$null
  }
  if (-not ('System.Drawing' -as [Type])) {
    Add-Type -AssemblyName 'System.Drawing' 2>$null
  }
}

Function Main() {
  PrepareTypes
  $list = CollectSystemFontInfo
  PrintFontInfoListAsJson($list)
}

Main
")

(defun run-powershell-script ()
  (let ((powershell-command (format nil "~a ~{~a ~}"
                                    +powershell-command+
                                    +powershell-options+)))
    (with-output-to-string (out)
      (with-input-from-string (in +powershell-script+)
        (let ((err (with-output-to-string (err)
                     (uiop:run-program powershell-command
                                       :input in :output out :error-output err
                                       :external-format :cp932))))
         (unless (string= err "")
           (print err)))))))

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
