---
cpg_id: "acg-hypertension"
cpg_name: "Hypertension – Tailoring the management plan to optimise blood pressure control"
publisher: "ACE (Agency for Care Effectiveness)"
country: "SGP"
version: "1.0"
publication_date: 2023-12-15
section_id: "lifestyle-intervention"
section_title: "Lifestyle Intervention and Initiation of Pharmacotherapy"
source_pages: [4]
parent_section: "root"
content_types: [prose, decision_tree]
extracted_date: 2026-04-06
pipeline_version: "0.1.0"
validated: true
validated_date: 2026-04-06
review_flags:
  - "G1_HIGH Mermaid node corrected from directive to conditional language per source — verify clinical intent preserved"
  - "G1_LOW 'especially if' qualifier restored — verify graded recommendation accurately represented"
---

# Lifestyle Intervention and Initiation of Pharmacotherapy

## Benefits of Lifestyle Intervention

For patients with elevated BP, lifestyle intervention includes healthy diet (e.g., reducing sodium intake and alcohol consumption), increased physical activity, weight reduction if overweight or obese, and smoking cessation. Benefits of lifestyle intervention extend across age groups and cardiovascular risk levels, and are therefore encouraged for all patients.

Studies have reported up to 17/10 mmHg BP reduction when lifestyle intervention with two or more components (e.g., healthy diet and active lifestyle) is maintained for at least four months.

A personalised approach taking into consideration factors such as comorbidities, patient's preferences, quality of life, frailty, functionality, and cognitive status will help in setting sustainable lifestyle plans.

For patients with concomitant CKD, see ACG on CKD management, as advice relating to salt and protein intake can vary.

For examples of patient resources and programmes, see High blood pressure: healthy eating guide, MOVEIT Programme.

## When to Initiate Pharmacotherapy

Pharmacotherapy complements lifestyle intervention where appropriate. The decision to initiate treatment with antihypertensive medications is guided by the patient's BP, cardiovascular risk, and presence of conditions such as CVD, CKD, DM, or HMOD.

### Figure 2: General guide to initiation of pharmacotherapy in patients with elevated BP

See [Recommendations 2 to 5](./pharmacotherapy-selection.md) for pharmacotherapy details.

```mermaid
graph TD
  ENTRY{Patient with elevated BP<br/>clinic BP ≥130/85 mmHg}

  ENTRY -->|Grade 2+<br/>≥160/100 mmHg| G2_ACT[Start or intensify pharmacotherapy<br/>regardless of CV risk<br/>and other risk factors]
  ENTRY -->|Grade 1<br/>140–159/90–99 mmHg| G1{Cardiovascular risk level?}
  ENTRY -->|High-normal<br/>130–139/85–89 mmHg| HN{Cardiovascular risk level?}

  G1 -->|High to very high<br/>CVD/CKD/DM/HMOD or<br/>SG-FRS-2023 >20%| G1_HIGH[Consider pharmacotherapy<br/>depending on CV risk and<br/>likelihood of BP control<br/>with lifestyle alone;<br/>if not started together,<br/>consider after 3–6 months<br/>if target not reached]
  G1 -->|Low to intermediate<br/>SG-FRS-2023 ≤20%| G1_LOW[Adopt lifestyle interventions<br/>Consider pharmacotherapy<br/>especially if SG-FRS 10–20%<br/>or BP not controlled<br/>after 3–6 months]

  HN -->|High to very high<br/>CVD/CKD/DM/HMOD or<br/>SG-FRS-2023 >20%| HN_HIGH[Consider pharmacotherapy<br/>especially if not controlled<br/>after 3–6 months]
  HN -->|Low to intermediate<br/>SG-FRS-2023 ≤20%| HN_LOW[No pharmacotherapy required]

  style ENTRY fill:#f9f,stroke:#333
  style G2_ACT fill:#9f9,stroke:#333
  style G1_HIGH fill:#9f9,stroke:#333
  style G1_LOW fill:#9f9,stroke:#333
  style HN_HIGH fill:#9f9,stroke:#333
  style HN_LOW fill:#9f9,stroke:#333
```

<!-- REVIEW: G1_HIGH node — source frames pharmacotherapy initiation as a conditional decision ("depends on the degree of cardiovascular risk and likelihood of achieving BP control with lifestyle intervention alone"), not a directive. Mermaid node corrected to use "Consider pharmacotherapy depending on..." but verify the condensed wording preserves full clinical intent for Grade 1 / high-risk patients. -->

<!-- REVIEW: G1_LOW node — source uses "especially if SG-FRS-2023 is between 10–20%" to signal a graduated recommendation. The "especially" qualifier has been restored but verify this graded framing is adequately conveyed in the Mermaid tree format. -->

**Note on high-normal BP:** There is limited evidence on the benefits of starting pharmacotherapy for patients with high-normal BP; consider pharmacotherapy if the patient's BP remains close to 140/90 mmHg after a period of lifestyle intervention.
