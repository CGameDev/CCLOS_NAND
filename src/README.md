# Source Tree

`src/CCLOS/` is reserved for the exact, provenance-locked **CCLOS Public Beta v0.35.2 source baseline**.

Do not manually create or approximate that directory. It must be populated only after M0 resolves the exact release-producing commit and `tools/Import-CCLOSBaseline.ps1` accepts it.

Planned NAND-specific source ownership after M0:

```text
src/
  CCLOS/                 Exact imported public-release baseline + reviewed adaptations
  CCLOSNand/             Flash-build/platform integration owned by NAND Edition
  XboxSystemBridge/      Isolated Xbox system-service adapters
  CCLOSRecovery/         Flash-resident recovery environment
```

The exact module split may change after the M1 flash/dependency audit. Do not create parallel UI implementations in NAND-specific directories. The visible shell remains the imported CCLOS product.