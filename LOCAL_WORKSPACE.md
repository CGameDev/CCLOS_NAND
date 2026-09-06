# CCLOS NAND Edition — Local Development Workspace

The canonical Windows workspace for real console-specific development data is:

```text
C:\CCLOS-NAND-Development\
```

Codex must treat this location as local/private and must not upload its contents to GitHub or third-party services.

## Codex reference path

```text
C:\CCLOS-NAND-Development\PrivateConsoleData\
```

Current reference consoles:

```text
PrivateConsoleData\
├── Trinity_16MB\
│   ├── Original\flashdmp.bin
│   ├── KnownWorkingRGH\updflash.bin
│   ├── BuildLogs\
│   ├── Secrets\
│   └── Notes\
└── Corona_4GB_MMC\
    ├── Original\flashdmp.bin
    ├── KnownWorkingRGH\updflash.bin
    ├── BuildLogs\
    ├── Secrets\
    └── Notes\
```

Derived artifacts belong under:

```text
C:\CCLOS-NAND-Development\Working\
C:\CCLOS-NAND-Development\Builds\
C:\CCLOS-NAND-Development\Recovery\
C:\CCLOS-NAND-Development\Logs\
```

## Rules

- `Original\flashdmp.bin` is read-only owner source material.
- `KnownWorkingRGH\updflash.bin` is a read-only comparison image.
- `Secrets\` contains private console data and must never be printed into ordinary logs or committed.
- The Trinity 16 MB reference is the preferred first hardware target unless an approved milestone says otherwise.
- The Corona reference is a 4 GB MMC console using a 48 MiB system NAND area and must not be treated as a 16 MB Corona NAND.
- No file in this workspace authorizes hardware flashing. Early work remains read/build/verify only until an owner-approved milestone explicitly permits a write operation.

See `PrivateConsoleData/README.md` and `AGENTS.md` for the binding Codex/security rules.
