# cl-system-font

**DON'T USE THIS!!! USE this [font-discovery](https://github.com/Shinmera/font-discovery) library!!!**

-----

*cl-system-font* is a simple accessor library for font configurations on your systems.

## Requirements

- GNU/Linux or POSIX systems: [fontconfig](https://www.freedesktop.org/wiki/Software/fontconfig/)
    - tested on Ubuntu 22.04 LTS
- mac OS: [CoreText API](https://developer.apple.com/documentation/coretext) via a Swift script
    - tested on macOS 13.5 Ventura 
- Windows: [`System.Drawing` API](https://learn.microsoft.com/ja-jp/dotnet/api/system.drawing?view=windowsdesktop-7.0) and [`System.Windows.Media` API](https://learn.microsoft.com/ja-jp/dotnet/api/system.windows.media?view=windowsdesktop-7.0) via a PowerShell script
    - tested on Windows 10 with PowerShell 5.1

## Usage

To get all fonst installed on your system, do this:

```lisp
CL-USER> (sysfont:list-fonts)
...
```

Font infomation are includes these items:

- font file pathname
- font file format (as a string)
- font name string
- font families (this may be multiple values)
- font styles (this may be multiple values)
- if this font is monospaced?
- supported languages (this may be multiple values)

## References

- UNIX/Linux: fontconfig
    - [`fc-list`'s default format is `%{=fclist}`](https://gitlab.freedesktop.org/fontconfig/fontconfig/-/blob/f07d7c67e4de05c25ee391e99ee9368f1136317d/fc-list/fc-list.c#L181)
    - `fclist` is described [here](https://www.freedesktop.org/software/fontconfig/fontconfig-devel/fcpatternformat.html)
    - `fclist` format is [`%{?file{%{file}: }}%{-file{%{=unparse}}}`](https://gitlab.freedesktop.org/fontconfig/fontconfig/-/blob/f07d7c67e4de05c25ee391e99ee9368f1136317d/src/fcformat.c#L80)
    - `unparse` is generated [here](https://gitlab.freedesktop.org/fontconfig/fontconfig/-/blob/f07d7c67e4de05c25ee391e99ee9368f1136317d/src/fcname.c#L636)
- MacOS: system_profiler
    - https://apple.stackexchange.com/questions/35852/list-of-activated-fonts-with-shell-command-in-os-x
        - cannot get font spacing and supported languages, in this way
        - font styles maybe localized in system langauges
    - Swift's CoreText interface may allow us to get more information
        - https://developer.apple.com/documentation/coretext
- Windows
    - ~~https://superuser.com/questions/760627/how-to-list-installed-font-families~~
    - https://social.msdn.microsoft.com/Forums/windows/en-US/5b582b96-ade5-4354-99cf-3fe64cc6b53b/determining-if-font-is-monospaced?forum=winforms

## Author

- t-sin (<shinichi.tanaka45@gmail.com>)

## License

MIT license
