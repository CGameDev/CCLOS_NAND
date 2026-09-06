# CCLOS NAND Edition — NAND Safety & Recovery Contract

## Scope

This document defines mandatory safety rules for every CCLOS NAND Edition milestone. These rules override convenience, automation and schedule pressure.

## Unsupported early targets

Do not flash CCLOS NAND Edition to:

- stock/unexploited consoles;
- temporary BadUpdate-only environments;
- temporary ABadAvatar-only environments;
- consoles whose motherboard/NAND type cannot be identified confidently;
- consoles without a verified original NAND backup;
- consoles whose CPU key does not validate the source NAND;
- consoles with unresolved bad-block/layout ambiguity;
- production/user consoles during initial bring-up.

## Initial supported development target

Start with a known-good already-RGH3 **Trinity 16 MB** development console running a known 17559 environment, with:

- original NAND dump;
- CPU key;
- working XeLL;
- known motherboard/NAND geometry;
- known-good current RGH3 image;
- external programmer recovery available;
- owner approval for each hardware test image.

## Mandatory preservation

The builder must never manufacture or replace console identity values. It must preserve/validate all applicable console-specific material from the source NAND, including:

- KeyVault;
- Console ID;
- DVD key;
- region/configuration;
- SMC and SMC configuration;
- motherboard/NAND geometry;
- bad-block mapping/remapping;
- bootloader/build-specific values required by proven xeBuild logic;
- existing supported exploit configuration unless an explicit conversion milestone says otherwise.

## Mandatory pre-build checks

A build must fail closed unless evidence reports at minimum:

```text
✓ Source NAND readable
✓ NAND geometry identified
✓ Motherboard identified
✓ CPU key validates source NAND
✓ KeyVault readable/validated
✓ SMC configuration readable
✓ Existing exploit/build type identified
✓ Bad blocks parsed and accounted for
✓ XeLL recovery plan defined
✓ Original NAND backup verified
✓ CCLOS baseline lock resolved
✓ Flash payload size within board-specific budget
```

## Backup contract

Before the first hardware flash, create and verify a recovery bundle containing at minimum:

```text
Recovery/
  OriginalNAND.bin
  OriginalNAND.sha256
  CPUKey.txt
  NANDInfo.json
  BuildManifest.json
  LastKnownGood.bin
  LastKnownGood.sha256
```

The project must never commit real user CPU keys, KeyVaults, NAND dumps, DVD keys, console IDs or other console secrets to GitHub.

## Flash policy by phase

### Phase A — Parser/Audit

Read-only. No image mutation. No flashing.

### Phase B — Offline Builder

Generate candidate images from test fixtures/owner-provided local NAND inputs. No automatic flash operation.

### Phase C — Image Verification

Perform deterministic parsing, section/layout checks, preserved-data verification, hashes and boot-path validation. No automatic flash.

### Phase D — Manual Hardware Bring-up

Owner explicitly flashes one verified image using an already-trusted method on a development console with external recovery available.

### Phase E — Integrated Flasher

Not authorized until all previous phases are hardware-proven and a separate owner-approved milestone defines power-loss behavior, verification-before-write, post-write verification, recovery and rollback.

## Boot/recovery contract

Target behavior:

```text
POWER -> CCLOS
EJECT -> XeLL
```

CCLOS must contain or be paired with a flash-resident recovery path that does not depend on HDD/MU/USB storage to present basic recovery diagnostics.

External USB recovery media may be supported as an additional source, never as the only recovery path.

## No universal NAND

The repository, build output and release process must never distribute a generic ready-to-flash CCLOS NAND.

Allowed distributables include:

- builder source/binaries;
- CCLOS-owned flash payload components;
- schemas/manifests;
- safe test fixtures that contain no Microsoft/private console data;
- documentation.

The final flash image is always generated locally from the user's own console data.

## No Microsoft binary redistribution by accident

The project may use the target console's own required platform components during a local build process where technically/legally appropriate, but Codex must not add Microsoft-derived retail dashboard binaries, bootloaders, XAM files, kernel images, avatar packs, fonts or other proprietary system files to this public GitHub repository unless redistribution rights are clearly established.

## Flash wear

System flash is not a general persistence volume. CCLOS must avoid high-churn writes to system flash.

Regular mutable data such as logs, notification history, caches, downloads, user settings and profile extensions belongs on available user storage. If no writable user storage exists, use built-in defaults and temporary RAM state rather than repeatedly rewriting NAND.

## Failure handling

Every builder/verifier failure must:

- identify the exact failed gate;
- avoid producing a misleading "ready" image;
- preserve the input NAND untouched;
- avoid silently repairing unknown structures;
- retain enough non-sensitive diagnostics for reproduction.

Unknown is not equivalent to safe.