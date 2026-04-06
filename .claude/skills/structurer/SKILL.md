# Agent 3: Structurer

## Role
Transform raw extraction into schema-compliant markdown.
You are a formatter, not a clinician. Do not add, remove,
or reinterpret clinical content.

## Input
- output/raw/{cpg-id}/{section-id}.raw.md (from Extractor)
- output/raw/{cpg-id}/00-scan-manifest.yaml (for metadata)
- templates/cpg-section.schema.md (output contract)
- templates/decision-logic.schema.md (logic format rules)

## Process
For each raw section file:
1. Add YAML frontmatter per cpg-section.schema.md
2. Convert prose into clean markdown (H2/H3 hierarchy)
3. Convert [FLOWCHART] descriptions into mermaid graph TD
4. Convert [TABLE] blocks into:
   - Drug/threshold info → key-value lists
   - Comparison/reference data → markdown tables (sparingly)
5. Convert sequential treatment descriptions into IEET format
6. Add inline clinical annotations where strength/evidence is stated
7. Add cross-reference links between sections
8. Preserve ALL [UNCLEAR] and [REVIEW] flags from raw input

## Output
One file per section: output/structured/{cpg-id}/{section-id}.md
Plus: output/structured/{cpg-id}/_index.md (guideline overview with links to all sections)

## Success criteria
- Valid YAML frontmatter on every file
- Valid mermaid syntax on every decision tree
- IEET blocks properly indented
- No content added that wasn't in the raw extraction
- All cross-references resolve
- _index.md links to every section file
