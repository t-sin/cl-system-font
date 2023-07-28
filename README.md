# cl-system-font

*cl-system-font* is a simple accessor library for font configurations on your systems.
STATUS: under development

## Requirements

- GNU/Linux or POSIX systems: [fontconfig](https://www.freedesktop.org/wiki/Software/fontconfig/)
- [DOING] mac OS: none (maybe)
- [TODO] Windows: none (maybe)

## Usage

To get all fonst installed on your system, do this:

```lisp
CL-USER> (sysfont:font-info-list)
...
```

Font infomation are includes these items:

- font file path (as absolute path)
- font file format
- font name
- font families (this may be multiple values)
- font styles (this may be multiple values)
- font spacing (like proportional, monospaced or something)
- supported languages (this may be multiple values)

## References

- UNIX/Linux: fontconfig
    - [`fc-list`'s default format is `%{=fclist}`](https://gitlab.freedesktop.org/fontconfig/fontconfig/-/blob/f07d7c67e4de05c25ee391e99ee9368f1136317d/fc-list/fc-list.c#L181)
    - `fclist` is described [here](https://www.freedesktop.org/software/fontconfig/fontconfig-devel/fcpatternformat.html)
    - `fclist` format is [`%{?file{%{file}: }}%{-file{%{=unparse}}}`](https://gitlab.freedesktop.org/fontconfig/fontconfig/-/blob/f07d7c67e4de05c25ee391e99ee9368f1136317d/src/fcformat.c#L80)
    - `unparse` is generated [here](https://gitlab.freedesktop.org/fontconfig/fontconfig/-/blob/f07d7c67e4de05c25ee391e99ee9368f1136317d/src/fcname.c#L636)

## Author

- t-sin (<shinichi.tanaka45@gmail.com>)

## License

MIT license
