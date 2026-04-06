## Reconciliation Summary: ACG Hypertension

**Date:** 2026-04-06
**Sections processed:** 12
**Sections passed:** 12
**Sections need clinical review:** 3 (lifestyle-intervention, treatment-intensification, pharmacotherapy-selection)
**Sections blocked:** 0

### Changes made

- **lifestyle-intervention**: Corrected G2_ACT Mermaid node — restored "and other risk factors" qualifier dropped from source (checker: accuracy issue 2)
- **lifestyle-intervention**: Corrected G1_HIGH Mermaid node — changed directive "Start pharmacotherapy" to conditional "Consider pharmacotherapy depending on CV risk and likelihood of BP control with lifestyle alone" to match source language (checker: accuracy issue 1, clinical safety HIGH)
- **lifestyle-intervention**: Corrected G1_LOW Mermaid node — restored "especially if" qualifier for SG-FRS 10–20% to preserve graduated recommendation (checker: accuracy issue 3, clinical safety MEDIUM)
- **lifestyle-intervention**: Added patient education resources reference ("High blood pressure: healthy eating guide, MOVEIT Programme") from source (checker: completeness gap)
- **pharmacotherapy-selection**: Fixed content_types from [prose, drug_list] to [prose] — Table 2 is embedded prose, not a formal drug_list schema element (checker: schema violation)
- **combination-therapy**: Added missing "low-dose = initial dose (see Supplementary Table S1)" definition as a Note block after Recommendation 4 (checker: completeness gap, clinical safety MEDIUM)
- **combination-therapy**: Fixed content_types from [prose, drug_list, treatment_logic] to [prose] — no formal drug_list or IEET block present (checker: schema violation)
- **treatment-intensification**: Restructured IEET intensification options from false If/Elif/Else priority cascade to co-equal list with stated preference for adding at low dose, matching source intent (checker: accuracy issue, clinical safety MEDIUM)
- **treatment-intensification**: Added missing dual-therapy adherence counseling point from source sidebar: "if a decision is made to initially prescribe two low-dose antihypertensives together, emphasise why it is important that both are taken consistently" (checker: completeness gap)
- **supplementary-medications**: Moved CCBs (dihydropyridine + non-dihydropyridine) and Diuretics (thiazide/thiazide-like) from supplementary-combinations.md into this file — these are Table S1 individual agents, not Table S2 single-pill combinations (checker: structural misattribution, clinical safety MEDIUM)
- **supplementary-medications**: Updated source_pages from [10] to [10, 11] to reflect Table S1 spanning both pages
- **supplementary-medications**: Added clinical footnotes from source: "Maximum dosage may be lower for elderly", subsidy list note, "use not recommended" definition (checker: completeness gap, clinical safety LOW)
- **supplementary-combinations**: Removed misplaced CCB and Diuretic individual agent sections (moved to supplementary-medications)
- **supplementary-combinations**: Added source footnotes about subsidy list indicators (checker: completeness gap)
- **diagnosis-and-risk**: Fixed content_types from [prose, patient_criteria] to [prose] — BP classification criteria are embedded in prose, not structured patient_criteria format (checker: schema violation)
- **management-targets**: Fixed content_types from [prose, threshold_table, risk_score] to [prose, threshold_table] — SG-FRS-2023 is referenced, not defined in this section (checker: schema violation)
- **All sections**: Updated YAML frontmatter — validated: true, validated_date: 2026-04-06

### Open review items

- **lifestyle-intervention**: <!-- REVIEW: G1_HIGH node — source frames pharmacotherapy initiation as conditional decision, not directive. Mermaid node corrected but verify condensed wording preserves full clinical intent for Grade 1 / high-risk patients. -->
- **lifestyle-intervention**: <!-- REVIEW: G1_LOW node — "especially if" qualifier restored for SG-FRS 10–20%. Verify graded recommendation adequately conveyed in Mermaid tree format. -->
- **treatment-intensification**: <!-- REVIEW: IEET intensification options restructured from false cascade to co-equal list. Source presents adding at low dose as encouraged but not mandated. Verify revised format preserves clinical intent. -->
- **pharmacotherapy-selection**: <!-- REVIEW: Scan manifest flags decision_tree content type for page 5 but raw extraction contains no flowchart. Verify against source PDF whether a first-line selection decision tree exists. -->
