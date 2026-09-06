# Local NAND Sample Library

CCLOS NAND Edition uses a private, owner-supplied NAND sample library for parser, builder, flash-layout, bad-block/remap and recovery validation.

## Canonical Windows location

The sample library exists only on the development PC at:

```text
C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\
```

Codex must check this path before asking the owner to re-provide NAND samples.

The repository must never contain the real sample data.

## Expected layout

```text
C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\
├── Trinity_16MB\
│   └── <sample>\
│       ├── Original\
│       ├── KnownWorkingRGH\
│       ├── BuildLogs\
│       ├── Secrets\
│       ├── Notes\
│       └── Other\
│
├── Corona_16MB\
│   └── <sample>\
│       ├── Original\
│       ├── KnownWorkingRGH\
│       ├── BuildLogs\
│       ├── Secrets\
│       ├── Notes\
│       └── Other\
│
├── Corona_4GB_MMC\
│   └── <sample>\
│       ├── Original\
│       ├── KnownWorkingRGH\
│       ├── BuildLogs\
│       ├── Secrets\
│       ├── Notes\
│       └── Other\
│
├── Needs_Review\
└── _Manifest\
    ├── CCLOS_NAND_Samples.csv
    ├── CCLOS_NAND_Samples.json
    ├── CCLOS_NAND_Samples.md
    └── DualReadValidation.csv
```

## How Codex should use the library

1. Read the sanitized manifest first when it exists.
2. Inventory the actual directories on disk rather than assuming a hard-coded sample count.
3. Treat every file under each sample's `Original\` directory as read-only owner data.
4. Use `KnownWorkingRGH\` only as a comparison/reference image. Never treat it as a universal template.
5. Use build logs to identify motherboard family, NAND/eMMC geometry, exploit/build options, bad blocks/remapping and other non-secret configuration.
6. Validate each NAND/CPU-key relationship before performing decrypted or console-specific analysis.
7. Use multiple samples to distinguish platform constants from console-specific data.
8. Include bad-block/remap samples and alternate xeBuild configurations in parser/builder tests.
9. Treat `Needs_Review\` as untrusted until classification is positively established.
10. Write all derived outputs outside the sample tree, for example:

```text
C:\CCLOS-NAND-Development\Working\
C:\CCLOS-NAND-Development\Builds\
C:\CCLOS-NAND-Development\Recovery\
C:\CCLOS-NAND-Development\Logs\
```

## Current supported reference families

The local library is intended to cover at least:

- Trinity 16 MB NAND;
- Corona 16 MB NAND;
- Corona 4 GB MMC/eMMC, using the approximately 48 MiB system area.

The exact number of samples in each family is intentionally not hard-coded here. Codex must read `_Manifest\CCLOS_NAND_Samples.json` or inventory the folders so newly added samples are automatically included.

## Security rules

Real NAND samples are private console-specific material.

Never:

- commit them to GitHub;
- upload them to third-party services;
- expose full CPU keys, DVD keys, Console IDs, decrypted KeyVault contents or comparable secrets;
- copy real console data into tracked fixtures, docs, issues or pull requests;
- print secrets in ordinary logs or screenshots;
- overwrite owner-provided source NANDs.

Sanitized manifests may contain hashes, board family, image size, kernel/build information, bad-block/remap descriptions and non-secret fingerprints for correlation.

## Important safety boundary

The presence of a valid sample library authorizes analysis, parsing, deterministic comparison and offline builder validation only. It does **not** authorize NAND flashing. Flash writes remain gated by the project recovery/safety milestones and owner-approved hardware testing.
