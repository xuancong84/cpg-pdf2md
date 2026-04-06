## diagnosis-and-risk Validation Report

**Overall: PASS**

### Completeness: 9/9 items present
- [x] BP classification definitions (high-normal >=130-139/85-89 mmHg; Grade 1+ >=140/90 mmHg)
- [x] Scope statement: applies to clinic BP >=130/85 mmHg
- [x] Recommendation 1 text and strength annotation
- [x] CVD risk factors (atherosclerotic CVD, DM, CKD)
- [x] HMOD definition and examples (LVH, albuminuria, hypertensive retinopathy)
- [x] SG-FRS-2023 risk calculator reference
- [x] Additional factors (asthma/COPD, gout, pregnancy, frailty, etc.)
- [x] Clinic vs non-clinic BP sidebar (140/90 mmHg ~ 135/85 mmHg)
- [x] Comorbidity ACG cross-references (lipid, T2DM, CKD diagnosis, CKD management)

### Accuracy: 0 issues found
- BP thresholds match source exactly
- HMOD definition matches source
- Cross-references to other sections correctly linked

### Schema: 1 violation
- content_types claims [prose, patient_criteria] but no structured `patient_criteria` format exists in the output. The patient criteria are embedded in prose. Scan manifest lists [prose, table, sidebar, figure] for this page. Should be [prose] or at most [prose, patient_criteria] if the BP classification list counts. Minor.

### Clinical safety: 0 flags

### Confidence: HIGH
All clinical thresholds and definitions verified against source. No numerical mismatches.
