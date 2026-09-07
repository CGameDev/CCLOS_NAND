# CCLOS NAND ExactUI — authoritative asset root

This directory is reserved for milestone `CCLOS-NAND-EXACT-UI-1.0`.

The owner-approved screen set is **not inspiration**. It is the binding visual target for the CCLOS NAND front end. `03_main_screens/01_Home.png` is the global-shell master; the other registered PNGs own their screen bodies.

## Required order

1. `01_global_shell`: background, logo, top navigation, profile/status area, footer HUD.
2. `02_shared_components`: tile, hero, right-side info panel, list row, category tabs, buttons, focus states.
3. `03_main_screens`: Home, My Games, Store, Downloads, Settings, Media.
4. `04_submenus`: Game Detail, Download Detail, Network Settings, Interface Customization, Live TV Guide, Movies/Media Browse, DLC/Title Updates.
5. `05_supplemental`: Continue Playing, Game Library, Store Product Detail.

On-screen navigation remains `Home / My Games / Media / Store / Downloads / Settings` even though implementation order places Store before Media.

## Binary import gate

The complete owner-approved binary package is named `CCLOS_NAND_ExactUI_v1.0.zip` and has SHA-256:

`56037f4dea206c12304891fa33092aa79a2479a7749b26d091487035bd9be08c`

Before UI code begins, run the package validator and import the PNGs into the exact paths registered in `docs/ui/CCLOS_NAND_ExactUI/03_SCREEN_REGISTRY.json`. If a required PNG is absent or its hash differs, **stop visual implementation**. Do not regenerate a substitute or build a look-alike.

Reference PNGs are development evidence, not a flattened runtime UI. Implement real interactive controls and bind existing CCLOS services/data.