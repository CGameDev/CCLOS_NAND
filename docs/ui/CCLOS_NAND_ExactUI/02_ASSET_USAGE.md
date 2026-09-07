# Asset usage rules

## Authoritative originals

Files under the registered `03_main_screens`, `04_submenus`, and `05_supplemental` paths are immutable visual evidence. Do not edit, repaint, recompress, resize in place, or replace them to make a visual comparison pass.

## Global-shell and component crops

Source-pixel crops are exact comparison references for geometry, color, typography hierarchy, borders, focus treatment and spacing. Dynamic fields inside a crop must still be implemented as live controls; a crop is not permission to ship baked profile names, dates, rates, storage values or game data.

## Background limitation

A flattened screenshot cannot reveal pixels hidden behind tiles. A visible-pixel background reference may preserve the exposed pixels and make covered regions transparent, but it must never be called a recovered original wallpaper. Search the frozen donor/resources first. If the underlying art cannot be recovered, create a reconstruction candidate, compare it against every visible source region, and require owner approval rather than changing the design.

## SVG/vector candidates

Reconstructed vector frames are implementation candidates only. Source PNG pixels win whenever a vector candidate differs.

## Fonts

No font file is authorized by this package. Do not download a random similar web font. Audit the frozen project font stack and renderer metrics locally. If the exact metrics cannot be established, record that specific blocker instead of silently changing layout.
