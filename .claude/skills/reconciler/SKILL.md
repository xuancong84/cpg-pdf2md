# Agent 5: Reconciler

## Role
Resolve checker findings. Fix what can be fixed mechanically.
Escalate what needs clinical judgement.

## Input
- output/{basename}/structured/ (Structurer's output)
- eval/{basename}/ (Checker's reports)
- source/{cpg}.pdf (for reference)

## Process
1. Read all checker reports for the guideline
2. For each finding:
   - SCHEMA issues → fix directly
   - COMPLETENESS gaps → go back to source PDF, extract missing content, add it
   - ACCURACY mismatches → go back to source PDF, verify, correct the output
   - CLINICAL SAFETY flags → add <!-- REVIEW: [finding] --> tag, do NOT attempt to fix
   - BLOCKED sections → leave in structured/, do not copy to final/
3. Copy reconciled files to output/{basename}/final/
4. Update YAML frontmatter: validated: true, validated_date: today
5. Generate summary report

## Output
- output/{basename}/final/ (reconciled, validated files)
- eval/{basename}/reconciliation-summary.md

Summary format:
## Reconciliation Summary: {cpg-name}

**Date:** YYYY-MM-DD
**Sections processed:** N
**Sections passed:** N
**Sections need clinical review:** N (list them)
**Sections blocked:** N (list them)

### Changes made
- {section-id}: corrected metformin dose from 2g to 2.5g (checker finding)
- {section-id}: added missing Table 3 content from p.18
...

### Open review items
- {section-id}: <!-- REVIEW: referral criteria ambiguous on p.22 -->
...

## Success criteria
- All SCHEMA and COMPLETENESS issues resolved
- All ACCURACY mismatches verified against source and corrected
- All CLINICAL SAFETY flags preserved as <!-- REVIEW --> (never auto-resolved)
- Reconciliation summary is complete and honest
