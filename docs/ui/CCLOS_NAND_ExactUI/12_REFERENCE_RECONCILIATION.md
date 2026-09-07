# Reference reconciliation — resolve conflicts without redesign

The generated pictures are visually cohesive but not internally identical. This
ledger prevents Codex from treating every incidental difference as a new rule.
Original files remain untouched. Any additional discrepancy must be recorded,
not silently guessed away.

## R01 · Global shell source

The owner-supplied Home PNG owns the common top navigation, CCLOS logo, profile
area, slogan and footer geometry. Other images govern their content bodies.
Minor shifts in logo/tab/footer placement between generated screens are not
permission to create multiple shells. Active tab underline moves only to the
corresponding fixed tab anchor. Render the common shell once, consistently.

## R02 · Multiple bright elements

Some pictures show a cyan hero, a green Downloads card and a highlighted nav tab
at the same time. These are different states: one keyboard/controller focus,
selected destination, and semantic download/status accent. They do not define
multiple simultaneous focus owners. A new focus move removes the previous focus
ring without deleting selected/semantic styling.

## R03 · Reference image versus production data

Keep the exact original image for source comparison. In production replace
placeholder values with real data inside the same bounds. This specifically
includes `Xbox Live (CCLOS)`, Brian, timestamps, capacities, game/media titles,
version/build strings, download statistics and status. The footer must not imply
Xbox-service connectivity from a successful ordinary CCLOS/Internet connection.

## R04 · Unsupported feature art

Keep panel placement and visual hierarchy; provide real existing actions and
honest unavailable states. Paid editions/cart/history, fake reviews/ratings,
cloud saves, cross-platform launch filters, unsupported campaign/save parsing,
5 GHz claims, HDR/4K claims, restart-TV and unverified social feeds are not
implementation scope. Detailed rules are in `07_CAPABILITY_AND_DATA_GAPS.md`.

For the supplemental Store Product panel: the main action uses the existing
Download / Add to Queue / Installed / Unavailable state, in the same action area.
The three edition boxes remain noninteractive metadata slots when no provider
supplies editions; display `Not available` rather than prices. Do not invent a
purchase flow. Report this explicit semantic correction in fixture/live proofs.

## R05 · Top-level versus submenu

Home, My Games, Store, Downloads, Settings and Media are the six main-screen
references. Continue Playing, Game Library and Store Product Detail are
supplemental page bodies, not replacements for those main screens. The seven
numbered submenu images retain their own route roles.

## R06 · Existing list-performance decisions

The new Home/section hubs may use the supplied artwork composition. Previously
approved optimized text-list behavior in actual catalog/media browsing must not
be replaced globally with eager poster loading. Bind the supplied preview/detail
regions to selected content and virtualize visible rows/cards. Media watched/
unwatched state remains `✓` / `▶`; retain separate Details and Play actions and
playback time/seek controls where already implemented. Log any direct conflict
between a prior performance milestone and a newly shown art rail; do not discard
either requirement without an explicit resolution.

## R07 · NAND reality

The rich reference files are development artifacts, not the flash payload.
Flash-resident core UI must be budgeted alongside required platform components
and Recovery. User art/caches and all high-churn writes remain storage-backed.
No-storage boot must preserve the shared shell and core settings/disc functions
with built-in defaults. A screen design cannot prove flash fit or boot feasibility.

## R08 · Candidate assets and exact fonts

Use the reference as authority over candidate SVG/PNG styling. Original font
identity and hidden background pixels are unverified. Exact pixel crops are
provided; alpha masks/background fill/components are reconstructed. A mismatch
requires a refinement or owner-approved localized exception, not silently
relabelling the candidate as the original.

## R09 · Prior product-version wording

Older roadmap headings may still mention the historical v0.35.2 baseline. The
current root baseline decision authorizes the latest validated local source at
`C:\cctu` (observed 0.35.4). Reverify and freeze that source; do not downgrade or
reset it to match a historical label in a screenshot or older milestone title.

## R10 · New unapproved pictures

The generated package-overview collage from this conversation is not an approved
screen. It changed compositions and sample content; it is excluded from this
package and cannot override the 16 source PNGs.
