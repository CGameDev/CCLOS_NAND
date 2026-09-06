# DashLaunch / Plugin / Stealth Compatibility Contract

## Product decision

CCLOS NAND Edition must preserve compatibility with the established Xbox 360 DashLaunch-style runtime/plugin ecosystem where technically required, while keeping CCLOS itself independent of any specific third-party plugin or stealth provider.

DashLaunch functionality may be part of the NAND/system environment, but the old DashLaunch GUI is not the CCLOS user experience. CCLOS Settings may eventually provide a CCLOS-native front end for supported boot/plugin settings.

## Base boot must not require HDD configuration

The flash image must contain a safe default boot policy that reaches CCLOS even when:

- HDD is removed;
- onboard MU is absent/unavailable;
- USB storage is absent;
- no external `launch.ini` exists;
- configured external plugin files are missing.

Storage-backed configuration can override/extend safe defaults, but it must not be the only source of the CCLOS boot target.

## Existing configuration preservation

When a console already uses plugin configuration, migration tooling must:

1. read and validate the existing configuration;
2. preserve user-owned plugin entries where compatible;
3. avoid silently changing plugin order;
4. locate a safe CCLOSRuntime slot or use the architecture's validated persistent-runtime mechanism;
5. create a backup of the previous configuration;
6. produce a before/after migration report;
7. fall back to flash-safe CCLOS defaults if external configuration is missing/corrupt.

Do not overwrite a user's plugin list with a CCLOS-only file.

## Stealth-server compatibility

Stealth compatibility is a **coexistence target**.

CCLOS does not:

- implement a stealth service;
- bypass Xbox authentication/security itself;
- embed one commercial/free stealth provider into the NAND;
- silently disable `LiveBlock`, `LiveStrong` or comparable user protection settings;
- assume Xbox Live should be reachable merely because CCLOS Internet services need network access.

CCLOS should:

- preserve XAM/XUser/XNet system-service paths needed by the Xbox platform;
- avoid interfering with validated external plugin initialization;
- distinguish ordinary Internet/CCLOS service connectivity from Xbox-service connectivity;
- expose safe status/diagnostic information without stealing credentials or provider-specific data;
- allow the user to remove/replace a stealth plugin without reflashing the CCLOS system image.

## External plugin storage

Third-party mutable plugins normally belong on writable user storage, not in immutable CCLOS flash.

Example conceptual model:

```text
SYSTEM FLASH
  DashLaunch-compatible runtime layer
  CCLOSRuntime
  CCLOS

USER STORAGE (optional)
  stealth.xex
  controller/input plugins
  other user plugins
  user plugin configuration/overrides
```

If user storage is removed, CCLOS must continue to boot normally with external plugins unavailable.

## CCLOS settings UI

A future owner-approved milestone may expose existing plugin/boot settings inside the **existing CCLOS Settings visual language**.

Candidate information:

- runtime layer active/version;
- configured plugin slots;
- loaded/missing status;
- CCLOSRuntime state;
- LiveBlock/LiveStrong state (read/report first; writes only when verified and explicitly authorized);
- flash-default versus storage-override source;
- safe-default restore action;
- per-plugin enable/disable where supported safely.

This does not authorize a UI redesign.

## Game/runtime transitions

Compatibility tests must include:

```text
Cold boot -> CCLOS
CCLOS -> Xbox profile
CCLOS -> Xbox system service UI where used
CCLOS -> Xbox 360 title
Title -> CCLOS Guide/Runtime
Title exit -> CCLOS
CCLOS -> Original Xbox title where supported
Power cycle -> plugin/runtime persistence
HDD removed -> flash-safe CCLOS boot
```

Third-party stealth/plugin tests are owner-selected and separate from CCLOS functional acceptance.

## Failure policy

External plugin failure must not create a CCLOS boot loop.

Where technically possible, recovery/safe mode should permit booting CCLOS with external plugin overrides disabled while preserving the user's files for later diagnosis.
