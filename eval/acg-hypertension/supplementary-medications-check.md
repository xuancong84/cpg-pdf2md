## supplementary-medications Validation Report

**Overall: NEEDS REVIEW**

### Completeness: 4/6 items present
- [x] ACE inhibitors — all 7 agents with initial dose, max dose, renal adjustment
- [x] ARBs — all 8 agents with initial dose, max dose, renal adjustment
- [x] Beta blockers — all 5 cardioselective + all 3 non-cardioselective agents
- [x] Mechanism, precautions, and common side effects per class
- [ ] **MISSING: CCBs and Diuretics** — Table S1 in the source PDF spans pages 10-11. Page 11 contains CCBs (amlodipine, felodipine, lacidipine, nifedipine, verapamil, diltiazem) and Diuretics (hydrochlorothiazide, indapamide) as part of Table S1, but these were placed in supplementary-combinations.md instead of this file. This is a **structural misattribution** — these medications are standalone agents in Table S1, not single-pill combinations (Table S2).
- [ ] **MISSING: Government subsidy list indicators** — Source uses underlines to denote medications available on Singapore government subsidy. This information is not captured anywhere in the structured output. Clinically relevant for prescribing in the Singapore context.

### Accuracy: spot-check of 10 critical values (0 errors found)
- Captopril max: 50 mg TDS — MATCH
- Enalapril renal (CrCl <10): initial 1.25 mg OD or 2.5 mg EOD, max 10 mg/day — MATCH
- Perindopril erbumine max: 8-16 mg OD — MATCH
- Losartan max: 100 mg OD — MATCH
- Valsartan max: 320 mg OD — MATCH
- Atenolol renal (CrCl <15): max 25 mg OD or 50 mg EOD — MATCH
- Bisoprolol renal (CrCl <20): max 10 mg/day — MATCH
- Nebivolol max: 40 mg/day (>65 years: max 5 mg/day) — MATCH (footnote correctly integrated)
- Carvedilol initial: 12.5 mg OD for first 2 days, then 25 mg OD — MATCH
- Propranolol max: 160 mg/day — MATCH

### Schema: 0 violations
- content_types: [drug_list] — matches actual content
- YAML frontmatter valid
- Dosing abbreviation legend present

### Clinical safety: 1 flag
- **WARNING (MEDIUM):** CCBs and Diuretics being in the wrong file (supplementary-combinations.md) means a clinician looking up standalone CCB or diuretic dosing in Table S1 would not find them where expected. They would need to navigate to a file titled "Single-pill Combinations" to find individual agent dosing for amlodipine, hydrochlorothiazide, etc. This is a navigation hazard, not a content error, but could delay or confuse clinical lookup.

### Confidence: MEDIUM
Drug dosing data present is accurate. The structural split of Table S1 across two files — with CCBs and Diuretics misplaced under Table S2's file — is the primary concern.
