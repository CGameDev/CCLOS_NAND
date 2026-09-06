# PrivateConsoleData — Local-Only Console Data Workspace

This directory is intentionally reserved for **local, console-specific and potentially sensitive Xbox 360 data** used by CCLOS NAND Edition tooling and Codex during NAND-analysis, builder, verification and hardware-validation milestones.

## Important

The contents of this directory must remain local to the development machine and **must never be committed to GitHub**.

The repository-level `.gitignore` excludes `PrivateConsoleData/` and common NAND/key file types. Keep this README in source control only as the usage contract; real contents are local-only.

## What may be placed here

Examples include:

```text
PrivateConsoleData/
  OriginalNAND.bin
  CurrentRGH3NAND.bin
  CPUKey.txt
  launch.ini
  xell-output.txt
  nand-info.txt
  photos-or-notes/
```

File names do not have to match these examples. Codex/tooling must scan the folder and identify candidate files by content/type where possible instead of requiring the user to rename everything manually.

## Codex behavior

When a milestone requires real console data, Codex must:

1. Check `PrivateConsoleData/` automatically before asking the owner for NAND/CPU-key/console-specific files.
2. Inventory available files locally.
3. Identify likely NAND dumps, CPU-key text, launch/plugin configuration and related diagnostic material.
4. Validate relationships between files before use.
5. Continue automatically when the required inputs are present and valid.
6. Ask the owner only when a genuinely required input is missing, ambiguous, corrupt or unsafe to infer.

## Security and privacy rules

Never:

- commit any real file from this directory;
- copy a NAND dump into another tracked repository path;
- print or echo a full CPU key into normal logs, GitHub issues, PR comments, screenshots or reports;
- expose decrypted KeyVault contents;
- expose DVD keys, console IDs, credentials or other console secrets unnecessarily;
- include private console material in generated public test fixtures;
- upload files from this folder to third-party services;
- include secrets in crash reports or support bundles.

Public/debug output should use redacted identifiers or non-secret fingerprints/hashes when correlation is needed.

## Expected first Trinity development-console data

For the initial Trinity 16 MB RGH3 hardware milestone, useful local inputs include:

- original NAND dump;
- CPU key;
- known-good current RGH3 NAND dump, if available;
- current `launch.ini`, if plugin compatibility must be preserved;
- XeLL output / console information, if available;
- any owner notes identifying motherboard/NAND/exploit state.

The original NAND + CPU key are the primary source of truth. Standalone KV/SMC files should not be required when they can be safely extracted and validated from the source NAND.

## Read-only first

Initial Codex use of `PrivateConsoleData/` is analysis-only. Do not modify original owner files in place.

Derived files must go to an ignored working/output directory such as:

```text
local-output/
recovery-private/
```

Never overwrite `OriginalNAND.bin` or another owner-provided source file.
