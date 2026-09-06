# M0 — Snapshot, Import, Build and Freeze Owner-Approved Local CCLOS Baseline

**Status:** READY FOR LOCAL BASELINE FREEZE

## Goal

Establish an immutable, buildable copy of the **owner-approved latest local CCLOS source** from:

`C:\cctu`

inside this repository before any NAND-specific product change is made.

The currently observed source reports:

- version: `0.35.4`
- build label: `0.35.4 Internet Updates`

The earlier Public Beta v0.35.2 remains a historical comparison point only. The owner has explicitly approved using the latest local source, so exact v0.35.2 source provenance is no longer a blocker.

This milestone exists to prevent Codex from modifying the live donor workspace, inventing missing source, redesigning the UI, or starting NAND work before the exact donor state is frozen.

## Governing rules

Read and obey, in order:

1. `/AGENTS.md`
2. `/BASELINE_LOCK.md`
3. `/baseline/baseline.lock.json`
4. `/docs/ARCHITECTURE.md`
5. `/docs/NAND_SAFETY.md`
6. `/docs/LOCAL_SAMPLE_LIBRARY.md`

## Known local development environment

```text
CCLOS donor source:
C:\cctu

J-Runner with Extras reference install:
C:\Users\CGAmeDev\Downloads\J-Runner-with-Extras

Private console data:
C:\CCLOS-NAND-Development\PrivateConsoleData\

Multi-console NAND sample library:
C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\

Derived working output:
C:\CCLOS-NAND-Development\Working\
C:\CCLOS-NAND-Development\Builds\
C:\CCLOS-NAND-Development\Recovery\
C:\CCLOS-NAND-Development\Logs\
```

The donor source, J-Runner installation, original NANDs, CPU keys and known-good RGH images are read-only reference inputs unless a later owner-approved milestone explicitly says otherwise.

## Tasks

### M0-T001 — Read-only donor audit

Run the local baseline resolver against `C:\cctu`:

```powershell
.\tools\Resolve-CCLOSBaseline.ps1 -SourcePath 'C:\cctu'
```

Record at minimum:

- resolved source path;
- Git top-level path;
- Git directory/worktree arrangement;
- current branch when available;
- full HEAD commit SHA;
- clean/dirty working-tree state;
- `CONSOLECRATE_VERSION`;
- `CONSOLECRATE_VERSION_LABEL`;
- a sanitized list of changed/untracked paths if the donor is dirty.

Do not run `git reset`, `git clean`, checkout another branch, rebase, stash, or otherwise mutate the donor merely to make it clean.

A dirty working tree is acceptable because the owner may have fixes newer than the last committed source.

### M0-T002 — Freeze identity

The frozen baseline identity must be reproducible.

If the donor is clean:

- record the full HEAD SHA;
- record version/build label;
- import the exact source;
- generate a full source/resource SHA-256 manifest.

If the donor is dirty:

- record the full HEAD SHA;
- record that the working tree is dirty;
- record sanitized changed/untracked paths;
- import the exact approved local working-tree source state;
- generate a full source/resource SHA-256 manifest.

For a dirty donor, the **manifest hash is authoritative for the frozen local state**. Do not silently discard or reconstruct local changes.

### M0-T003 — Exact local source import

Run:

```powershell
.\tools\Import-CCLOSBaseline.ps1 -SourcePath 'C:\cctu'
```

The import goes to:

`src/CCLOS/`

The script must not modify `C:\cctu`.

The importer may exclude only clearly transient/non-source material such as:

- Git metadata;
- `.tmp` scratch content;
- intermediate Debug/Release/LTCG build output;
- IDE caches;
- packaged release ZIPs;
- deployment backups;
- private secrets;

unless a reviewed dependency check proves a specific excluded item is build-required.

Generate:

`src/CCLOS-baseline-manifest.sha256`

and record its SHA-256 in `baseline/baseline.lock.json`.

### M0-T004 — Baseline build

Build the imported baseline using its established Xbox 360 toolchain. Do not introduce NAND changes merely to make the build pass.

Expected environment is already owner-confirmed:

- Visual Studio 2010;
- Xbox 360 XDK 21256.x-class toolchain;
- established Xbox 360 Debug/Release configurations.

Document the exact build result and any local-only dependency that is genuinely required.

### M0-T005 — UI/behavior inventory

Create a deterministic inventory of the owner-approved baseline's established visible product. At minimum identify:

- all top-level destinations;
- navigation order;
- top/bottom HUD ownership;
- Home layout;
- Shop/Marketplace layout;
- My Collection;
- Queue;
- Downloads;
- Achievements;
- System Health;
- Settings;
- Network;
- Data;
- About;
- Security;
- Watch TV/media;
- Social Hub if present;
- Quick Guide/Control Center if present;
- primary dialogs/status/progress surfaces;
- fonts, renderer resources, backgrounds and UI chrome assets.

This is an inventory, **not** permission to redesign.

### M0-T006 — Baseline freeze report

Create `docs/BASELINE_FREEZE_REPORT.md` containing:

- source path `C:\cctu`;
- donor HEAD SHA;
- branch/worktree state;
- clean/dirty state;
- frozen version/build label;
- source manifest SHA-256;
- build result;
- UI inventory summary;
- sanitized description of included local changes when applicable;
- explicit statement that no NAND-specific product behavior was introduced.

Update `baseline/baseline.lock.json` to `resolved: true` only after the frozen import, manifest and build evidence exist.

## Prohibited work during M0

Do not:

- modify `C:\cctu`;
- modify the J-Runner installation;
- create a new dashboard shell;
- redesign any page;
- change the HUD;
- change fonts/colors/icons/translucency/navigation;
- introduce NAND paths into the baseline merely to finish M0;
- implement XboxSystemBridge;
- rewrite storage code;
- add a flasher;
- generate or flash a test NAND;
- copy retail Xbox dashboard UI/assets;
- commit real NANDs, CPU keys, KeyVault data or other console secrets.

M0 is local-baseline freeze + import + build + inventory only.

## Acceptance criteria

M0 closes only when:

- [ ] `C:\cctu` is audited read-only;
- [ ] donor HEAD/branch/worktree state is recorded;
- [ ] owner-approved version/build label is recorded;
- [ ] exact local source state is present under `src/CCLOS/`;
- [ ] source/resource manifest is generated and hashed;
- [ ] baseline Debug/Release build status is documented;
- [ ] UI/behavior inventory is documented;
- [ ] no NAND implementation or UI redesign has occurred;
- [ ] `baseline/baseline.lock.json` is resolved;
- [ ] owner has a concise handoff report.

## Stop condition

Stop only if the local donor cannot be read safely, the version cannot be identified, the import cannot be reproduced, required build inputs are genuinely missing, or the imported source cannot be tied to the frozen manifest.

Do **not** stop merely because the source is newer than v0.35.2 or because the donor working tree contains owner-approved local fixes.