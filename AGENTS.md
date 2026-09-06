# AGENTS.md — CCLOS NAND Edition

These rules govern all Codex work in this repository.

## 1. Absolute baseline rule

The owner-approved product baseline is the **latest validated local CCLOS source workspace** at:

`C:\cctu`

The currently observed source reports:

- `CONSOLECRATE_VERSION "0.35.4"`
- `CONSOLECRATE_VERSION_LABEL "0.35.4 Internet Updates"`

The earlier CCLOS Public Beta v0.35.2 release is a historical/public comparison point only. The owner has explicitly authorized using the latest local source, so exact v0.35.2 source provenance is **not** a blocker.

Before implementation, Codex must freeze the exact approved local donor state into `src/CCLOS/`, record donor Git/worktree state, generate a complete source/resource manifest, hash that manifest, build the imported baseline, and update `baseline/baseline.lock.json`.

`C:\cctu` is read-only for this project. Do not reset, clean, checkout, stash, rebase, rewrite, or otherwise mutate that donor workspace merely to obtain a clean baseline.

If the donor working tree contains owner-approved uncommitted fixes, preserve those exact changes in the frozen import. In that case the complete source manifest, together with the donor HEAD SHA and dirty-state report, defines the immutable baseline.

## 2. UI is locked

CCLOS NAND Edition is a platform/firmware adaptation of CCLOS, not a new dashboard design.

Unless an owner-approved milestone explicitly authorizes a visible change, preserve the frozen owner-approved baseline exactly for:

- Home and all existing main destinations;
- top HUD and bottom HUD;
- navigation rail and destination order;
- page geometry and safe areas;
- focus and controller behavior;
- fonts, colors, translucency, backgrounds, borders, spacing, icons and artwork treatment;
- wording/terminology;
- Quick Guide/Control Center presentation already present in the baseline;
- existing feature entry points, dialog patterns and status screens.

Never create an alternative NAND-themed UI. Never redesign CCLOS to resemble NXE, Metro, Aurora, Freestyle Dash, Fusion, Windows, Android recovery, or any unrelated reference unless the owner explicitly requests it in a later milestone.

New system/NAND/recovery functions must be inserted using the existing CCLOS visual language and existing reusable renderer/components.

## 3. Product definition

CCLOS NAND Edition must be a **flash-resident system shell**.

It must not require:

- `Hdd1:`;
- onboard MU;
- USB storage;
- removable memory;
- a network share;
- an HDD copy of `CCLOS.xex`;
- an HDD-only `launch.ini`;

in order to boot to the CCLOS shell and provide core console functions.

Removing all user storage must still permit the console to boot CCLOS, enter Settings/System Health/Network/Display/Audio, use controllers, operate the optical drive, launch compatible physical media, access supported Xbox system services and enter recovery.

Storage-dependent pages must show a normal empty/no-storage state rather than failing the shell.

## 4. Retained Xbox platform

Do not attempt to replace the Xbox 360 boot ROM, core boot chain primitives, hypervisor, kernel, XAM, XUser, XContent, XNet, XAudio/XAV, hardware drivers or other required Microsoft platform services with speculative replacements.

CCLOS replaces the **retail dashboard shell**, not the underlying Xbox platform.

Implement user-facing retail-system parity through:

1. documented/validated Xbox platform APIs where available;
2. an isolated `XboxSystemBridge` wrapper for verified system interfaces;
3. CCLOS-native implementations where the retail feature lived in the retail shell rather than a reusable system service.

Do not spread private ordinals or undocumented calls throughout UI code. Keep them isolated, validated, version-aware and fail-closed.

## 5. No retail dashboard dependency

The complete retail NXE/Metro dashboard is not required as a fallback and must not be retained solely for UI parity.

Target recovery:

- Power -> CCLOS
- supported Recovery trigger -> CCLOS Recovery
- Eject -> XeLL
- CCLOS startup failure -> CCLOS Recovery where the boot path remains viable

The project may retain only Microsoft system components actually required by the Xbox platform and CCLOS feature set.

## 6. Flash versus writable storage

Immutable, boot-critical CCLOS components belong in the flash-system build when size permits.

Writable/high-churn data must not be written repeatedly to system flash. Use a storage-provider abstraction supporting the storage classes available on the console, including HDD, internal/onboard MU and supported USB storage.

Examples of writable data: profiles, saves, preferences, queues, caches, logs, history, artwork, downloads, DLC, title updates, games, trainers and third-party plugins.

When no writable storage exists, use built-in defaults plus temporary RAM state and expose a clear no-storage state.

## 7. NAND-image rules

Never ship or generate one universal ready-to-flash NAND image.

Every output image must derive from the target console's own NAND and preserve/validate all applicable console-specific data, including at minimum:

- KeyVault;
- Console ID;
- DVD key;
- region/configuration;
- SMC and SMC configuration;
- motherboard/NAND geometry;
- existing supported exploit/hack configuration;
- bad-block mapping/remapping;
- CPU-key validation requirements;
- XeLL recovery behavior.

No flash write is permitted in early milestones.

## 8. DashLaunch/plugin compatibility

The NAND Edition must preserve the established DashLaunch-compatible runtime/plugin ecosystem where technically required.

Do not erase or reorder existing user plugin configuration without an explicit migration rule. CCLOSRuntime must coexist with third-party plugins.

Stealth-server compatibility means **coexistence**, not implementing stealth or bypass logic inside CCLOS. CCLOS must never silently disable LiveBlock/LiveStrong or other user protection settings just to obtain network access.

## 9. Baseline-first development workflow

Before changing product source:

1. audit `C:\cctu` read-only;
2. record donor HEAD/branch/worktree state and current version/build label;
3. import the exact owner-approved local source state without modifying the donor;
4. generate and hash a complete source/resource manifest;
5. build the imported baseline with the established Xbox 360 toolchain;
6. inventory menus/pages/assets and confirm expected behavior;
7. update `baseline/baseline.lock.json` and `docs/BASELINE_FREEZE_REPORT.md`;
8. only then start NAND-specific refactoring.

Every milestone must state what baseline behavior is preserved and must have a rollback point.

## 10. Testing discipline

Prefer several coherent implementation checkpoints before requiring risky hardware NAND tests.

Required progression:

- host/static validation;
- Xbox 360 Debug/Release build validation;
- package/resource validation;
- flash-layout and image parser validation;
- deterministic NAND build comparison;
- recovery-package validation;
- image verification;
- sacrificial/development console test with external programmer recovery available;
- prove CCLOS Recovery and Eject -> XeLL recovery on supported hardware;
- only much later: integrated flashing.

No milestone may claim hardware success without owner-reported physical-console acceptance.

## 11. Do not guess

When information is unknown—NAND structure, ordinal, XAM behavior, source provenance, flash path, board-specific storage, boot-stage behavior, file format, recovery entry trigger, flash writer behavior or system setting—do not invent an answer in code.

Use proven Xbox 360/XDK/xeBuild/J-Runner/DashLaunch/XeLL/rawflash references where licensing permits. Mark unsupported cases explicitly and fail safely.

## 12. Ownership

Project/product: **ConsoleCrate Live OS / CCLOS NAND Edition**

Development/branding ownership: **Computer Universal Technology Systems** / Brian Hinds, consistent with the existing CCLOS source headers and project conventions.

## 13. Novice-safe recovery is a product requirement

Read `docs/RECOVERY_ARCHITECTURE.md` before implementing any NAND writer, updater or recovery path.

The intended owner experience is similar in convenience to a consumer-device recovery environment: ordinary supported software/firmware failures should be recoverable from CCLOS Recovery or XeLL using a verified console-specific USB recovery package without opening the Xbox 360.

This does **not** mean the console is unbrickable. If neither CCLOS Recovery nor XeLL can execute, an external NAND programmer may still be required.

Mandatory rules:

- CCLOS Recovery must be flash-resident enough to start and show basic diagnostics with no HDD/MU/USB/network present.
- Eject -> XeLL must remain an independent emergency path on supported builds.
- Do not expose a generic `browse for .bin -> flash` workflow to normal users.
- A recovery write action remains disabled until package hash, image geometry, motherboard family, console-specific identity/preservation, SMC/config, exploit/build compatibility, bad-block/remap state and recovery prerequisites are positively validated as applicable.
- Unknown validation state means **do not write**.
- Wrong-console/wrong-NAND/wrong-hash packages must be rejected before any NAND modification.
- Create and verify a preflash backup whenever the integrated recovery writer has a proven writable destination and board-specific dump support.
- Preserve a verified Last Known Good recovery option on user storage when possible.
- Provide a no-write Safe Mode before suggesting a full reflash.
- Missing or corrupt optional plugins/settings must not force a NAND reflash.
- Never claim power-loss-proof or unbrickable flashing.
- Normal CCLOS updates must not casually replace the recovery/XeLL layer; recovery-layer updates require explicit compatibility validation.
- The PC builder must eventually generate both the normal CCLOS image and a console-specific XeLL-compatible rescue `updflash.bin` workflow where supported.
- Integrated flashing remains unauthorized until the recovery architecture, backup workflow, validation gates and physical-hardware tests are accepted.

The release is not considered novice-ready until a supported user can recover an ordinary CCLOS software/firmware failure without needing to understand CPU keys, KeyVaults, bad blocks, xeBuild or J-Runner.

## 14. Private console data and external sample library

The tracked `PrivateConsoleData/` directory is documentation only. Real console-specific development data is stored **outside the Git repository** at:

```text
C:\CCLOS-NAND-Development\PrivateConsoleData\
```

The consolidated multi-console NAND sample library is at:

```text
C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\
```

Read `PrivateConsoleData/README.md` and `docs/LOCAL_SAMPLE_LIBRARY.md` before using real NAND data.

When a NAND/parser/builder/recovery/hardware milestone needs real console data, Codex must check these external locations **before asking the owner to provide files again**.

Expected behavior:

1. Check the primary external references under `C:\CCLOS-NAND-Development\PrivateConsoleData\`.
2. For multi-sample analysis, inspect `C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\` and read `_Manifest\CCLOS_NAND_Samples.json` when present.
3. Inventory the actual sample folders rather than assuming a fixed count; the library can grow over time.
4. Identify candidate NAND dumps, CPU-key files, build logs, launch/plugin configuration, XeLL output and related owner-provided diagnostics by content/type where practical.
5. Validate relationships between each NAND, CPU key, hardware identity/configuration and any known-good RGH image before relying on them.
6. Use multiple samples to distinguish motherboard/NAND-layout constants from console-specific bytes.
7. Include bad-block/remap samples and differing xeBuild option combinations in parser/builder validation when available.
8. Treat anything under `Needs_Review\` as untrusted until positively classified.
9. Continue the milestone automatically when required inputs are present and valid.
10. Ask the owner only when a genuinely required input is missing, corrupt, ambiguous, inconsistent or unsafe to infer.
11. Treat all owner-provided originals as read-only. Never modify them in place.
12. Write derived analysis/build/recovery artifacts only under the external working paths:

```text
C:\CCLOS-NAND-Development\Working\
C:\CCLOS-NAND-Development\Builds\
C:\CCLOS-NAND-Development\Recovery\
C:\CCLOS-NAND-Development\Logs\
```

Security requirements:

- Never commit real NAND/sample data. Only the tracked documentation contract belongs in the repository.
- Never copy a real NAND, CPU key, decrypted KeyVault, DVD key, Console ID or other console secret into a tracked source/docs/test-fixture path.
- Never print a full CPU key, decrypted KeyVault, DVD key or comparable secret into normal logs, GitHub issues, PRs, screenshots, support bundles or public manifests.
- Use redacted identifiers, hashes or non-secret fingerprints for correlation where needed.
- Never upload private console files to external/third-party services as part of development or diagnostics.
- Keep public test fixtures synthetic/sanitized.
- The presence of the sample library authorizes read/analyze/compare/offline-build validation only. It does not authorize NAND flashing.

The original NAND plus a matching CPU key should be treated as the primary console-specific source of truth. Do not require separately supplied KV/SMC files when they can be safely extracted and validated from the source NAND.

## 15. Local development tool/reference paths

Known owner-confirmed local environment:

```text
CCLOS donor source (READ ONLY):
C:\cctu

J-Runner with Extras reference installation (READ ONLY):
C:\Users\CGAmeDev\Downloads\J-Runner-with-Extras

Private NAND workspace:
C:\CCLOS-NAND-Development\PrivateConsoleData\

Sample library:
C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\

Derived outputs:
C:\CCLOS-NAND-Development\Working\
C:\CCLOS-NAND-Development\Builds\
C:\CCLOS-NAND-Development\Recovery\
C:\CCLOS-NAND-Development\Logs\
```

The owner has confirmed the Visual Studio 2010/Xbox 360 XDK build environment is working, the designated first hardware test console is an RGH3 Trinity 16 MB, the console is reachable through Xbox 360 Neighborhood, and a NAND backup exists.

J-Runner is initially a comparison/reference implementation. Do not modify its installed files and do not invoke NAND write operations from it during early milestones.