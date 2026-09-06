# M0 — Resolve, Import, Build and Freeze CCLOS Public Beta v0.35.2

**Status:** BLOCKED ON EXACT v0.35.2 SOURCE PROVENANCE

## Goal

Establish an immutable, buildable copy of the **exact source that produced CCLOS Public Beta v0.35.2** inside this repository before any NAND-specific product change is made.

This milestone exists specifically to prevent Codex from starting a new UI, approximating a missing release, or modifying an older CCLOS revision and calling it NAND Edition.

## Governing rules

Read and obey, in order:

1. `/AGENTS.md`
2. `/BASELINE_LOCK.md`
3. `/baseline/baseline.lock.json`
4. `/docs/ARCHITECTURE.md`
5. `/docs/NAND_SAFETY.md`

## Known starting evidence

Public baseline:

`CCLOS_Public_Beta_v0.35.2.zip`

Public artifact URL:

`http://consolecrate.xyz/updates/CCLOS_Public_Beta_v0.35.2.zip`

Donor repository:

`https://github.com/CGameDev/ConsoleCrateLive.git`

Expected source family:

`CCLOS`

Observed donor branch state when this NAND repository was initialized:

- ref: `CCLOS`
- commit: `b799070d40b46e2f9895ef8e0d988fda866b963c`
- version reported by `ConsoleCrateNativeStore/ConsoleCrateVersion.h`: `0.34.0`

Therefore this observed branch head is **not approved as the v0.35.2 baseline** without independent provenance.

## Tasks

### M0-T001 — Provenance resolution

Run:

```powershell
.\tools\Resolve-CCLOSBaseline.ps1
```

Search donor branches/tags/history or owner-provided source for the exact v0.35.2-producing revision.

Do not edit version constants to make an older revision say `0.35.2`.

Do not merge later UI by inspection.

Do not reconstruct the public beta from the binary package.

**Output:** exact 40-character commit SHA plus evidence linking it to the public artifact.

### M0-T002 — Public artifact hash

Using the actual distributed ZIP, calculate SHA-256 and record it in `baseline/baseline.lock.json`.

Do not upload the public binary package to this repository merely to satisfy this task unless the owner explicitly requests it and redistribution is appropriate.

### M0-T003 — Exact source import

Once the commit is proven, run:

```powershell
.\tools\Import-CCLOSBaseline.ps1 -CommitSha <40-character-sha>
```

The import goes to:

`src/CCLOS/`

The import script copies source without modifying it and generates:

`src/CCLOS-baseline-manifest.sha256`

Record the manifest SHA-256 in `baseline/baseline.lock.json`.

### M0-T004 — Baseline build

Build the imported baseline using its established Xbox 360 toolchain. Do not introduce NAND changes just to make the build pass.

Expected family:

- Visual Studio 2010 solution/tooling
- Xbox 360 XDK 21256.x class toolchain
- existing Release/Debug Xbox 360 configurations

Document exact build host assumptions and errors if the imported source requires unavailable local-only files.

### M0-T005 — UI/behavior inventory

Create a deterministic inventory of the public baseline's established visible product. At minimum identify:

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
- Social Hub if present in v0.35.2;
- Quick Guide/Control Center if present in v0.35.2;
- primary dialogs/status/progress surfaces;
- fonts, renderer resources, backgrounds and UI chrome assets.

This is an inventory, **not** permission to redesign.

### M0-T006 — Baseline freeze report

Create `docs/BASELINE_FREEZE_REPORT.md` containing:

- exact source commit;
- public artifact SHA-256;
- source manifest SHA-256;
- build result;
- UI inventory summary;
- any public-artifact/source discrepancy;
- explicit statement that no NAND-specific product behavior was introduced.

Update `baseline/baseline.lock.json` to `resolved: true` only after all required evidence exists.

## Prohibited work during M0

Do not:

- create a new dashboard shell;
- redesign any page;
- change the HUD;
- change fonts/colors/icons/translucency/navigation;
- introduce NAND paths;
- introduce a new settings UI;
- implement XboxSystemBridge;
- rewrite storage code;
- add xeBuild/J-Runner integration;
- add a flasher;
- generate a test NAND;
- copy retail Xbox dashboard UI/assets.

M0 is provenance + import + build + inventory only.

## Acceptance criteria

M0 closes only when:

- [ ] exact v0.35.2 source revision is proven;
- [ ] immutable commit SHA is recorded;
- [ ] public artifact SHA-256 is recorded;
- [ ] exact baseline source is present under `src/CCLOS/`;
- [ ] source manifest is generated and hashed;
- [ ] baseline Debug/Release build status is documented;
- [ ] public v0.35.2 UI/behavior inventory is documented;
- [ ] no NAND implementation or UI redesign has occurred;
- [ ] `baseline/baseline.lock.json` is resolved;
- [ ] owner has a concise handoff report.

## Stop condition

If the exact v0.35.2 source cannot be found, **stop here** and report the missing provenance. The correct action is to obtain or publish that source revision—not to let Codex approximate it.