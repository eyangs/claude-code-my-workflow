# Quarto vs Beamer Audit: Demo_Simple (Round 1)

**Beamer source:** `Slides/Demo_Simple.tex` (8 frames)  
**Quarto source:** `Quarto/Demo_Simple.qmd` (6 content slides + section/title/end slides)  
**Date:** 2026-02-18

## Verdict: NEEDS REVISION

## Hard Gate Status

| Gate | Status | Evidence |
|---|---|---|
| Overflow | Pass | No obvious overflow in source structure |
| Plot Quality | N/A | No plots in this demo |
| Content Parity | Pass | Core equations and sections are present |
| Visual Regression | Pass | Basic revealjs structure is intact |
| Slide Centering | Pass | No explicit conflicting alignment rules |
| Notation Fidelity | Pass | Key equations preserved (`\tau_i`, `Y_{1i}`, `Y_{0i}`) |

## Issues Found

### Major
1. **QA scorer false-positive style warnings** from `scripts/quality_score.py`:
   - Missing DOCTYPE
   - Missing title tag
   - Broken citation regex warning

### Minor
1. Beamer frame count (8) and QMD H2 count (6) differ structurally (acceptable for this demo, but should be documented).

## Required Fixes (for round 1)
1. Re-render Quarto to ensure latest settings are applied.
2. Validate HTML metadata directly in rendered output (instead of relying only on the simplistic scorer).
3. Re-audit with the same gates.
