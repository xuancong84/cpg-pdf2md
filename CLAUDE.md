# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CPG Pipeline converts clinical practice guideline PDFs into structured, LLM-optimised markdown via a 7-agent pipeline with maker-checker separation. Each agent runs in a **separate session** (fresh context). A multi-sample variant (`run-multisample-pipeline.sh`) runs Phases 1–6 multiple times and reconciles results pairwise in Phase 7.

## Pipeline Phases

1. **SCAN** — Inventory PDF structure (pages, sections, visual elements)
2. **EXTRACT** — Pull raw content per page (text + visual descriptions)
3. **STRUCTURE** — Apply output schema, convert to target formats
4. **CHECK** — Validate output against source for accuracy/completeness
5. **RECTIFY** — Resolve checker findings, produce final validated output
6. **COMBINE** — Merge all rectified section files into one hierarchical markdown document
7. **RECONCILE** — Pairwise reconcile multiple run candidates into a single canonical output

Agent definitions live in `.claude/skills/` (one per stage).

## Commands

```bash
./scripts/run-pipeline.sh source/{basename}.pdf                         # run full 6-agent pipeline
./run-multisample-pipeline.sh source/{basename}.pdf [N=4]                # multi-run pipeline with pairwise reconciliation
python scripts/validate.py                                          # run all validators
python scripts/coverage.py source/{basename}.pdf output/final/{basename}/   # check section coverage
```

## Repo Structure

- `source/` — input PDFs
- `output/{basename}/raw/` — Stage 2 (EXTRACT) output
- `output/{basename}/structured/` — Stage 3 (STRUCTURE) output
- `output/{basename}/validated/` — Stage 4 (CHECK) output + checker reports
- `output/{basename}/final/` — Stage 5 (RECTIFY) output, ready for combination
- `output/{basename}/combined/` — Stage 6 (COMBINE) output, single merged markdown per guideline
- `templates/` — output schemas (the contract); `cpg-section.schema.md` for content, `decision-logic.schema.md` for decision logic
- `eval/{basename}/` — quality metrics and checker reports
- `.claude/skills/` — agent definitions (one per pipeline stage)

## Clinical Content Rules

- **NEVER invent clinical content.** Flag unclear items with `<!-- REVIEW: ... -->`.
- Drug names: generic only (metformin, not Glucophage).
- Units: always explicit (mg/dL, mmol/L, mL/min/1.73m²).
- Doses: exact match to source — never round.

## Format Rules

- Decision trees: **mermaid `graph TD`** syntax only.
- Treatment/decision logic: **IEET (If-Elif-Else Tree)** format only.
- Never use ASCII box-drawing characters for diagrams.
- All output must conform to `templates/cpg-section.schema.md` and `templates/decision-logic.schema.md` — no exceptions.
