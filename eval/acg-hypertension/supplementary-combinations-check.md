## supplementary-combinations Validation Report

**Overall: NEEDS REVIEW**

### Completeness: 4/5 items present
- [x] CCBs — dihydropyridine (4 agents) and non-dihydropyridine (2 agents) with dosing
- [x] Diuretics — thiazide/thiazide-like (hydrochlorothiazide, indapamide IR/SR) with dosing
- [x] Single-pill combinations table — all 11 medication class rows with agent names
- [x] Verapamil IR exemption item note
- [ ] **MISSING: Source footnotes with clinical context:**
  - "Underline denotes availability on government subsidy list" — not captured
  - "Includes medications with single active ingredient registered in Singapore" — not captured
  - "Maximum dosage may be lower for elderly" — not captured
  - "'Use not recommended' indicates limited or no clinical data reported in the product information leaflets" — not captured

### Accuracy: 1 issue found (minor)
- Raw extraction uses "HCTZ" abbreviation for hydrochlorothiazide in single-pill combinations; structured output expands to full "hydrochlorothiazide". This is acceptable and arguably clearer, but creates inconsistency with how the source PDF presents the data.

### Schema: 1 violation
- **Structural misplacement:** This file is titled "Supplementary Table S2 – Single-pill Combinations" but contains CCBs and Diuretics that belong to Table S1. The file mixes two distinct source tables (S1 continuation and S2) under a single S2 title. The CCB and Diuretic individual agent data should be in supplementary-medications.md.

### Clinical safety: 1 flag
- **WARNING (LOW):** The footnote "Maximum dosage may be lower for elderly" is a blanket clinical caution applying to all medications in Table S1. Its omission removes a safety reminder for elderly prescribing that the source explicitly provides.

### Confidence: MEDIUM
Drug data is accurate. Structural misplacement of Table S1 content and missing clinical footnotes are the concerns.
