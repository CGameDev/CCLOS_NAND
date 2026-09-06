# CCLOS NAND Edition — Recovery Architecture

## Product goal

Recovery is a first-class CCLOS NAND Edition feature. The normal user should be able to recover from a damaged CCLOS system update or bad CCLOS system payload **without opening the console or attaching a hardware NAND programmer**, provided the console can still reach either CCLOS Recovery or XeLL.

External hardware flashing remains the final rescue path when the boot/recovery chain itself is no longer executable.

## Recovery hierarchy

```text
Normal boot
  POWER -> CCLOS

Friendly recovery
  Recovery trigger -> CCLOS Recovery

Low-level emergency recovery
  EJECT -> XeLL -> verified/remapped updflash.bin from USB/DVD/HDD

Last resort
  Boot/recovery chain unusable -> external NAND programmer
```

The product objective is to make the first three paths sufficient for normal software/firmware failures so a nontechnical owner rarely needs PicoFlasher/xFlasher/NAND-X or console disassembly.

## What XeLL already provides

XeLL Reloaded is retained as an independent emergency layer. Proven XeLL behavior includes scanning USB/DVD/HDD for an already-remapped `updflash.bin` and flashing it. XeLL also supports FAT/EXT2 USB media and can expose console/NAND information through its existing facilities.

CCLOS does **not** replace XeLL's low-level role. CCLOS Recovery provides a safer and friendlier product UX above the normal Xbox runtime, while XeLL remains the emergency path when the CCLOS shell or recovery application cannot start.

References used for implementation verification:

- `https://github.com/X360Tools/xell-reloaded`
- `https://github.com/Swizzy/XDK_Projects/tree/master/Simple%20360%20NAND%20Flasher`

Codex must verify actual target-hardware behavior rather than assuming every historical implementation supports every NAND geometry.

## Recovery is flash-resident

CCLOS Recovery must not require HDD, onboard MU, USB storage or network merely to start and display diagnostics.

Conceptually:

```text
SYSTEM FLASH
|
+-- boot/RGH environment
+-- XeLL emergency path
+-- required Xbox platform modules
+-- CCLOS Recovery core
+-- CCLOS shell/runtime
+-- essential recovery UI resources
```

The physical xeBuild/flash layout must be proven before implementing a fictional partition scheme. "Protected recovery" is an architectural boundary and update policy; it is not permission to invent NAND partitions.

## Recovery entry methods

The final implementation should support multiple deterministic entry paths where technically proven:

1. automatic fallback after repeated CCLOS startup failure;
2. an owner-approved controller/button recovery gesture during CCLOS boot;
3. a CCLOS Settings -> System -> Recovery command;
4. recovery after an update's post-boot health check fails;
5. Eject -> XeLL as the independent emergency path.

Exact hardware-button semantics must be selected only after testing against Xbox boot behavior and DashLaunch/XeLL interactions.

## Recovery home screen

Use the locked CCLOS visual language. Do not make an Android-looking or generic developer UI.

Target information architecture:

```text
CONSOLECRATE LIVE OS RECOVERY

Console / motherboard
NAND type and capacity
Kernel/build
CCLOS firmware version
Current system health
Last Known Good status
Attached recovery media

Continue to CCLOS
Boot CCLOS Safe Mode
Repair CCLOS System
Restore Last Known Good
Install Verified Recovery from USB
Backup Current NAND to USB
System Diagnostics
Disable External Plugins for Next Boot
Boot XeLL
Power Off / Restart
```

Only options supported safely on the detected hardware are enabled.

## Novice-safe rule

Recovery must be usable by a person who does not know what a CPU key, KeyVault, bad block, xeBuild or NAND remap is.

The default UI must use plain-language decisions such as:

- `Recovery package verified for this console`
- `This recovery file does not belong to this Xbox. No changes were made.`
- `A backup was created successfully.`
- `Keep the console powered on until recovery is complete.`

Advanced identifiers may be available under Diagnostics, but they are not required to perform a normal supported recovery.

## No generic Flash file browser

The recovery UI must **never** expose an unrestricted "select .bin and flash" workflow to ordinary users.

A firmware/recovery action is offered only after a candidate package passes every mandatory validation gate.

If validation is incomplete or unknown, the action is disabled and the system reports the exact reason.

## CCLOS Recovery Package

The preferred user-facing recovery media format is a directory/package rather than a loose untrusted NAND image.

Conceptual structure:

```text
USB:\CCLOS_RECOVERY\
  manifest.json
  firmware.bin
  firmware.sha256
  README.txt                 optional user instructions
```

The exact public filename may change before release. The format must be versioned.

### Manifest identity fields

At minimum the manifest model must be able to describe/validate:

- recovery format version;
- CCLOS firmware/build version;
- target console identity binding or approved source-NAND fingerprint;
- motherboard family;
- NAND geometry/type/capacity;
- expected image byte length;
- expected SHA-256;
- source builder version;
- source NAND/build fingerprint;
- expected kernel/build family;
- expected exploit/hack family;
- required recovery/XeLL compatibility;
- package creation timestamp;
- rollback/upgrade classification.

Never put the user's CPU key, decrypted KeyVault, DVD key or other secret into a public/shareable manifest.

## Mandatory validation before write

Before enabling `Install Verified Recovery`, CCLOS Recovery must positively establish all applicable checks:

```text
✓ Package format/version recognized
✓ File length matches expected geometry
✓ SHA-256 matches manifest
✓ Image parses as supported Xbox 360 NAND image
✓ Motherboard family matches
✓ NAND type/geometry matches
✓ Console-specific identity is the expected identity
✓ KeyVault/console identity is preserved
✓ SMC/SMC-config compatibility is verified
✓ Exploit/boot configuration is supported
✓ Bad-block/remap state is valid for the target
✓ Required XeLL/recovery path is present/compatible
✓ Image is not older/unsupported unless an explicit rollback is authorized
✓ Power/recovery prerequisites are satisfied
```

Unknown is failure. Do not offer a bypass in the novice workflow.

Advanced developer override behavior, if ever implemented, must be a separate owner-approved milestone and must not ship enabled by default.

## Backup-before-write

Every integrated recovery flash must create a backup first when a writable destination is available and when reading the current NAND is proven safe for that board.

Preferred outputs:

```text
CCLOS_Backup_<ConsoleFingerprint>_<Date>\
  preflash_nand.bin
  preflash_nand.sha256
  nand_info.json
  recovery_manifest.json
```

The backup must be read-verified before the write begins.

The recovery workflow must never pretend a backup exists when the destination could not be written or verified.

## Last Known Good

Before an accepted CCLOS firmware update, the updater/recovery system should preserve a verified Last Known Good recovery image or system payload on available user storage.

Candidate storage order:

1. owner-selected USB recovery media;
2. HDD;
3. internal/onboard MU where capacity and wear policy permit.

The system flash itself must not be used as a high-churn backup store unless a board-specific, measured architecture explicitly reserves and validates such space.

`Restore Last Known Good` is only enabled when the backup is hash-valid and belongs to the current console.

## Safe Mode

CCLOS Recovery should support a no-write Safe Mode that starts CCLOS with risky optional state disabled.

Safe Mode candidates:

- ignore external DashLaunch/plugin overrides that are not required to boot;
- do not load optional third-party plugins;
- use built-in CCLOS theme/default settings;
- ignore user wallpaper/theme/config corruption;
- pause background downloads/install jobs;
- disable optional startup services;
- keep network protections unchanged;
- preserve profiles/content without modifying them.

Safe Mode must not silently delete configuration.

## Repair mode

`Repair CCLOS System` should be more conservative than a full NAND reflash.

Where the final flash architecture permits deterministic validation/replacement of CCLOS-owned files, repair may:

- verify CCLOS-owned flash payload hashes;
- restore CCLOS-owned components from a verified recovery package;
- reset transient startup state;
- rebuild safe CCLOS indexes/config on writable storage;
- quarantine bad optional plugin configuration.

Do not rewrite Microsoft/system regions merely because one CCLOS-owned resource is damaged.

## Flash write sequence

The integrated write implementation is not authorized until the project reaches the dedicated flasher milestone. When eventually implemented, the target sequence is:

```text
Detect package
  -> validate package
  -> validate console
  -> validate current NAND
  -> create/read-verify backup
  -> final user confirmation
  -> inhibit normal shutdown/controller-driven interruption where safe
  -> write using proven board-specific rawflash logic
  -> read-back/verify written data where supported
  -> record completion state
  -> hard reboot using validated Xbox update behavior
  -> post-boot health check
  -> mark new build Last Known Good only after successful health gate
```

Do not begin a write if the system cannot establish a supported recovery path for the detected hardware.

## Power-loss handling

No design may claim that software can make a NAND write power-loss-proof.

The flasher must minimize exposure and communicate clearly:

- require stable console power;
- refuse low-confidence/unsupported hardware;
- perform all possible checks before the first NAND write;
- write only the required verified image using proven routines;
- preserve independent XeLL/recovery capability wherever the chosen image/layout permits;
- never advertise the operation as unbrickable.

The project acceptance language is **recoverable for normal supported failures**, not **impossible to brick**.

## XeLL rescue package

For cases where CCLOS Recovery cannot start but XeLL still starts, the PC builder must be able to create a console-specific XeLL rescue output suitable for the proven XeLL flashing workflow.

Target novice instructions should reduce to:

```text
1. Copy the provided updflash.bin to the root of a supported USB drive.
2. Insert the USB drive into the Xbox 360.
3. Start the console with Eject to enter XeLL.
4. Allow XeLL to detect and flash the verified/remapped image.
5. Reboot after completion.
```

The builder, not the novice user, is responsible for correct console-specific generation/remapping.

## External programmer boundary

A hardware NAND programmer remains required if the console cannot execute a usable boot/recovery chain.

Examples include failures that prevent both CCLOS Recovery and XeLL from starting.

The UI/documentation must state this honestly. The product goal is to make external programming exceptional, not to claim it can be eliminated for every possible brick.

## Recovery test matrix

Before a recovery path is called release-ready, hardware tests must intentionally cover at minimum:

- HDD removed;
- no writable user storage;
- corrupt/missing optional CCLOS storage config;
- missing third-party plugin;
- deliberately invalid recovery hash;
- wrong motherboard recovery package;
- wrong NAND-size recovery package;
- recovery package from another console;
- Last Known Good missing/corrupt;
- normal CCLOS startup failure with Recovery still available;
- CCLOS Recovery unavailable but XeLL available;
- valid XeLL `updflash.bin` recovery on the supported board;
- interrupted/noncompleted pre-write phase (before NAND modification);
- post-write verification success/failure handling;
- storage removal during package validation (must abort before write);
- Eject -> XeLL after successful CCLOS installation;
- recovery with HDD completely absent.

Power-cut-during-flash testing must not be performed casually on owner hardware; any destructive fault-injection plan requires a dedicated sacrificial-hardware milestone.

## Release acceptance

CCLOS NAND Edition is not novice-ready until a supported user can follow the documented recovery procedure without J-Runner knowledge for ordinary recoverable failures.

The release checklist must answer:

- Can the console reach CCLOS Recovery without an HDD?
- Can a valid USB package be detected automatically?
- Is a wrong-console package rejected before write?
- Is the preflash backup actually verified?
- Can the user recover through XeLL when CCLOS Recovery is unavailable?
- Does Eject still reach XeLL after installation/update?
- Are external programmer instructions reserved for the true last-resort case?

If any answer is unknown, the product is not yet "worry-free" recovery-ready.
