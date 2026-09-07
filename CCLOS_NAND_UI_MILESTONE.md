# CCLOS NAND — owner-approved exact UI milestone

**Milestone:** `CCLOS-NAND-EXACT-UI-1.0`  
**Owner decision:** 2026-09-06 · Brian Hinds / Computer Universal Technology Systems

The owner selected the supplied CCLOS screens as the new NAND front-end appearance.
They are binding visual targets, not inspiration and not permission to build a
look-alike. The ordinary CCLOS product and read-only `C:\cctu` donor are not being
redesigned by this milestone.

## Required reading and import gate

Read `docs/ui/CCLOS_NAND_ExactUI/00_IMPLEMENTATION_CONTRACT.md`,
`01_BUILD_ORDER.md`, `03_SCREEN_REGISTRY.json`, `10_CODEX_HANDOFF.md` and
`12_REFERENCE_RECONCILIATION.md`. The full ZIP additionally contains geometry,
actions, candidate assets, all original PNGs and host validation/publishing tools.

The initial connector commit establishes the instructions, ordered reference
registry and compact SVG state sources. **It does not claim the original PNG
batch has already been uploaded.** Verify the registered paths and SHA-256 hashes.
If any original is absent, STOP visual implementation and import the exact package;
never generate substitutes, use thumbnails, or start a different dashboard.

After extracting `CCLOS_NAND_ExactUI_v1.0.zip` on the Windows development PC, run
this command from its extracted root to publish the complete allowlisted batch:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\ui\Publish-CCLOSExactUI.ps1 -Publish
```

The publisher uses normal local Git authentication, a dedicated clean clone of
`CGameDev/CCLOS_NAND`, SHA-256 checks and a non-force push. It does not read or
upload NAND samples, console secrets or `C:\cctu`, and does not deploy to a console.
An existing different file is a reviewable conflict, not permission to overwrite.

## Exact sequence

1. Global shell: background, logo, top navigation, profile area, footer HUD.
2. Shared components: tile, hero panel, right-side information panel, list rows, category tabs, buttons, focus states.
3. Main screens: Home, My Games, Store, Downloads, Settings, Media.
4. Submenus: Game Detail, Download Detail, Network Settings, Interface Customization, Live TV Guide, Movies/Media Browse, DLC/Title Updates.
5. Supplemental references: Continue Playing, Game Library, Store Product Detail. These do not replace the six main screens.

**On-screen** tab order remains Home / My Games / Media / Store / Downloads /
Settings; implementation order must not accidentally change navigation order.

## Authority and evidence

The owner-uploaded Home is the shared-shell master. Source dimensions are
1672 x 941. Its SHA-256 is
`697407b2205cbe76e83aea06624bdaec6bc9d2af78b1a4e60ffe16bd923b180a`.
Other registered PNGs govern screen bodies; minor generated header/footer shifts
do not authorize multiple shell layouts. Original files stay unchanged.

Reference PNGs and source pixel crops are not a finished runtime UI. Build real
interactive C++ controls and existing service bindings. Never display a complete
screenshot behind invisible hotspots and call it the dashboard. No new desktop/
web framework is authorized. Transparent masks, clean background, vector widgets
and icons are reconstructed candidates, not recovered original layered files;
the exact original font is unverified and no font files are bundled.

Every checkpoint needs a real renderer capture, overlay/difference review,
controller/route tests and a focused rollback commit. Missing artwork, unknown
font metrics or an absent service is a specific blocker, not a reason to redesign.
No visual-accuracy percentage, frame-rate claim, flash-fit claim or hardware success
may be invented.

## Data, scope and safety

Preserve existing catalog/manifest handling, single/segmented downloads, queue,
resume/extraction, media, profile/achievement, disc and plugin semantics. Keep all
existing destinations reachable through a documented mapping. Do not fabricate
prices/purchases, Xbox Live connectivity, cloud saves, campaign/social data,
network speed or unsupported platform features from the sample artwork. Replace
sample values with real data in the same bounds; use honest unavailable states.

This explicitly approved milestone supersedes old **visual-preservation** wording
for the listed NAND surfaces only. Source freezing, backend behavior, no-storage
core boot, XboxSystemBridge isolation, console-specific NANDs, private-data rules,
Recovery/XeLL preservation and all no-flash gates in root AGENTS.md remain binding.
The PNGs/gallery are development material, not the flash payload or a bootable XEX.
