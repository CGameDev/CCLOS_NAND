# Sequential Codex checkpoints

Use prefix **UI-Uxx**, distinct from the existing NAND M0–M15 roadmap. Existing
baseline M0 must pass before product-source changes. The flash/dependency/recovery
budget audit must constrain asset packaging before a flash-oriented release.

| Gate | Required work | Evidence before proceeding |
|---|---|---|
| UI-U00 | Verify repository, baseline, 16 references, manifest and feature inventory | Audit report with actual paths/APIs, missing-assets list, clean rollback point |
| UI-U01 | Inventory/extract assets; prove font metrics; classify flash-core vs optional artwork | Asset ledger, source provenance, transparency/atlas proof and storage budget; unresolved layers remain blocked |
| UI-U02 | Shared shell only: background, logo, navigation, profile area, footer | Fixture capture at source ratio/720p, shell overlay/diff, profile/offline/no-storage states |
| UI-U03 | Tile, hero, right-info panel, list row, category tab, button, focus-state families | Five-state proof sheet, nine-slice corner proof, exactly one focus owner, controller tests |
| UI-U04 | Home | Same geometry as the owner source; all 11 Home entry points and download widget routed; fixture and live-state captures |
| UI-U05 | My Games | Existing collection/favorites/recent/disc data; verified Play/Details/Achievements commands; library virtualization |
| UI-U06 | Store | Existing catalog/manifest access; all existing categories reachable; no fabricated purchase/recommendation system |
| UI-U07 | Downloads | Existing queue/status/progress services; existing single/segment/resume mechanism unchanged; operations retain capability gates |
| UI-U08 | Settings | Shared tiles; existing settings/actions reachable; real version; app update and future NAND recovery clearly separated |
| UI-U09 | Media | Existing player, source discovery and metadata; capability-based sources; download service survives page switches |
| UI-U10 | Seven listed submenu screens in their numbered order | Per-screen controller, empty/error/unsupported and visual proofs |
| UI-U11 | Three supplemental bodies + inherited-page bridge audit | No duplicate main screens; no lost existing destination; remaining unapproved layouts explicitly listed |
| UI-U12 | Integration, memory/flash audit, regression and owner acceptance | Build logs, genuine captures, CPU/GPU/memory measurements, no-storage tests, rollback proof |

## Each checkpoint must do the same loop

Read the target image and its layout/action specification. State the exact scope
and touched source files. Implement only that scope. Build with the established
local toolchain. Run structural/unit tests. Render a deterministic fixture state.
Capture the actual renderer output. Compare it with the source target and examine
an overlay plus difference image. Fix deviations without changing the references.
Then run live-data, empty/offline and controller tests. Record remaining gaps and
commit a focused rollback point.

Use `UI_CHECKPOINT_REPORT_TEMPLATE.md` for each report. Never mark a later gate
complete solely because shared placeholder widgets exist.

## Owner review gates

Owner visual approval is required after the shared shell/components, after Home,
and at the complete-screen acceptance gate. Genuine blockers requiring new
artwork, a different font, different geometry or additional feature scope are
approval requests, not permission to improvise. No routine checkpoint should ask
the owner to re-supply information already present in the repository/local paths.

## Separate production milestones

Firmware parser/build/recovery work retains its existing roadmap and safety gates.
This design package does not move M15 forward or grant any NAND write permission.
