# CPG Section Schema

Every output markdown file MUST follow this structure.

## Required YAML frontmatter

---
cpg_id: string          # e.g., "ACE-DM-2024", "NICE-NG28-2022", "AHA-HF-2022"
cpg_name: string        # Full guideline name
publisher: string       # e.g., "MOH Singapore", "NICE", "AHA/ACC"
country: string         # ISO 3166-1 alpha-3
version: string         # Publisher's version identifier
publication_date: date  # YYYY-MM-DD
section_id: string      # Unique within guideline, e.g., "screening", "pharmacotherapy"
section_title: string   # Human-readable section name
source_pages: [int]     # Page numbers in source PDF
parent_section: string  # section_id of parent, or "root"
content_types: [string] # From: prose, decision_tree, treatment_logic, drug_list,
                        #       threshold_table, risk_score, patient_criteria,
                        #       monitoring_schedule, referral_criteria
extracted_date: date    # When this conversion was done
pipeline_version: string # Semver of the pipeline that produced this
validated: boolean      # Has a checker agent validated this?
validated_date: date    # When validation passed (null if not yet)
review_flags: [string]  # Any <!-- REVIEW --> items still open
---

## Content body rules

### Prose
Standard markdown. H2 for major subsections, H3 for detail.
No H1 (reserved for file title which comes from section_title).

### Cross-references
Link to other sections: [See Pharmacotherapy](./pharmacotherapy.md)
Link to external evidence: [UKPDS 34](https://doi.org/...)

### Inline clinical annotations
Use HTML comments for metadata that agents can parse but humans skip:
<!-- STRENGTH: strong | conditional | weak -->
<!-- EVIDENCE: high | moderate | low | very_low -->
<!-- GRADE: A | B | C | D -->
