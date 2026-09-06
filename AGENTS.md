# AGENTS.md — CCLOS NAND Edition

These rules govern all Codex work in this repository.

## 1. Absolute baseline rule

The product baseline is **CCLOS Public Beta v0.35.2**.

Public artifact:

`http://consolecrate.xyz/updates/CCLOS_Public_Beta_v0.35.2.zip`

Source donor repository:

`https://github.com/CGameDev/ConsoleCrateLive.git`

Expected source family: `CCLOS`.

The source currently visible on branch `CCLOS` reports version `0.34.0`. Do **not** treat that source as v0.35.2 without evidence. Locate the exact source revision that produced the v0.35.2 public beta and record the immutable commit SHA in `baseline/baseline.lock.json` before implementation.

If the exact v0.35.2 source revision is unavailable, stop after documenting the mismatch. Do not recreate missing source, UI, assets, behavior, or feature changes by guessing.

## 2. UI is locked

CCLOS NAND Edition is a platform/firmware adaptation of CCLOS, not a new dashboard design.

Unless an owner-approved milestone explicitly authorizes a visible change, preserve the v0.35.2 public release exactly for:

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

1. resolve exact v0.35.2 baseline source;
2. record commit SHA and artifact identity;
3. import baseline without behavior changes;
4. build the imported baseline with the established Xbox 360 toolchain;
5. compare menus/pages/assets against the public beta;
6. produce a baseline manifest/hash report;
7. only then start NAND-specific refactoring.

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
