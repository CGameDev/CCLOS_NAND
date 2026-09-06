# CCLOS NAND Edition

**ConsoleCrate Live OS — Native Flash Architecture for Xbox 360**

CCLOS NAND Edition is the firmware-oriented branch of ConsoleCrate Live OS. The goal is to make CCLOS the flash-resident Xbox 360 system shell on supported RGH/JTAG consoles while retaining the Xbox 360 kernel, hypervisor, XAM, XUser, XContent, XNet, hardware services, and other required platform components.

This project is **not** a new dashboard design and is **not** an HDD-installed dashboard with a NAND boot pointer.

## Non-negotiable product definition

A console flashed with CCLOS NAND Edition must be capable of booting into the CCLOS shell and accessing core console functionality with **no HDD, Memory Unit, USB storage, or network connection installed**. External storage expands functionality but must never be a boot requirement.

The Microsoft retail dashboard shell is not the target shell. CCLOS provides the user-facing environment and uses retained Xbox system services through a dedicated XboxSystemBridge layer.

## Baseline lock

The visual, navigation, terminology, feature, and behavior baseline is the existing **CCLOS Public Beta v0.35.2** release.

Public release artifact:

`http://consolecrate.xyz/updates/CCLOS_Public_Beta_v0.35.2.zip`

Source donor repository:

`https://github.com/CGameDev/ConsoleCrateLive.git`

Expected source family:

`CCLOS`

**Important:** the currently visible `CCLOS` source branch reports version `0.34.0`, while the public beta is `0.35.2`. Codex must not assume those are equivalent. The first implementation gate is to locate or obtain the source revision that actually produced the v0.35.2 public release, record its commit SHA, and import that exact baseline. If the exact source revision cannot be established, implementation stops at the baseline audit. Codex must never recreate missing v0.35.2 UI or behavior from memory or by approximation.

See [`BASELINE_LOCK.md`](BASELINE_LOCK.md) and [`AGENTS.md`](AGENTS.md).

## UI preservation rule

CCLOS NAND Edition must retain the existing CCLOS public-release interface exactly unless an owner-approved milestone explicitly authorizes a UI change.

Codex must not independently:

- create a replacement dashboard UI;
- redesign Home, Shop, My Collection, Queue, Downloads, Achievements, System Health, Settings, Network, Data, About, Security, Watch TV, Social Hub, or other established pages;
- alter the top or bottom HUD;
- change navigation geometry, focus behavior, fonts, icons, backgrounds, translucency, spacing, color treatment, or page hierarchy merely to suit the NAND architecture;
- substitute retail NXE/Metro visuals;
- introduce a new visual language for NAND-only settings.

New NAND/system functions must be integrated into the existing CCLOS shell and design system.

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
- recovery components;
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
- optional third-party plugins such as stealth-service plugins.

## Recovery

The target recovery contract is:

```text
POWER -> CCLOS
EJECT -> XeLL
CCLOS startup failure -> CCLOS Recovery
```

No generic ready-to-flash NAND image may be distributed. Every NAND image must be built from the target console's own NAND and preserve console-specific identity/configuration data.

## Development order

1. Establish and lock the exact CCLOS v0.35.2 source baseline.
2. Perform a NAND-size and dependency audit without changing UI or behavior.
3. Refactor platform/storage assumptions so CCLOS can operate without HDD storage.
4. Introduce the flash-system build target and XboxSystemBridge.
5. Add retail-system feature parity through Xbox services or CCLOS-native equivalents.
6. Integrate the DashLaunch-compatible plugin/runtime environment and preserve stealth-server compatibility.
7. Build and verify console-specific NAND images offline.
8. Hardware testing only after deterministic build/verification and recovery paths are proven.

## Safety

Early milestones are **build/read/verify only**. Automated NAND flashing is deliberately excluded until the image builder, recovery process, console-specific preservation rules, and hardware test matrix have been separately accepted.

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md), [`docs/NAND_SAFETY.md`](docs/NAND_SAFETY.md), and [`docs/MILESTONE_00_BASELINE.md`](docs/MILESTONE_00_BASELINE.md).