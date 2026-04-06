# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CPG Pipeline converts clinical practice guideline PDFs into structured, LLM-optimised markdown via a 5-agent pipeline with maker-checker separation. Each agent runs in a **separate session** (fresh context).

## Pipeline Phases

1. **SCAN** — Inventory PDF structure (pages, sections, visual elements)
2. **EXTRACT** — Pull raw content per page (text + visual descriptions)
3. **STRUCTURE** — Apply output schema, convert to target formats
4. **CHECK** — Validate output against source for accuracy/completeness
5. **RECONCILE** — Resolve checker findings, produce final validated output

Agent definitions live in `.claude/skills/` (one per stage).

## Commands

```bash
./scripts/run-pipeline.sh source/{name}.pdf                         # run full 5-agent pipeline
python scripts/validate.py                                          # run all validators
python scripts/coverage.py source/{name}.pdf output/final/{name}/   # check section coverage
```

## Repo Structure

- `source/` — input PDFs
- `output/raw/` — Stage 2 (EXTRACT) output
- `output/structured/` — Stage 3 (STRUCTURE) output
- `output/validated/` — Stage 4 (CHECK) output + checker reports
- `output/final/` — Stage 5 (RECONCILE) output, ready for consumption
- `templates/` — output schemas (the contract); `cpg-section.schema.md` for content, `decision-logic.schema.md` for decision logic
- `eval/` — quality metrics and checker reports
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
