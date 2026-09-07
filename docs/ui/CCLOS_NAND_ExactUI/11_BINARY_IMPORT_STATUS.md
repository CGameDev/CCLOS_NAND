# Binary reference import status

The GitHub-side implementation contract, screen registry, layout/component rules, route map, acceptance rules, validator and import/publish scripts are tracked.

The authoritative generated PNG batch is approximately 35 MB as a ZIP and must be imported byte-for-byte from the owner-approved package before visual implementation. The package is:

- File: `CCLOS_NAND_ExactUI_v1.0.zip`
- SHA-256: `56037f4dea206c12304891fa33092aa79a2479a7749b26d091487035bd9be08c`

From the repository root on the development PC, publish it with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\ui\Publish-CCLOSExactUI.ps1 -PackageZip "C:\path\to\CCLOS_NAND_ExactUI_v1.0.zip"
```

The script validates the ZIP hash, imports the ordered asset folders, validates every authoritative screen against `03_SCREEN_REGISTRY.json`, stages only ExactUI/docs/tool paths, commits and performs a normal non-force push to `main`.

**Codex gate:** if `tools\ui\Validate-CCLOSExactUI.ps1` does not pass, no visual implementation may begin. Do not generate replacements or choose another design.
