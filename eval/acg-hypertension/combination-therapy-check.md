## combination-therapy Validation Report

**Overall: NEEDS REVIEW**

### Completeness: 7/8 items present
- [x] Table 3 — cardioselective vs non-selective BB prescribing considerations
- [x] Recommendation 4 text with strength annotation (conditional)
- [x] Dual therapy BP-lowering magnitude (SBP 20-25 mmHg, DBP 10-15 mmHg vs monotherapy SBP 10-15 mmHg, DBP 8-10 mmHg)
- [x] When to consider dual therapy criteria (SBP/DBP >=20/10 above target, Grade 2+, DM/CKD)
- [x] Elderly/frail caution
- [x] Preferred combinations (ACEi/ARB + DHP CCB; ACEi/ARB + thiazide-like diuretic)
- [x] Table 4 — combinations to avoid (ACEi+ARB, BB+non-DHP CCB, BB+diuretic) with risks
- [ ] MISSING: Clinical definition that "low-dose" = "initial dose" per Supplementary Table S1. Source footnote b: "'Low-dose' is defined as 'initial dose' (see Supplementary Table S1)." This operational definition is dropped. Clinically significant — without it, "low-dose" is ambiguous.

### Accuracy: 1 issue found
- Table 4: source says "Increased risk of developing T2DM" for BB + diuretic; structured says "Increased risk of developing type 2 diabetes mellitus". Expansion of abbreviation is acceptable, not an error.
- All other content verified against raw extraction.

### Schema: 1 violation
- content_types claims [prose, drug_list, treatment_logic]. No formal drug_list or treatment_logic (IEET) block is present in this section. Table 3 is a comparison table, Table 4 is a caution table. Should be [prose] at most.

### Clinical safety: 1 flag
- **WARNING (MEDIUM):** The definition "low-dose = initial dose (see Supplementary Table S1)" is a clinically actionable clarification. Without it, a prescriber reading "initiate low-dose dual therapy" has no operationally defined dose to use. They must independently look up Table S1 and infer this mapping. The source makes this explicit; the structured output does not.

### Confidence: MEDIUM
Content accuracy is high. The missing "low-dose" definition and content_types mismatch need addressing.
