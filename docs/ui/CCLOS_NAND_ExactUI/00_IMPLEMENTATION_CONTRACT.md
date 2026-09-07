# Binding implementation contract — no visual reinterpretation

## Authority and explicit supersession

The owner has explicitly selected the supplied CCLOS screens as the new NAND
front-end appearance. This milestone is the owner-approved exception allowed by
`AGENTS.md` section 2 and the prior UI-preservation rules. For the listed screens,
it supersedes **visual preservation of the old donor UI only**. Baseline source
freezing, backend semantics, feature preservation, no-storage operation, system
service isolation, recovery requirements and NAND safety remain mandatory.

Priority within this visual milestone:

1. Owner's explicit corrections and approvals.
2. Home source PNG for the common shell; each registered PNG for its page body.
3. `12_REFERENCE_RECONCILIATION.md` for known conflicts and fictional content.
4. Measured rectangles in `04_LAYOUTS.json` and design tokens.
5. Reconstructed runtime candidates and implementation convenience.

A PNG that disagrees with a measured rectangle wins unless the reconciliation
ledger explicitly resolves that disagreement. Do not silently adjust the reference
image or a test to make an incorrect implementation pass.

## What is locked

The Home composition, background treatment, CCLOS wordmark, navigation order,
profile/status area, top slogan, footer geometry, planet horizon treatment, hero
placement, tile proportions, row rhythm, corner treatment, border weight, icon
alignment, label hierarchy, colors, accent behavior and focus language are locked.

Top navigation remains **Home → My Games → Media → Store → Downloads → Settings**.
The implementation work order differs intentionally: Home, My Games, Store,
Downloads, Settings, Media. Do not confuse work order with on-screen navigation.

The top `Store` destination uses the existing CCLOS Marketplace backend; the Home
card keeps `Marketplace`. `My Games` maps to existing collection services; the Home
card keeps `My Collection`. `Media` maps to the existing Media Center. Do not
rename these elements for cosmetic consistency.

Use one shared shell instance/component definition across all screens. There
must not be six separately approximated headers or seven differently spaced
footers. A page may update the active tab and live data, not the shared geometry.

## What exact means

Preserve the supplied design rather than produce a similar-looking alternative.
Render real interactive components, real text, real focus, working controller
navigation and adapter-backed data. A full screenshot displayed behind invisible
hotspots is **not** an implementation and fails acceptance.

Static source artwork may legitimately be reused as textures. Screen PNGs and
crops containing baked dynamic values are reference/fixture material only. A logo
is static art; the gamertag, clock, download rate, storage amount, network status,
selected game title and completion percentage are not.

No first-pass visual-accuracy percentage is promised. A flattened generated PNG
does not reveal the original font file, hidden background pixels or interaction
states. Reconstructed candidates must be compared against the original. Report
unknowns explicitly rather than calling approximations pixel-identical.

## Forbidden changes

- No alternate dashboard, template, new color palette, new logo, different hero composition, rounded-pill redesign or generic Xbox UI.
- No replacement with NXE, Metro, Aurora, FSD, Fusion, a web page, WinForms, WPF, Electron, Unity or a new renderer merely to reproduce these images.
- No arbitrary reordering, removal or addition of destinations to simplify implementation.
- No global rewrite of downloads, catalog manifests, single/segmented downloads, extraction, media networking, achievements, profile persistence or disc operations.
- No full-resolution reference PNGs packaged into flash as the user interface.
- No invented public APIs, XAM ordinals, flash paths, NAND offsets, source metrics or test results.
- No hardcoded Brian profile, screenshot dates, fake transfer rates, purchases, subscription offers, social feeds or cloud saves in a release build.
- No hidden reduction of resolution, style or feature coverage to claim completion.

## Legitimate changes to live data

Preserve position, typography hierarchy, dimensions and styling while binding
values to real services. Actual titles, artwork, user identity, clock, counts and
status replace screenshot samples. Empty/offline/unsupported content uses the same
component footprint with honest state text. It never pretends the screenshot's
fictional service exists. See the reconciliation ledger for exact decisions.

## Baseline and implementation boundary

Read `AGENTS.md`, `BASELINE_LOCK.md`, `baseline/baseline.lock.json` and the source
freeze report first. Audit `C:\cctu` read-only and follow the current approved
local-source baseline, not a guessed remote tag. The observed `0.35.4` label is a
starting fact to reverify locally, not a reason to overwrite a newer approved fix.

Build against the frozen `src/CCLOS/` copy after the baseline gate. Reuse the
existing Xbox 360 C++ renderer and established toolchain. Isolate presentation
changes from authoritative services. Adapt existing APIs through narrow view
models/commands; retain thread ownership and service lifetimes.

## Stop conditions

Stop the affected implementation checkpoint and record a specific blocker if an
original PNG is absent/hash-mismatched; the baseline is unverified; an exact font
cannot be established; a required artwork layer cannot pass comparison; a control
has no verified service; or the flash-core payload cannot fit with recovery and
required platform components. Do not redesign to conceal the blocker. Unrelated
safe work may continue when its prerequisites are satisfied.

No ordinary UI approval waives NAND/recovery acceptance. No asset/tooling test is
proof that the dashboard builds, runs, boots from flash or reaches a frame target.
