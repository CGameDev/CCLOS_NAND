# CCLOS NAND Edition — Development Roadmap

This roadmap is sequential by default. Every milestone inherits the baseline/UI lock in `/AGENTS.md` and `/BASELINE_LOCK.md`.

Recovery is designed before integrated flashing. See `RECOVERY_ARCHITECTURE.md`.

## M0 — Exact CCLOS Public Beta v0.35.2 Baseline

**Result:** exact release-producing source is identified, imported unchanged, built, inventoried and frozen.

No NAND behavior changes.

See `MILESTONE_00_BASELINE.md`.

---

## M1 — Flash Dependency & Size Audit

**Result:** evidence-based map of what the v0.35.2 CCLOS baseline requires to boot/render/navigate, what is immutable, what is writable, what can be discarded from a release build, and what must remain outside 16 MB system flash.

Tasks:

- measure XEX and resource sizes;
- identify executable/resource dependencies;
- inventory runtime paths currently assuming `game:`/`Hdd1:`;
- classify each dependency as flash-core, optional-code, writable-user-data, cache/content, development-only or server-only;
- establish Trinity 16 MB flash budget using proven xeBuild layout data;
- identify Microsoft platform components that must remain in the target image;
- identify retail dashboard shell components that are not required;
- reserve/prove sufficient recovery budget before finalizing the flash payload;
- produce a proposed flash payload without changing source/UI.

**Hard rule:** no baseline feature may be deleted merely to hit a size target without owner approval. Recovery must not be squeezed out to make the shell fit.

---

## M2 — Storage Provider & No-Storage Runtime Foundation

**Result:** CCLOS no longer assumes HDD availability for core operation.

Introduce a bounded storage-provider abstraction that can represent:

- HDD;
- internal/onboard MU;
- supported Flash MU/big-block storage;
- supported eMMC/internal MU;
- USB MU / supported USB storage;
- no writable storage.

Migrate only infrastructure first. Preserve existing public-release behavior when HDD exists.

Acceptance includes a host/static matrix proving every core path has a no-storage state rather than an unconditional `Hdd1:` dependency.

---

## M3 — CCLOS Flash-System Build Target

**Result:** a flash-oriented CCLOS build exists without creating a second UI.

Requirements:

- same established CCLOS renderer/pages/assets/behavior;
- flash path resolver rather than hardcoded fictional paths;
- boot-critical code/resources separated from writable content;
- optional caches/content remain storage-backed;
- release optimization/resource packing is measured and deterministic;
- no user settings/logs/history written repeatedly to system flash;
- recovery core/resources are treated as required system content, not optional extras.

Outputs may include separate shell/runtime/recovery modules if size and platform behavior justify them.

---

## M4 — XboxSystemBridge Foundation

**Result:** one isolated, version-aware boundary owns CCLOS access to Xbox platform services.

Create verified adapters for public/documented XDK APIs first and private/ordinal-based interfaces only where independently validated.

Initial domains:

- user/profile identity;
- achievements/gamercard;
- content/storage devices;
- controller/device information;
- system UI/keyboard/message boxes;
- power/tray state;
- display/audio read-side capability;
- network/system state.

No UI redesign.

---

## M5 — Retail System Parity: Profiles, Storage & Content

**Result:** CCLOS covers the locally useful retail-console profile/storage/content-management capabilities without requiring the retail dashboard shell.

Includes:

- Xbox sign-in/sign-out/profile enumeration;
- genuine Xbox profile identity + CCLOS XUID-linked extensions;
- storage-device enumeration;
- saved-content/profile/game/DLC/TU categorization where supported;
- safe copy/move/delete/transfer operations where platform APIs permit;
- format/rename/cache-management only behind strong permission/confirmation gates and verified APIs;
- no-storage profile UX;
- existing CCLOS Admin/Standard/Restricted/Guest roles retained as CCLOS policy layered over Xbox identity.

---

## M6 — Retail System Parity: Network, Display, Audio, Locale & Console

**Result:** the CCLOS Settings experience exposes core console configuration historically supplied by the retail dashboard.

Domains:

- wired/wireless status and supported configuration;
- DHCP/static IP/DNS where safely available;
- local/Internet/CCLOS service diagnostics;
- Xbox-service connectivity shown separately from ordinary Internet;
- resolution/video mode/reference level/HDMI capability where supported;
- audio output/system sound/voice settings where supported;
- language/locale/time/time-zone/console identity where supported;
- startup/autoplay policy implemented as CCLOS-native policy;
- system information and diagnostics.

When a write capability is not verified, expose read-only state or mark it unsupported. Do not write undocumented config fields by guesswork.

---

## M7 — Retail Guide & Social-Service Parity

**Result:** CCLOSRuntime/Quick Guide covers the locally available system-layer experience users expect while a game is running.

Candidate domains where available:

- sign-in/profile;
- achievements;
- gamercards;
- friends;
- messages;
- recent players;
- friend requests;
- game invites;
- party/voice;
- notifications;
- music/Now Playing;
- controller/battery/device state;
- Quick Settings;
- Return to Game / Return to CCLOS.

Live/server-dependent functionality must report availability honestly. CCLOS must never disable Live protection automatically.

---

## M8 — Media, Connected Devices, Avatar & Kinect Parity

**Result:** remaining useful retail media/device capabilities are integrated into existing CCLOS areas.

Includes, where supported and worthwhile:

- local/USB/network music/pictures/video;
- CCMS/DLNA/SMB/HTTP integration already present in CCLOS;
- physical video/data disc classification;
- connected-device status;
- Play To/DLNA capabilities where applicable;
- avatar display/configuration through retained platform services;
- Kinect detection/settings/calibration bridge where validated;
- legacy Xbox Live Vision capability may be marked legacy/optional rather than receiving a large reimplementation.

No recreation of retired Windows Media Center Extender or closed Marketplace purchasing merely for nominal parity.

---

## M9 — DashLaunch-Compatible Runtime & Plugin Preservation

**Result:** CCLOS NAND Edition preserves the proven plugin/runtime ecosystem without making HDD configuration mandatory for base boot.

Requirements:

- flash-safe default boot policy always reaches CCLOS;
- existing supported plugin semantics preserved;
- storage overrides may extend configuration;
- CCLOSRuntime coexists with third-party plugins;
- missing external plugin files cannot prevent CCLOS boot;
- no stealth provider is bundled into CCLOS;
- stealth-server compatibility is tested as coexistence only;
- LiveBlock/LiveStrong and user protection settings are never silently disabled;
- Original Xbox/title-transition compatibility is tested separately;
- define a no-write Safe Mode that can bypass optional external plugins without deleting their configuration.

---

## M10 — Flash-Resident CCLOS Recovery & Novice-Safe Rescue

**Result:** CCLOS has an independent recovery environment and validated rescue design suitable for nontechnical users before integrated flashing is permitted.

Governing specification: `docs/RECOVERY_ARCHITECTURE.md`.

Target behavior:

```text
POWER -> CCLOS
SUPPORTED RECOVERY TRIGGER -> CCLOS Recovery
EJECT -> XeLL
CCLOS startup failure -> CCLOS Recovery where boot path remains viable
```

### M10A — Recovery core and diagnostics

- recovery starts with HDD/MU/USB/network absent;
- locked CCLOS visual language is reused;
- show console/board/NAND/CCLOS/system health in plain language;
- Continue to CCLOS;
- CCLOS Safe Mode;
- System Diagnostics;
- disable optional external plugins for next boot without deleting configuration;
- Boot XeLL;
- Power/Restart actions;
- no NAND writes yet.

### M10B — Recovery package format and verifier

Define a versioned `CCLOS_RECOVERY` package containing a manifest, image/payload and SHA-256 metadata.

The verifier must reject before write:

- corrupt hash;
- wrong NAND byte length;
- unsupported image format;
- wrong motherboard family;
- wrong NAND geometry/type;
- package from another console;
- identity/KeyVault/SMC preservation mismatch;
- unsupported exploit/build combination;
- invalid bad-block/remap state;
- missing/incompatible recovery prerequisites.

There is no generic `browse for .bin -> flash` novice flow.

### M10C — Last Known Good and backup design

- define verified preflash backup bundle;
- define Last Known Good lifecycle;
- ensure backups are hash/read-verified;
- bind recovery artifacts to the correct console without putting secrets into shareable manifests;
- define preferred USB/HDD/MU recovery destinations;
- never claim a backup exists if write/read verification failed.

### M10D — XeLL rescue path

Prove the builder can produce a console-specific, correctly remapped XeLL rescue `updflash.bin` for the supported Trinity target.

Document the novice emergency flow as:

```text
Copy supplied updflash.bin to supported USB root
-> insert USB
-> power on with Eject
-> XeLL detects/flashes image
-> reboot
```

Do not assume later 4 GB/eMMC hardware follows identical behavior; validate each hardware family separately.

### M10 acceptance gate

M10 is not complete until physical development hardware proves:

- recovery starts with HDD removed;
- Safe Mode can recover from optional plugin/config startup problems without NAND writes;
- wrong-console/wrong-NAND/wrong-hash packages are rejected before NAND modification;
- Eject -> XeLL remains operational;
- a valid XeLL USB rescue image works on the initial target;
- a nontechnical tester can follow ordinary recovery instructions without J-Runner/NAND terminology.

No integrated CCLOS NAND writer is authorized by M10 itself.

---

## M11 — CCLOS NAND Builder: Parser & Console Analysis

**Result:** PC builder can read a target console NAND and produce a complete analysis report without modifying or flashing it.

Detect/validate:

- motherboard;
- NAND type/geometry;
- source build/environment;
- CPU-key validity;
- KeyVault;
- SMC/SMC config;
- region/DVD/console identity presence;
- bad blocks/remapping;
- exploit type;
- XeLL/recovery state;
- available flash budget.

Use proven J-Runner/xeBuild logic/reference where licensing permits. Do not invent structures.

---

## M12 — CCLOS NAND Builder: Trinity 16 MB Offline Build

**Result:** builder generates a deterministic **console-specific** CCLOS candidate image for the initial Trinity/RGH3 test console.

No automatic hardware flash.

Required outputs:

- candidate `CCLOS_updflash.bin`;
- console-specific XeLL rescue `updflash.bin` workflow/output as defined by M10;
- CCLOS Recovery package/manifest inputs where applicable;
- build manifest;
- preserved-data verification report;
- size/layout report;
- hashes;
- original NAND recovery bundle;
- explicit READY / NOT READY result.

A universal image is prohibited.

---

## M13 — Deterministic Verification & Hardware Bring-up

**Result:** one owner-approved, fully verified candidate is manually flashed to a development/sacrificial Trinity RGH3 console with external programmer recovery available.

Hardware acceptance includes:

- cold boot with HDD removed;
- CCLOS Home renders using baseline UI;
- Settings/System Health/Network/Display/Audio operate;
- controller/Guide behavior;
- physical disc detection/launch;
- attach/remove HDD/MU/USB dynamically;
- Xbox profile discovery on storage;
- reboot/power cycle;
- supported trigger -> CCLOS Recovery;
- Eject -> XeLL;
- Safe Mode with optional plugins suppressed;
- valid/invalid USB recovery-package detection without unsafe writes;
- selected plugin/stealth coexistence test;
- game launch and return paths;
- no retail dashboard dependency;
- no regression of locked CCLOS UI.

---

## M14 — Additional Motherboards / Storage Geometries

Only after Trinity is stable.

Candidate expansion:

- Corona 16 MB;
- Corona 4 GB/eMMC;
- other supported RGH3 configurations;
- supported RGH1.2/RGH2/JTAG configurations where builder logic is proven.

Each board/storage family receives its own layout, recovery, XeLL/rawflash capability and hardware matrix. A recovery method proven on Trinity is not automatically declared safe for 4 GB/eMMC hardware.

---

## M15 — Integrated CCLOS Recovery Flasher

**Not authorized by earlier milestones.**

Only after offline build/verification, manual hardware flashing, CCLOS Recovery, preflash backup and XeLL rescue are proven repeatedly on the supported hardware family.

Must implement and separately validate:

- auto-detect candidate recovery package;
- no unrestricted raw `.bin` browser in novice mode;
- package SHA-256 validation;
- console/board/NAND/identity compatibility validation;
- pre-write current-NAND dump where board support is proven;
- read/hash verification of the backup;
- clear final confirmation using plain language;
- stable-power warning;
- proven board-specific rawflash writer;
- write progress that does not imply completion early;
- post-write/read-back verification where supported;
- hard-reset/reboot path only after completion state is known;
- failed-write/recovery instructions;
- Last Known Good lifecycle;
- preservation of Eject -> XeLL;
- logs that contain no console secrets;
- refusal on unknown/unsupported hardware.

Target sequence:

```text
Detect recovery package
-> validate package
-> validate console
-> validate current NAND
-> create/read-verify backup
-> final confirmation
-> write using proven board-specific routine
-> verify written data where supported
-> reboot
-> post-boot health check
-> mark new build Last Known Good only after health gate passes
```

The UI must never describe NAND flashing as unbrickable or power-loss-proof.

Until M15 is explicitly approved and completed, CCLOS NAND Builder generates and verifies images but does not write console flash automatically.

---

## Release-quality recovery target

A CCLOS NAND Edition build is not considered novice-ready until an ordinary supported software/firmware failure can normally be recovered without opening the console, and the documented escalation path is:

```text
Safe Mode / Repair
-> Verified CCLOS USB Recovery
-> XeLL USB Rescue
-> External programmer only when the boot/recovery chain itself cannot run
```
