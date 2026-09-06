# CCLOS NAND Edition — Novice / Worry-Free Experience Contract

## Goal

CCLOS NAND Edition should feel like a finished console product, not a collection of RGH utilities. A supported owner should not need to understand NAND geometry, CPU keys, KeyVaults, xeBuild, J-Runner, DashLaunch internals, bad blocks or plugin slots to install, update, use or recover CCLOS.

Advanced information remains available for developers and technicians, but the default path is guided, validated and plain-language.

## Product principles

1. **Detect instead of asking.** If CCLOS/the builder can reliably detect the board, NAND type, kernel, exploit, storage or existing configuration, do not ask the user to choose it manually.
2. **Validate instead of trusting.** Never trust a filename or user-selected option when the system can verify the underlying image/device.
3. **Explain outcomes, not internals.** Default messages say what is happening and what the user should do.
4. **Fail before destructive work.** Unsupported or uncertain states stop before NAND modification.
5. **Backup before change.** Firmware operations create/read-verify recovery data before write when the hardware/path supports it.
6. **Recovery is part of installation.** A CCLOS install is not complete until the recovery path has been verified.
7. **No hidden dependencies.** Removing HDD/user storage must not prevent the base CCLOS system/recovery from booting.
8. **No fake certainty.** Never display `Safe`, `Verified`, `Compatible`, `Backup Complete` or `Ready` unless every required check actually passed.
9. **Preserve user protection.** Do not silently disable LiveBlock/LiveStrong, overwrite third-party plugin settings or alter unrelated console configuration.
10. **One obvious default path.** Advanced options are secondary and never required for an ordinary supported install.

## PC Builder — target novice workflow

Target high-level wizard:

```text
WELCOME
  -> Connect/read your existing NAND backup
  -> Enter/obtain CPU key through an approved method
  -> Automatic console analysis
  -> Compatibility result
  -> Automatic CCLOS build
  -> Automatic verification
  -> Recovery package creation
  -> Plain-language install instructions
```

The user should not manually choose Trinity/Corona, RAW/eMMC, SMC type, bad-block policy, kernel patches or remapping when these can be proven from source data.

### Builder result states

Only three top-level outcomes:

```text
READY TO INSTALL
ATTENTION REQUIRED
NOT SUPPORTED
```

`READY TO INSTALL` requires every mandatory safety/recovery gate to pass.

### Compatibility screen example

```text
Your Xbox 360 is compatible with this CCLOS build.

Console: Xbox 360 S (Trinity)
Storage Flash: 16 MB
Current Environment: RGH3
Recovery: XeLL available
Original NAND Backup: Verified
CCLOS Recovery Package: Ready

[Create Installation Package]
```

Technical details may be expandable under `Advanced Details`.

## Never ask a novice to manufacture NAND identity

The ordinary workflow must never tell the user to manually type/edit:

- KeyVault data;
- Console ID;
- DVD key;
- SMC data;
- bad-block locations;
- NAND geometry;
- remap tables.

These values must be read, preserved and validated by proven tooling.

A CPU key may still need to be supplied/obtained depending on the supported workflow, but the UI should explain exactly where to retrieve it and validate it immediately.

## Installation package

The builder should eventually produce one clearly named folder/ZIP for that console, for example:

```text
CCLOS_Install_<ConsoleFingerprint>\
  INSTALL_README.txt
  CCLOS_updflash.bin
  Recovery\
    updflash.bin
    manifest.json
    firmware.sha256
  Backup\
    OriginalNAND.bin
    OriginalNAND.sha256
    NANDInfo.json
```

Exact names are subject to final architecture, but the package should clearly separate:

- normal installation image;
- emergency XeLL rescue image;
- verified original backup;
- recovery metadata.

Do not place secrets in public/shareable logs or manifest files.

## First boot / Out-of-box experience

First boot after a successful flash should feel like a console setup, not a developer build.

Suggested flow using existing CCLOS visual language:

```text
Welcome to ConsoleCrate Live OS
  -> Display
  -> Audio
  -> Network
  -> Storage detection
  -> Xbox profile
  -> CCLOS owner/profile preferences
  -> Recovery check
  -> System health check
  -> Home
```

If no user storage exists, setup must still finish and explain that storage can be added later for profiles/saves/downloads.

## Recovery verification during setup

A novice installation should not be called complete until CCLOS can verify as much as practical of the recovery chain:

- CCLOS Recovery component present;
- recovery package exists on selected media where applicable;
- Last Known Good/original backup known and hash-valid where applicable;
- XeLL expected/present for the supported build;
- user has been shown the simple Eject recovery instruction.

The system should offer `Test Recovery` only if the test can be done safely and deterministically.

## Firmware update UX

Normal update flow:

```text
Update available
  -> Download
  -> Verify package
  -> Verify console compatibility
  -> Prepare rollback/recovery
  -> Final confirmation
  -> Install
  -> Verify
  -> Reboot
  -> Post-boot health check
  -> Mark Last Known Good
```

Do not expose NAND terminology unless the user opens Advanced Details.

### Update copy examples

Preferred:

```text
Preparing a recovery backup...
Verifying update...
Installing ConsoleCrate Live OS...
Do not turn off the console.
Verifying installation...
Update complete.
```

Avoid default copy such as:

```text
Writing blocks 0x0000-0x03FF / remapping bad block 0x...
```

That belongs in technical logs/advanced mode.

## Safe failure copy

When something cannot proceed, state:

1. what failed;
2. whether anything was changed;
3. what the user should do next.

Example:

```text
This recovery package was made for a different Xbox 360.
No changes were made to your console.

Use the recovery package created for this console.
```

Not:

```text
KV mismatch 0xC8003003
```

Technical codes may be included under `Details` for support.

## Support bundle

CCLOS should eventually generate a privacy-safe support bundle that the user can copy to USB and attach to a bug report.

Candidate contents:

```text
CCLOS_Support_<Date>.zip
  SystemSummary.txt
  CCLOSVersion.txt
  HardwareSummary.txt
  StorageSummary.txt
  NetworkSummary.txt
  RecoveryStatus.txt
  RecentSafeLogs.txt
  BuildManifestSummary.txt
```

Must NOT include:

- CPU key;
- decrypted KeyVault;
- DVD key;
- authentication tokens;
- private account credentials;
- full NAND dump;
- personally identifying profile data unless explicitly required/consented and separately scrubbed.

## Health dashboard

System Health should surface actionable states:

```text
System Firmware       Healthy
Recovery              Ready
Original NAND Backup  Verified
XeLL Recovery          Available
User Storage           HDD connected
Network                Connected
External Plugins       2 loaded
```

If recovery is not ready, this should be visible before the user attempts a firmware update.

## Automatic prevention

Examples of operations CCLOS should prevent automatically:

- flash package from another console;
- unsupported NAND geometry;
- invalid package hash;
- unresolved source NAND/CPU-key mismatch;
- firmware update without required recovery prerequisite;
- formatting the active recovery destination during an update;
- removing/overwriting verified original backup without explicit confirmation;
- loading a missing optional plugin in a way that boot-loops CCLOS;
- destructive storage actions by restricted profiles;
- firmware update while baseline/build verification is incomplete.

## Recovery escalation copy

The user-facing escalation path should be simple:

```text
Try Safe Mode
  -> Try CCLOS USB Recovery
  -> Start with Eject for XeLL USB Recovery
  -> Hardware recovery only if the console cannot reach either recovery mode
```

Do not lead with PicoFlasher instructions when software recovery is still available.

## Advanced mode

An optional Advanced/Developer view may expose:

- full NAND geometry;
- hashes;
- build IDs;
- bad-block map;
- XAM/kernel information;
- plugin paths;
- low-level recovery diagnostics.

Advanced mode must not weaken mandatory identity/hash/geometry validation gates for NAND writes unless a separate owner-approved development milestone explicitly provides a developer-only override.

## Release acceptance

The product is not "worry-free" ready until a first-time supported user can complete the common lifecycle with documentation only:

```text
Build/install
-> first boot
-> use without HDD
-> add storage/profile
-> update CCLOS
-> recover from an ordinary failed CCLOS update/config/plugin problem
```

without needing to understand the Xbox 360 modding toolchain.

A good test question for every screen is:

> Would a user who bought an already-modded Xbox 360 understand what to do here without knowing how RGH works?

If not, simplify the default path while retaining technical detail under diagnostics/advanced views.
