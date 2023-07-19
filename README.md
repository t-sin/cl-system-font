# cl-system-font

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
