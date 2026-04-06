## home-bp-monitoring Validation Report

**Overall: PASS**

### Completeness: 5/6 items present
- [x] Clinical utility list (all 8 use cases including white-coat HTN, masked HTN, HMOD monitoring)
- [x] White-coat and masked hypertension definitions integrated into bullet text
- [x] Clinic vs non-clinic BP difference explanation
- [x] Table 5 — all 4 rows, all 4 columns (clinic, HBPM/daytime ABPM, night-time ABPM, 24-hour ABPM)
- [x] Whelton et al. 2017 attribution and caution note
- [ ] MINOR: QR code reference for patient/caregiver home BP monitoring education resources dropped. Not clinical content but a patient-facing resource pointer.

### Accuracy: 0 issues found
- Table 5 values verified row by row:
  - 120/80 | 120/80 | 100/65 | 115/75 — MATCH
  - 130/80 | 130/80 | 110/65 | 125/75 — MATCH
  - 140/90 | 135/85 | 120/70 | 130/80 — MATCH
  - 160/100 | 145/90 | 140/85 | 145/90 — MATCH
- ABPM/HBPM abbreviation legend present

### Schema: 0 violations
- content_types: [prose, threshold_table] — matches actual content
- YAML frontmatter valid

### Clinical safety: 0 flags

### Confidence: HIGH
Table 5 is a critical reference table. All 16 BP values verified against source. No discrepancies.
