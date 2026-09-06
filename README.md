# CCLOS NAND Edition

**ConsoleCrate Live OS — Native Flash Architecture for Xbox 360**

CCLOS NAND Edition is the firmware-oriented branch of ConsoleCrate Live OS. The goal is to make CCLOS the flash-resident Xbox 360 system shell on supported RGH/JTAG consoles while retaining the Xbox 360 kernel, hypervisor, XAM, XUser, XContent, XNet, hardware services, and other required platform components.

This project is **not** a new dashboard design and is **not** an HDD-installed dashboard with a NAND boot pointer.

## Non-negotiable product definition

A console flashed with CCLOS NAND Edition must be capable of booting into the CCLOS shell and accessing core console functionality with **no HDD, Memory Unit, USB storage, or network connection installed**. External storage expands functionality but must never be a boot requirement.

The Microsoft retail dashboard shell is not the target shell. CCLOS provides the user-facing environment and uses retained Xbox system services through a dedicated XboxSystemBridge layer.

## Baseline lock

The owner-approved visual, navigation, terminology, feature, and behavior baseline is the **latest validated local CCLOS source** at:

`C:\cctu`

The currently observed source reports:

- version: `0.35.4`
- build label: `0.35.4 Internet Updates`

The earlier **CCLOS Public Beta v0.35.2** release remains a historical/public comparison point only. Exact v0.35.2 provenance is no longer a hard blocker because the owner explicitly approved using the latest local source.

Historical public artifact:

`http://consolecrate.xyz/updates/CCLOS_Public_Beta_v0.35.2.zip`

Remote donor repository:

`https://github.com/CGameDev/ConsoleCrateLive.git`

**Important:** Codex must treat `C:\cctu` as a read-only donor workspace. Milestone 0 freezes the exact current local source state, including owner-approved uncommitted fixes if present, into `src/CCLOS/` and generates a deterministic source/resource manifest before NAND-specific implementation begins.

See [`BASELINE_LOCK.md`](BASELINE_LOCK.md), [`AGENTS.md`](AGENTS.md), and [`docs/MILESTONE_00_BASELINE.md`](docs/MILESTONE_00_BASELINE.md).

## UI preservation rule

CCLOS NAND Edition must retain the owner-approved CCLOS baseline interface exactly unless an owner-approved milestone explicitly authorizes a UI change.

Codex must not independently:

- create a replacement dashboard UI;
- redesign Home, Shop, My Collection, Queue, Downloads, Achievements, System Health, Settings, Network, Data, About, Security, Watch TV, Social Hub, or other established pages;
- alter the top or bottom HUD;
- change navigation geometry, focus behavior, fonts, icons, backgrounds, translucency, spacing, color treatment, or page hierarchy merely to suit the NAND architecture;
- substitute retail NXE/Metro visuals;
- introduce a new visual language for NAND-only settings or Recovery.

New NAND/system/recovery functions must be integrated into the existing CCLOS shell and design system.

## Architecture summary

```text
POWER
  |
  v
Xbox Boot ROM / console-specific boot chain
  |
  v
RGH/JTAG xeBuild environment
  |
  v
Xbox Hypervisor + Kernel
  |
  v
Required Xbox system modules / XAM
  |
  v
DashLaunch-compatible runtime/plugin layer
  |
  v
CCLOSRuntime + XboxSystemBridge
  |
  v
CCLOS Flash Shell
  |
  v
ConsoleCrate Live OS
```

### System flash owns

- boot-critical CCLOS shell/runtime components;
- essential CCLOS system services;
- XboxSystemBridge;
- default UI resources required to reach and operate the shell;
- essential fonts/icons/localization/default configuration;
- flash-resident CCLOS Recovery components;
- immutable platform integration required for normal console operation.

### User storage owns

Writable or high-churn data must use available Xbox user storage such as HDD, onboard/internal MU, USB MU, or supported USB storage:

- Xbox profiles and saves;
- CCLOS per-profile preferences;
- games, DLC, title updates, trainers, applications and emulators;
- downloads and queues;
- artwork/media caches;
- custom themes/backgrounds;
- notification/history data;
- logs and temporary files;
- optional third-party plugins such as stealth-service plugins;
- Last Known Good / recovery backups when appropriate and verified.

## Local development environment

Known owner-approved local paths:

```text
CCLOS donor source:
C:\cctu

J-Runner with Extras reference:
C:\Users\CGAmeDev\Downloads\J-Runner-with-Extras

Private console data:
C:\CCLOS-NAND-Development\PrivateConsoleData\

NAND sample library:
C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\

Working/build/recovery/log output:
C:\CCLOS-NAND-Development\Working\
C:\CCLOS-NAND-Development\Builds\
C:\CCLOS-NAND-Development\Recovery\
C:\CCLOS-NAND-Development\Logs\
```

These donor/reference locations are read-only unless a later owner-approved milestone explicitly authorizes a change.

## Recovery-first product design

Recovery is part of the product architecture, not a late troubleshooting feature.

Target hierarchy:

```text
Normal boot
  POWER -> CCLOS

Friendly recovery
  Supported Recovery trigger -> CCLOS Recovery

Emergency recovery
  EJECT -> XeLL -> console-specific verified/remapped updflash.bin from USB

Last resort
  Boot/recovery chain unusable -> external NAND programmer
```

The goal is that ordinary supported CCLOS software/firmware failures can normally be recovered **without opening the console**.

CCLOS Recovery must:

- start and show basic diagnostics with no HDD/MU/USB/network present;
- provide Safe Mode before recommending a NAND reflash;
- use the existing CCLOS visual language;
- auto-detect a versioned recovery package from USB;
- reject wrong-console, wrong-NAND, wrong-board, wrong-hash or otherwise unverified packages before any write;
- create/read-verify a preflash backup when the board/destination supports it;
- maintain a verified Last Known Good path where possible;
- preserve Eject -> XeLL as the independent low-level escape hatch;
- never expose a generic novice `select .bin and flash` workflow;
- never claim that NAND flashing is unbrickable or power-loss-proof.

See [`docs/RECOVERY_ARCHITECTURE.md`](docs/RECOVERY_ARCHITECTURE.md) and [`schemas/recovery-package.schema.json`](schemas/recovery-package.schema.json).

## Worry-free / novice experience

CCLOS NAND Edition should feel like a finished console product rather than a collection of Xbox 360 modding utilities.

The default user should not need to understand CPU keys, KeyVaults, bad blocks, remapping, xeBuild, J-Runner or DashLaunch internals for ordinary supported installation, updates or recovery.

The PC builder and console UI should prefer:

```text
Detect -> Validate -> Explain -> Backup -> Perform -> Verify -> Recover
```

rather than asking the owner to manually select low-level hardware parameters.

See [`docs/NOVICE_EXPERIENCE.md`](docs/NOVICE_EXPERIENCE.md).

## Console-specific NANDs only

No generic ready-to-flash NAND image may be distributed. Every NAND image must be built from the target console's own NAND and preserve console-specific identity/configuration data.

The PC builder eventually produces the console's verified installation/recovery outputs locally.

## Development order

1. Snapshot, import, build and freeze the owner-approved latest local CCLOS source from `C:\cctu`.
2. Perform a NAND-size and dependency audit without changing UI or behavior.
3. Refactor platform/storage assumptions so CCLOS can operate without HDD storage.
4. Introduce the flash-system build target and XboxSystemBridge.
5. Add retail-system feature parity through Xbox services or CCLOS-native equivalents.
6. Integrate the DashLaunch-compatible plugin/runtime environment and preserve stealth-server compatibility.
7. Implement/prove flash-resident CCLOS Recovery, Safe Mode, USB recovery verification and XeLL rescue.
8. Build and verify console-specific NAND images offline.
9. Hardware-test deterministic boot/recovery first on the designated RGH3 Trinity 16 MB development console.
10. Only after recovery is proven: consider the integrated CCLOS Recovery flasher.

## Safety

Early milestones are **build/read/verify only**. Automated NAND flashing is deliberately excluded until the image builder, recovery process, console-specific preservation rules, backup/read-verification, XeLL rescue path, and hardware test matrix have been separately accepted.

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md), [`docs/NAND_SAFETY.md`](docs/NAND_SAFETY.md), [`docs/RECOVERY_ARCHITECTURE.md`](docs/RECOVERY_ARCHITECTURE.md), [`docs/NOVICE_EXPERIENCE.md`](docs/NOVICE_EXPERIENCE.md), [`docs/ROADMAP.md`](docs/ROADMAP.md), [`docs/LOCAL_SAMPLE_LIBRARY.md`](docs/LOCAL_SAMPLE_LIBRARY.md), and [`docs/MILESTONE_00_BASELINE.md`](docs/MILESTONE_00_BASELINE.md).