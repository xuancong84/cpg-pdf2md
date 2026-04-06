## treatment-intensification Validation Report

**Overall: NEEDS REVIEW**

### Completeness: 6/7 items present
- [x] Recommendation 5 text with strength annotation (strong)
- [x] Three intensification options (increase dose, add class, switch class)
- [x] Timeline: half maximal effect within 1 week, full effect within 4 weeks
- [x] ~3 months suggested timeframe for intensification
- [x] Modifiable factors checklist (adherence, salt, secondary HTN, volume overload, comorbidities)
- [x] Adherence strategies (once-daily dosing, single-pill combinations, pill boxes/apps, timing flexibility, night-time dosing)
- [ ] MISSING: Specific counseling point from source sidebar — "if a decision is made to initially prescribe two low-dose antihypertensives together, emphasise why it is important that both are taken consistently, i.e. to maximise BP control while reducing the risk of adverse effects (compared with high-dose monotherapy)." This dual-therapy adherence rationale is clinically specific and dropped.

### Accuracy: 1 issue found

**ISSUE — IEET tree imposes false priority ordering on intensification options**
- SOURCE: "treatment could be intensified by increasing dosage of current medication, adding a different antihypertensive class, or switching to a different medication class" — presented as co-equal alternatives with a stated preference for adding at low dose.
- STRUCTURED (IEET):
  ```
  If [additional BP-lowering needed]: Add different antihypertensive class at low dose
  Elif [current medication not suitable]: Switch to different medication class
  Else: Increase dosage of current medication
  ```
- The If/Elif/Else structure implies: try adding first, only switch if current medication is unsuitable, and only increase dose as a last resort. The source does not define this strict cascade — it says adding is "encouraged where possible" but lists dose increase first. The IEET tree inverts the order and adds conditions ("current medication not suitable") that are not in the source.

### Schema: 0 violations
- YAML frontmatter valid
- IEET format properly indented with explicit conditions at each branch
- content_types: [prose, treatment_logic] — matches actual content

### Clinical safety: 1 flag
- **WARNING (MEDIUM):** The IEET cascade could be read as "never increase dosage if adding another drug is possible." The source's intent is to encourage adding low-dose second agents but explicitly lists all three as valid options depending on clinical context. The forced hierarchy could influence prescribing behavior away from dose uptitration.

### Confidence: MEDIUM
The IEET is a reasonable interpretation but introduces priority ordering not present in the source. The clinical effect is moderate — adding low-dose agents IS encouraged in the source, so the IEET's bias aligns with the source's preference, but the rigid structure overstates it.
