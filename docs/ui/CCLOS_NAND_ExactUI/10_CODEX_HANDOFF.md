# Paste-ready Codex handoff

Implement milestone `CCLOS-NAND-EXACT-UI-1.0` in `CGameDev/CCLOS_NAND`.

First read root `AGENTS.md`, `BASELINE_LOCK.md`, the current baseline lock/report,
`docs/ui/CCLOS_NAND_ExactUI/00_IMPLEMENTATION_CONTRACT.md`,
`01_BUILD_ORDER.md`, `03_SCREEN_REGISTRY.json`, `04_LAYOUTS.json`,
`06_NAVIGATION_AND_ACTIONS.json`, `07_CAPABILITY_AND_DATA_GAPS.md`,
`08_ACCEPTANCE_TESTS.md`, `09_SOURCE_INTEGRATION_MAP.md` and
`12_REFERENCE_RECONCILIATION.md` in that folder. Open the registered images,
not just their filenames. Run `python tools/ui/validate_package.py --root .`.

The screenshot PNGs are the owner's official visual targets, NOT inspiration,
examples or permission to design a similar-looking dashboard. Use the owner's
Home PNG as the master shared shell. Implement the actual live C++ dashboard:
real components, text, controller focus and existing service bindings. Never
substitute a full screenshot with invisible hotspots or a web/desktop prototype.

If any PNG is missing or hash-mismatched, STOP the visual implementation. Import
the attached ZIP with its provided publisher/import instructions. Never generate
a replacement image or continue from a thumbnail because the original is absent.

This is an explicitly approved change to the NAND front end only. Preserve the
read-only `C:\cctu` donor, freeze/build the approved latest local baseline first,
and retain all backend, no-storage, recovery, plugin and NAND safety requirements.
Do not flash hardware or modify boot/recovery configuration for this UI task.

Follow UI-U00 → UI-U12. Build the global shell first (background, logo, top nav,
profile, footer); then the seven component families and their states; then Home,
My Games, Store, Downloads, Settings, Media; then Game Detail, Download Detail,
Network Settings, Interface Customization, Live TV Guide, Movies/Media Browse and
DLC/Title Updates in that exact order. Keep on-screen navigation in the separate
locked order: Home / My Games / Media / Store / Downloads / Settings.

Inspect existing source before naming integration points. Preserve Marketplace,
manifest parsing, single/segmented downloads, extraction/install policy, media
services, achievements, profiles, disc actions and the existing source of truth.
Do not infer fictional features, prices, social data, network rates or platform
capabilities from sample screen content. Follow the reconciliation ledger.

At each checkpoint produce an actual renderer capture, overlay/difference,
controller/route tests and a focused commit. Show the original target beside the
capture. Record any unavailable font/clean artwork/backend as a specific blocker.
Do not claim exactness, hardware success or performance without evidence. Do not
change reference PNGs, hashes, masks or acceptance thresholds to hide deviations.

Begin with UI-U00 only: report the baseline/source/resource inventory and exact
integration points. Continue safe sequential implementation once prerequisite
gates pass; pause at the documented visual owner-approval gates and real blockers.
