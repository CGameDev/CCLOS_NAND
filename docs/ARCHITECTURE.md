# CCLOS NAND Edition — Native Flash Architecture

## Purpose

CCLOS NAND Edition is a flash-resident Xbox 360 system shell derived from the locked CCLOS public-release baseline. It is intended for supported exploited consoles (initially RGH3 development targets) and must behave like a self-contained console environment rather than an HDD application launched by firmware.

## Design principles

1. **CCLOS is the primary shell.** The Microsoft retail dashboard shell is not retained as the user-facing environment.
2. **Xbox platform services are retained.** Hypervisor, kernel, XAM/XUser/XContent/XNet and required hardware/system modules remain the underlying platform.
3. **No external storage boot dependency.** CCLOS must boot and provide core console functions with no HDD/MU/USB storage present.
4. **Public CCLOS UI remains the UI.** NAND work changes placement, initialization, services, storage abstraction and boot behavior—not the established visual product.
5. **System flash is for immutable/boot-critical content.** Writable/high-churn user data belongs on normal Xbox user storage.
6. **Console-specific NANDs only.** Every build derives from the target console's own NAND and preserves identity/configuration.
7. **Recovery is designed before flashing.** Power boots CCLOS; Eject boots XeLL; flash-resident CCLOS Recovery handles shell failures.

## Target boot path

```text
Power
  |
  v
Xbox Boot ROM / console boot stages
  |
  v
RGH/JTAG xeBuild environment
  |
  v
Hypervisor + Kernel
  |
  v
Required Xbox system modules / XAM
  |
  v
DashLaunch-compatible runtime/plugin layer
  |
  v
CCLOSRuntime
  |
  v
XboxSystemBridge
  |
  v
CCLOS Flash Shell
  |
  v
ConsoleCrate Live OS Home
```

No `Hdd1:\Apps\ConsoleCrateLiveOS\default.xex` dependency is allowed in the final flash architecture.

## Logical layers

### Layer 0 — Console-specific boot/security foundation

Owned by the Xbox platform plus the supported exploited boot environment.

Responsibilities include board/NAND geometry, SMC/SMC config, KeyVault, boot stages, CPU-key validation, kernel/HV image selection, exploit configuration, bad-block handling and XeLL recovery.

CCLOS tooling must consume proven builder logic rather than invent NAND structures.

### Layer 1 — Xbox platform services

Retained required system components providing the underlying Xbox runtime:

- kernel/HV;
- XAM and documented/validated XUser services;
- XContent/device/content APIs;
- XNet/network stack;
- XAudio/XAV/media primitives;
- controller/input APIs;
- avatar/Kinect/system UI components where required and legally/technically usable;
- storage/content services required by Xbox titles.

CCLOS does not replace these with homegrown equivalents unless a specific service is absent and a CCLOS-native implementation is required.

### Layer 2 — DashLaunch-compatible runtime/plugin layer

Preserve the established Xbox 360 plugin ecosystem and boot/runtime patches required by supported configurations.

Requirements:

- plugin loading must remain compatible with existing user configurations;
- external plugin paths may live on writable storage;
- no particular stealth provider is embedded in the CCLOS system image;
- CCLOS must not silently disable LiveBlock/LiveStrong or comparable protection settings;
- CCLOSRuntime must coexist with other plugins;
- flash-safe defaults must permit CCLOS to boot even if external storage/plugin files are missing.

### Layer 3 — CCLOSRuntime

Persistent CCLOS runtime responsibilities may include:

- CCLOS Guide/overlay integration;
- notifications;
- runtime state/event coordination;
- return-to-CCLOS behavior;
- system-service adapters used while titles are running;
- bounded monitoring needed by CCLOS;
- safe interaction with plugin/runtime state.

The final module split is size/compatibility driven; architecture must not assume one huge XEX.

### Layer 4 — XboxSystemBridge

A single verified boundary between CCLOS and Xbox platform services.

Candidate services:

- ProfileService
- AchievementService
- GamerCardService
- FriendsService
- MessageService
- Party/VoiceService
- SystemUIService
- StorageDeviceService
- ContentService
- NetworkConfigurationService
- DisplayService
- AudioService
- ControllerService
- Locale/ClockService
- AvatarService
- KinectService
- Power/TrayService

Rules:

- use public/documented XDK APIs first;
- isolate private/ordinal-based interfaces if a verified capability requires them;
- never scatter private ordinals through renderer/UI code;
- validate kernel/dashboard compatibility before resolving private exports;
- fail closed and expose capability state rather than crashing;
- never copy Microsoft dashboard UI/resources into CCLOS.

### Layer 5 — CCLOS Flash Shell

This is the existing CCLOS public-release user experience adapted to run from flash.

The shell owns the established CCLOS Home/Shop/Collection/Queue/Downloads/Achievements/System Health/Settings/Network/Data/About/Security/Watch TV/Social/Quick Guide surfaces present in the locked baseline.

NAND work must preserve the baseline renderer, geometry, HUD and navigation.

## Flash-resident content

The exact layout is determined by the NAND builder and board-specific capacity, but the conceptual system volume contains only components required to boot and operate the base console:

```text
SYSTEM FLASH
|
+-- Xbox boot/platform components required by the target build
+-- DashLaunch-compatible runtime component(s)
+-- CCLOS flash shell
+-- CCLOSRuntime core
+-- XboxSystemBridge
+-- CCLOS recovery
+-- essential default UI resources
+-- essential fonts/icons
+-- essential localization/default configuration
+-- verified boot/recovery metadata
```

Do not hardcode a fictional `Sfc:\CCLOS\...` layout in runtime code until the actual xeBuild flash filesystem layout has been proven. Use a platform path resolver owned by the flash-build layer.

## User-storage architecture

Writable content must use a storage-provider layer rather than direct `Hdd1:` assumptions.

Candidate providers:

- HDD
- internal/onboard MU
- big-block/Flash MU where applicable
- eMMC/internal MU where applicable
- USB MU / supported USB storage

Data classes include:

- Xbox profiles and saves;
- CCLOS per-profile extension data;
- preferences and PIN/role data where appropriate;
- favorites/history/recent activity;
- queues/download state;
- games/DLC/title updates/trainers/apps/emulators;
- custom themes/backgrounds;
- artwork/media caches;
- logs and temporary files;
- external system plugins.

## No-storage behavior

With all user storage removed:

- CCLOS boots from flash;
- default settings come from flash;
- transient session state lives in RAM;
- Home remains functional;
- Settings/System Health/Network/Display/Audio remain available;
- controller and tray/disc functions remain available;
- compatible physical games may launch;
- storage-dependent features show normal empty/no-storage states;
- no attempt is made to create writable data in system flash as a substitute for user storage.

## Retail feature parity strategy

For every locally useful retail Xbox 360 capability, classify it as one of:

1. **Xbox service-backed** — CCLOS calls the retained platform service through XboxSystemBridge.
2. **CCLOS-native** — CCLOS implements the feature using low-level supported platform capabilities.
3. **Legacy/server-retired** — capability is documented as unavailable/retired rather than falsely recreated.

The project does not keep the full retail dashboard merely to expose these functions.

## Build products

Expected long-term outputs:

```text
CCLOS_NAND
|
+-- CCLOS flash-system build
+-- CCLOSRuntime build
+-- CCLOS Recovery build
+-- XboxSystemBridge
+-- CCLOS NAND Builder (PC)
+-- NAND parser/verifier
+-- board/storage capability data
+-- documentation/test fixtures
```

The PC builder generates a console-specific image such as `CCLOS_updflash.bin`; it never distributes a universal image.

## Initial hardware scope

Start narrow and prove the architecture before expanding.

Recommended first hardware target:

- Trinity
- 16 MB NAND
- already-working RGH3 console
- kernel 17559 environment
- known-good original NAND dump
- known CPU key
- XeLL access
- external programmer available for recovery

Expand to Corona/4 GB and other supported exploit configurations only after the first target is deterministic and recoverable.

## Size discipline

The public CCLOS application was not designed as a 16 MB flash product. The flash build must therefore perform a measured dependency/resource audit and create a flash-specific build target rather than copying the entire public-beta folder into NAND.

Optimization must not change the visible public-release CCLOS design. Acceptable methods include dead-code elimination, removing developer-only artifacts, separating mutable content, resource packing, deduplicating immutable assets, and moving optional content caches/data to user storage.

Any proposal to remove an existing user-facing baseline feature solely to fit NAND requires owner approval.