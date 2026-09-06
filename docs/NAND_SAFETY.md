# CCLOS NAND Edition — NAND Safety & Recovery Contract

## Scope

This document defines mandatory safety rules for every CCLOS NAND Edition milestone. These rules override convenience, automation and schedule pressure.

See also `docs/RECOVERY_ARCHITECTURE.md`. Recovery is a release requirement, not an optional post-launch feature.

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

### Phase E — Recovery Hardware Validation

Before integrated flashing is authorized, prove on development hardware:

- CCLOS Recovery starts with HDD/MU removed;
- invalid/wrong-console recovery packages are rejected before write;
- Safe Mode works without modifying NAND;
- Eject still reaches XeLL;
- a console-specific XeLL `updflash.bin` rescue works on the supported board;
- preflash backup/dump behavior is valid for the target NAND geometry;
- recovery UI does not require technical NAND knowledge for ordinary supported failures.

### Phase F — Integrated Flasher

Not authorized until all previous phases are hardware-proven and a separate owner-approved milestone defines power-loss behavior, verification-before-write, post-write verification, recovery and rollback.

## Boot/recovery contract

Target behavior:

```text
POWER -> CCLOS
SUPPORTED RECOVERY TRIGGER -> CCLOS Recovery
EJECT -> XeLL
CCLOS startup failure -> CCLOS Recovery where boot path remains viable
```

CCLOS must contain or be paired with a flash-resident recovery path that does not depend on HDD/MU/USB storage to present basic recovery diagnostics.

USB recovery media is a supported recovery source, not the only recovery path.

## Recovery hierarchy

```text
1. CCLOS Safe Mode / Repair
2. CCLOS Recovery + verified USB recovery package
3. XeLL + console-specific already-remapped updflash.bin
4. External NAND programmer
```

The normal user experience should exhaust safe software recovery before instructing the owner to open the console.

## Recovery package write gate

The integrated CCLOS Recovery writer must never offer a generic file browser followed by a raw flash command.

Before NAND modification, positively validate all applicable gates:

```text
✓ Recovery format recognized
✓ Package/image SHA-256 valid
✓ Expected byte length valid
✓ Supported NAND image structure
✓ Motherboard family matches
✓ NAND geometry/type matches
✓ Console-specific identity/preservation matches
✓ KeyVault/Console ID/DVD identity preserved
✓ SMC/SMC config compatible
✓ Supported exploit/build family
✓ Bad-block/remap state valid
✓ XeLL/recovery prerequisites present
✓ Rollback/update policy permits this image
```

If any required state is unknown, fail closed and do not write.

No novice-mode override is permitted.

## Backup-before-write contract

When board-specific dump support and writable recovery media are proven, every integrated recovery flash must:

1. dump the current NAND to the selected recovery destination;
2. hash it;
3. read/verify that the backup exists and matches the recorded hash;
4. record non-secret NAND metadata;
5. only then enable final flash confirmation.

If backup creation or verification fails, do not claim a backup exists and do not continue in the default user workflow.

## Last Known Good

Before accepted CCLOS firmware updates, preserve a verified Last Known Good recovery image/payload on available user storage where practical.

A Last Known Good entry is usable only when:

- hash-valid;
- bound to the current console;
- compatible with current board/NAND geometry;
- produced by an accepted builder version;
- not known to contain a failed/partial system update.

Do not use high-churn system flash as a routine backup store without a separately proven board-specific design.

## Safe Mode first

CCLOS Recovery should attempt non-destructive recovery before suggesting a NAND rewrite.

Safe Mode may bypass optional plugins, custom themes/backgrounds, corrupt user configuration, downloads/install jobs and nonessential startup services while preserving user content and network-protection settings.

Safe Mode must not silently delete configuration or alter LiveBlock/LiveStrong.

## XeLL emergency path

XeLL Reloaded remains an independent low-level rescue layer. Proven XeLL implementations scan supported local media for an already-remapped `updflash.bin` and can flash it.

The PC builder must eventually generate the correct **console-specific** rescue image so the novice workflow can be reduced to copying the supplied `updflash.bin` to supported USB media and booting with Eject.

Do not assume the same XeLL/rawflash behavior on every NAND geometry. Verify board-by-board, especially 4 GB/eMMC variants.

## External programmer boundary

Do not promise an unbrickable console.

If neither CCLOS Recovery nor XeLL can execute because the boot/recovery chain itself is damaged, external hardware NAND programming may still be required.

The design goal is:

> normal supported CCLOS firmware failures should be recoverable without opening the console; external programming is the last-resort path for failures below the usable recovery chain.

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

## Power-loss and interruption policy

Software cannot guarantee safe recovery from power loss during arbitrary NAND writes.

The future integrated flasher must therefore:

- perform all validation before first write;
- require a stable-power warning/confirmation;
- minimize the write window using proven routines;
- disable avoidable user-driven interruptions while the write is active where platform-safe;
- perform post-write verification where supported;
- preserve independent recovery capability when the proven image/layout permits it;
- never describe the process as power-loss-proof or unbrickable.

Destructive power-cut fault injection requires sacrificial hardware and a dedicated owner-approved test plan.

## Failure handling

Every builder/verifier/recovery failure must:

- identify the exact failed gate;
- avoid producing a misleading "ready" image;
- preserve the input NAND untouched when no write has begun;
- avoid silently repairing unknown structures;
- retain enough non-sensitive diagnostics for reproduction;
- present plain-language next steps to nontechnical users.

Unknown is not equivalent to safe.
