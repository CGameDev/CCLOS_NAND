# PrivateConsoleData — Local-Only Console Data Workspace

This tracked directory is the **usage contract** for real console-specific Xbox 360 development data used by CCLOS NAND Edition tooling and Codex.

## Canonical local workspace

The real owner-provided NAND data is stored **outside the Git repository** at this fixed Windows location:

```text
C:\CCLOS-NAND-Development\PrivateConsoleData\
```

Codex must check that external path **before asking the owner to provide NAND files, CPU keys, build logs, or known-good RGH images again**.

The repository-local `PrivateConsoleData/` directory contains documentation only. Do not copy real console files into tracked repository paths.

### Current reference consoles

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
- `Corona_4GB_MMC` — Corona 4 GB MMC console, 48 MiB system NAND area, 17559 reference build.

The `Original\flashdmp.bin` files are the owner-provided source NANDs. The `KnownWorkingRGH\updflash.bin` files are known-working comparison images. Both are **read-only reference inputs**.

## Codex behavior

When a milestone requires real console data, Codex must:

1. Read this file and check `C:\CCLOS-NAND-Development\PrivateConsoleData\` automatically.
2. Inventory available files locally.
3. Identify likely NAND dumps, CPU-key text, build logs, launch/plugin configuration, XeLL output, and related diagnostic material by content/type where practical.
4. Validate relationships between the original NAND, CPU key, hardware identity/configuration, and known-good RGH image before relying on them.
5. Prefer the Trinity 16 MB reference for the first hardware-oriented milestone unless an owner-approved milestone says otherwise.
6. Continue automatically when required inputs are present and valid.
7. Ask the owner only when a genuinely required input is missing, ambiguous, corrupt, inconsistent, or unsafe to infer.
8. Treat owner-provided originals as read-only. Never modify them in place.
9. Write derived artifacts only under the external workspace locations such as:

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

Initial Codex use of the external `PrivateConsoleData` workspace is analysis-only. No NAND write is authorized by the presence of these files.

The original NAND plus its matching CPU key is the primary console-specific source of truth. Standalone KV/SMC files should not be required when they can be safely extracted and validated from the source NAND.

Do not overwrite `flashdmp.bin`, `updflash.bin`, `cpukey.txt`, `KV_Info.txt`, the original source archives, or any other owner-provided reference file.
