# Local CCLOS NAND Development Environment

This document records owner-confirmed local paths and readiness assumptions for CCLOS NAND Edition development.

## Confirmed local paths

```text
CCLOS donor source (READ ONLY):
C:\cctu

CCLOS NAND development workspace:
C:\CCLOS-NAND-Development\

Private console data:
C:\CCLOS-NAND-Development\PrivateConsoleData\

NAND sample library:
C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\

Working output:
C:\CCLOS-NAND-Development\Working\

Build output:
C:\CCLOS-NAND-Development\Builds\

Recovery material:
C:\CCLOS-NAND-Development\Recovery\

Logs:
C:\CCLOS-NAND-Development\Logs\

J-Runner with Extras reference installation (READ ONLY):
C:\Users\CGAmeDev\Downloads\J-Runner-with-Extras
```

## Confirmed toolchain/environment

The owner has confirmed:

- Visual Studio 2010 / Xbox 360 build environment is working;
- Xbox 360 XDK 21256.x-class tooling is available for the established CCLOS workflow;
- the designated first hardware bring-up console is an **RGH3 Trinity 16 MB**;
- an original NAND backup exists;
- the console is reachable through **Xbox 360 Neighborhood**;
- private NAND/reference working directories already exist;
- J-Runner with Extras is available locally for read-only comparison/reference use.

## Baseline policy

The owner explicitly approved using the latest validated local CCLOS source at `C:\cctu` rather than requiring exact v0.35.2 source provenance.

The currently observed source reports:

```text
CONSOLECRATE_VERSION       0.35.4
CONSOLECRATE_VERSION_LABEL 0.35.4 Internet Updates
```

Milestone 0 must freeze the exact approved local working-tree state before NAND-specific implementation begins. The donor may contain owner-approved uncommitted fixes. Do not clean/reset/mutate it.

## Read-only inputs

Unless a later owner-approved milestone explicitly authorizes otherwise, treat these as read-only:

- `C:\cctu`;
- `C:\Users\CGAmeDev\Downloads\J-Runner-with-Extras`;
- original NAND dumps;
- known-working RGH NAND images;
- CPU-key/KV reference material;
- original sample-library files.

Derived analysis/build data belongs under the CCLOS NAND development workspace, not inside donor/reference locations.

## Initial hardware safety boundary

Early milestones are read/analyze/build/verify only.

The first development-console flash must not occur until:

- baseline freeze is complete;
- NAND geometry/identity validation passes;
- bad-block/remap handling is proven offline;
- source NAND and CPU key validate together;
- candidate image preservation checks pass;
- XeLL recovery is confirmed;
- external programmer recovery remains available;
- the owner explicitly approves the hardware test image.

See `docs/NAND_SAFETY.md` and `docs/RECOVERY_ARCHITECTURE.md` for the complete safety contract.
