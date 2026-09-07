# Visual and functional acceptance

A screen is not accepted because it merely looks similar.

Required evidence for each checkpoint:

- Verify the exact reference file and SHA-256 before coding.
- Use one shared shell, not separately approximated headers/footers per page.
- Render a deterministic fixture state with the real Xbox 360 renderer.
- Align the renderer capture to the 1672×941 source coordinate system.
- Produce and inspect overlay/difference output without editing the source reference.
- Verify major geometry, typography hierarchy, border/focus treatment and one unambiguous focus owner.
- Exercise controller navigation and pressed/disabled states.
- Test empty, offline, error and unsupported-capability states.
- Bind real adapters/services after fixture comparison; do not hardcode screenshot sample data into release builds.
- Regress existing download/catalog/media/profile/disc behavior.
- Measure memory/texture/flash impact instead of guessing.
- Record a rollback commit.

Do not claim a visual-match percentage unless an actual comparison tool computed it. Do not claim hardware success until the owner reports a physical-console result.
