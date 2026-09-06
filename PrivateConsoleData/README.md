# PrivateConsoleData — Local-Only Console Data Workspace

This tracked directory is the **usage contract** for real console-specific Xbox 360 development data used by CCLOS NAND Edition tooling and Codex.

## Canonical local workspace

The real owner-provided NAND data is stored **outside the Git repository** at this fixed Windows location:

```text
C:\CCLOS-NAND-Development\PrivateConsoleData\
```

Codex must check that external path **before asking the owner to provide NAND files, CPU keys, build logs, known-good RGH images, or NAND samples again**.

The repository-local `PrivateConsoleData/` directory contains documentation only. Do not copy real console files into tracked repository paths.

### Primary development references

```text
C:\CCLOS-NAND-Development\PrivateConsoleData\
├── Trinity_16MB\
│   ├── Original\flashdmp.bin
│   ├── KnownWorkingRGH\updflash.bin
│   ├── BuildLogs\
│   ├── Secrets\
│   │   ├── cpukey.txt
│   │   └── KV_Info.txt
│   └── Notes\
│
└── Corona_4GB_MMC\
    ├── Original\flashdmp.bin
    ├── KnownWorkingRGH\updflash.bin
    ├── BuildLogs\
    ├── Secrets\
    │   ├── cpukey.txt
    │   └── KV_Info.txt
    └── Notes\
```

Reference identities:

- `Trinity_16MB` — Trinity, 16 MiB NAND, 17559 reference build.
- `Corona_4GB_MMC` — Corona 4 GB MMC console, approximately 48 MiB system NAND area, 17559 reference build.

The `Original\flashdmp.bin` files are owner-provided source NANDs. The `KnownWorkingRGH\updflash.bin` files are known-working comparison images. Both are **read-only reference inputs**.

## Consolidated local sample library

A larger private NAND sample library is stored at:

```text
C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\
```

Its expected family layout is:

```text
Samples\
├── Trinity_16MB\
├── Corona_16MB\
├── Corona_4GB_MMC\
├── Needs_Review\
└── _Manifest\
    ├── CCLOS_NAND_Samples.csv
    ├── CCLOS_NAND_Samples.json
    ├── CCLOS_NAND_Samples.md
    └── DualReadValidation.csv
```

Within each classified sample, the organizer uses:

```text
<sample>\
├── Original\
├── KnownWorkingRGH\
├── BuildLogs\
├── Secrets\
├── Notes\
└── Other\
```

Codex must read the sanitized manifest and/or inventory the actual local folders instead of assuming a fixed sample count. New samples may be added over time.

See `docs/LOCAL_SAMPLE_LIBRARY.md` for the full sample-library contract.

## Codex behavior

When a milestone requires real console data, Codex must:

1. Read this file and check `C:\CCLOS-NAND-Development\PrivateConsoleData\` automatically.
2. For multi-sample parser/builder/layout testing, check `C:\CCLOS-NAND-Development\PrivateConsoleData\Samples\` and read `_Manifest\CCLOS_NAND_Samples.json` when present.
3. Inventory available files locally.
4. Identify likely NAND dumps, CPU-key text, build logs, launch/plugin configuration, XeLL output, and related diagnostic material by content/type where practical.
5. Validate relationships between the original NAND, CPU key, hardware identity/configuration, and known-good RGH image before relying on them.
6. Use multiple samples to distinguish stable motherboard/NAND-layout behavior from console-specific bytes and configuration.
7. Include real bad-block/remap cases and differing xeBuild configurations in parser/builder validation when available.
8. Prefer the Trinity 16 MB primary reference for the first hardware-oriented milestone unless an owner-approved milestone says otherwise.
9. Continue automatically when required inputs are present and valid.
10. Ask the owner only when a genuinely required input is missing, ambiguous, corrupt, inconsistent, or unsafe to infer.
11. Treat owner-provided originals as read-only. Never modify them in place.
12. Write derived artifacts only under the external workspace locations such as:

```text
C:\CCLOS-NAND-Development\Working\
C:\CCLOS-NAND-Development\Builds\
C:\CCLOS-NAND-Development\Recovery\
C:\CCLOS-NAND-Development\Logs\
```

## Security and privacy rules

Never:

- commit any real NAND, CPU key, KeyVault data, DVD key, Console ID, or other console secret;
- copy real console data into another tracked repository path;
- print or echo a full CPU key into normal logs, GitHub issues, PR comments, screenshots, or reports;
- expose decrypted KeyVault contents;
- expose DVD keys, console IDs, credentials, or other console secrets unnecessarily;
- include private console material in generated public test fixtures;
- upload files from the external workspace to third-party services;
- include secrets in crash reports or support bundles.

Public/debug output should use redacted identifiers or non-secret fingerprints/hashes when correlation is needed.

## Read-only first

Initial Codex use of the external `PrivateConsoleData` workspace and `Samples` library is analysis-only. No NAND write is authorized by the presence of these files.

The original NAND plus its matching CPU key is the primary console-specific source of truth. Standalone KV/SMC files should not be required when they can be safely extracted and validated from the source NAND.

Do not overwrite `flashdmp.bin`, `updflash.bin`, `cpukey.txt`, `KV_Info.txt`, any source archive, any sample `Original\` file, or any other owner-provided reference file.
