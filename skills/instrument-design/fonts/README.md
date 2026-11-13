# Bundled fonts

Self-hosted rather than fetched from a CDN: a display that loses its typeface
when the internet drops is not offline-capable. Only the Latin subsets of the
Latin faces are here, which is why those three total about 65 KB. Monaspace
Neon is the exception: see below.

All are licensed under the **SIL Open Font License 1.1**, which permits
redistribution alongside this project. None is covered by the repository's
MIT licence. Keep the licence files with the fonts when you copy them.

| File | Family | Source | Licence |
|---|---|---|---|
| `archivo-var.woff2` | Archivo (variable, 400–700) | https://fonts.google.com/specimen/Archivo | [OFL-1.1](OFL-Archivo.txt) |
| `plexmono-400.woff2`, `plexmono-500.woff2` | IBM Plex Mono | https://fonts.google.com/specimen/IBM+Plex+Mono | [OFL-1.1](OFL-IBMPlexMono.txt) |
| `monaspace-neon-var.woff2` | Monaspace Neon 1.400 (variable, 200–800, width 100–125, slant 0 to −11) | https://monaspace.githubnext.com/ · [release v1.400](https://github.com/githubnext/monaspace/releases/tag/v1.400) | [OFL-1.1](OFL-Monaspace.txt) |
| `Manjari-Regular.woff2`, `Manjari-Bold.woff2` | Manjari 2.200 | https://gitlab.com/smc/fonts/manjari | [OFL-1.1](OFL-Manjari.txt) |

## Monaspace Neon, unmodified

The code face is `Variable Web Fonts/Monaspace Neon/Monaspace Neon Var.woff2`
from `monaspace-webfont-variable-v1.400.zip`, byte for byte; only the file name
is changed. Its licence reserves the name "Monaspace", so a subset or instance
would have to be renamed. The file is kept whole instead. At about 500 KB it is
the heaviest file here, but a browser downloads it only for a page that shows
code. To update it, take the same file from a newer release.

## Adding a script

Manjari, by [Swathanthra Malayalam Computing](https://smc.org.in), is here
because the style's first projects show Malayalam, and Latin faces have no
glyphs for that script at all. The two files are about 185 KB together, more
than everything else combined, so they are declared with a `unicode-range`
covering the Malayalam block and a page with no Malayalam never downloads them.
Do the same for any script you add, and delete Manjari if you don't need it.
