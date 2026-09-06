# CCLOS NAND Edition — Development Roadmap

This roadmap is sequential by default. Every milestone inherits the baseline/UI lock in `/AGENTS.md` and `/BASELINE_LOCK.md`.

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
- produce a proposed flash payload without changing source/UI.

**Hard rule:** no baseline feature may be deleted merely to hit a size target without owner approval.

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
- no user settings/logs/history written repeatedly to system flash.

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
- Original Xbox/title-transition compatibility is tested separately.

---

## M10 — Flash-Resident CCLOS Recovery

**Result:** CCLOS has an independent recovery environment that does not depend on HDD/MU/USB to present basic diagnostics.

Target behavior:

```text
POWER -> CCLOS
EJECT -> XeLL
CCLOS failure -> CCLOS Recovery
```

Recovery capabilities may include:

- show flash/system health;
- disable external plugin overrides for next boot;
- reset CCLOS volatile/user configuration on attached storage;
- verify flash-resident CCLOS files;
- restore a supported last-known-good CCLOS system payload when architecture permits;
- boot USB recovery payload as an optional source;
- guide the user to external reflash when recovery cannot safely repair.

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
- Eject -> XeLL;
- plugin-disabled safe boot;
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

Each board/storage family receives its own layout, recovery and hardware matrix.

---

## M15 — Optional Integrated Flasher

**Not authorized by earlier milestones.**

Only after offline build/verification and manual hardware flashing are proven repeatedly.

Must separately design:

- pre-write checks;
- power-loss behavior;
- source/target verification;
- write progress;
- read-back verification;
- failure recovery;
- user warnings;
- recovery bundle creation;
- supported hardware boundaries.

Until M15 is explicitly approved, CCLOS NAND Builder generates and verifies images but does not write console flash automatically.
