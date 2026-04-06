## lifestyle-intervention Validation Report

**Overall: NEEDS REVIEW**

### Completeness: 5/7 items present
- [x] Benefits of lifestyle intervention (diet, physical activity, weight reduction, smoking cessation)
- [x] 17/10 mmHg reduction with 2+ components over 4 months
- [x] CKD cross-reference for salt/protein advice
- [x] Figure 2 decision flowchart converted to Mermaid graph TD
- [x] High-normal BP note about limited evidence
- [ ] MISSING: Patient education resources — source references "High blood pressure: healthy eating guide, MOVEIT Programme" as patient resources. These are dropped entirely from the structured output.
- [ ] MISSING: Personalised approach paragraph partially truncated — source mentions "quality of life, functionality, and cognitive status" in the personalisation context, which is captured. OK on re-check.

### Accuracy: 3 issues found

**ISSUE 1 — CLINICAL: Grade 1 / High-risk Mermaid node oversimplifies source**
- SOURCE (raw): "The decision to start pharmacotherapy depends on the degree of cardiovascular risk and likelihood of achieving BP control with lifestyle intervention alone. If not started together with lifestyle intervention, consider pharmacotherapy if the patient does not reach target BP after 3 to 6 months of lifestyle intervention."
- STRUCTURED (Mermaid G1_HIGH): "Start pharmacotherapy with lifestyle intervention, or consider after 3–6 months if target not reached"
- The source describes a **conditional decision** ("depends on...likelihood of achieving BP control with lifestyle intervention alone"). The Mermaid version converts this to a **directive** ("Start pharmacotherapy"). This changes the clinical intent from deliberation to action.

**ISSUE 2 — Grade 2+ Mermaid node truncates qualifier**
- SOURCE: "regardless of cardiovascular risk and presence of other risk factors"
- STRUCTURED: "regardless of CV risk"
- Drops "and presence of other risk factors". While "other risk factors" is arguably subsumed by CV risk assessment, the source explicitly includes this broader scope.

**ISSUE 3 — Grade 1 / Low-risk "especially if" weakened**
- SOURCE: "Consider pharmacotherapy, **especially if** SG-FRS-2023 is between 10–20%"
- STRUCTURED (Mermaid G1_LOW): "Consider pharmacotherapy if SG-FRS 10–20% or BP not controlled after 3–6 months"
- The word "especially" is dropped. In the source, this signals a graduated recommendation; its omission in the Mermaid tree makes the criterion appear binary rather than graded.

### Schema: 0 violations
- YAML frontmatter valid
- Mermaid uses `graph TD` as required
- All paths reach terminal (green-styled) nodes
- content_types: [prose, decision_tree] — matches actual content

### Clinical safety: 2 flags
- **WARNING (HIGH):** G1_HIGH Mermaid node misrepresents the source as a directive to "Start pharmacotherapy" when the source frames it as a conditional decision. A clinician reading only the Mermaid tree could initiate pharmacotherapy more aggressively than the source intends.
- **WARNING (MEDIUM):** Loss of "especially" qualifier for SG-FRS 10-20% in G1_LOW could lead to pharmacotherapy being considered with equal weight for all Grade 1/low-risk patients, rather than preferentially for those with intermediate (10-20%) risk scores.

### Confidence: MEDIUM
The Mermaid tree captures the overall routing structure correctly but introduces directional bias in 2 of 5 terminal nodes. The clinical meaning shifts from "consider/depends on" to "start". This needs reconciliation before clinical use.
