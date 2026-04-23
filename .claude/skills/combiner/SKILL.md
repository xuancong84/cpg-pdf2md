# Agent 6: Combiner

## Role
Merge all rectified, validated section files from `output/{basename}/final/` into a
single hierarchically-structured markdown document. You combine — you do NOT edit,
re-interpret, or add any clinical content.

## Input
- `output/{basename}/final/` — the rectified section files produced by the Rectifier
- `output/{basename}/raw/00-scan-manifest.yaml` — section ordering and hierarchy
- `output/{basename}/final/_index.md` (if present) — section listing with ordering hints

## Process

### 1. Determine section order
Read `00-scan-manifest.yaml` to get the canonical section order (as sequenced in the
source PDF).  If a section file exists in `final/` but is absent from the manifest,
append it at the end, alphabetically, after a `## Unlisted Sections` heading.

### 2. Build the document hierarchy
Use the `parent_section` field from each file's YAML frontmatter to reconstruct the
hierarchy:
- `parent_section: root` → top-level section → `#` heading (H1)
- `parent_section: <other-id>` → child section → `##` heading (H2)
- Deeper nesting → `###`, `####`, … (H3, H4, …) accordingly

The heading text is the `section_title` value from the frontmatter.

### 3. Strip frontmatter, promote headings
For each section file:
1. Remove the YAML frontmatter block (`---` … `---`)
2. Add the section heading derived from step 2 above the body
3. Shift all internal headings down by the section's depth level so that internal
   H2 headings in a top-level section become H2, but internal H2 headings inside a
   child section become H3, and so on.  Never produce an H1 inside the body.
4. If the file contains `<!-- REVIEW: … -->` comments, preserve them exactly.

### 4. Insert section separators
Between sections at the same depth level, insert a horizontal rule (`---`) to
improve readability.

### 5. Build a table of contents
At the top of the combined file, after the document-level H1, insert a collapsible
table of contents:

```markdown
<details>
<summary>Table of Contents</summary>

- [Section Title](#anchor)
  - [Child Section](#anchor)
    - [Grandchild Section](#anchor)
- [Next Top-level Section](#anchor)

</details>
```

Anchors must be lowercase, spaces replaced with hyphens, punctuation stripped
(standard GitHub-flavoured Markdown anchor rules).

### 6. Write the combined file
Write the complete document to:

```
output/{basename}/combined/{basename}.md
```

### 7. Write a combine manifest
Write a brief manifest recording what was combined:

```
output/{basename}/combined/00-manifest.yaml
```

Format:
```yaml
cpg_id: {basename}
combined_date: YYYY-MM-DD
sections_included: N
sections_excluded: []   # list any final/ files deliberately skipped (e.g. _index.md)
review_flags_present: true/false
source_files:
  - section_id: introduction
    file: output/{basename}/final/introduction.md
    depth: 1
  - section_id: pharmacotherapy
    file: output/{basename}/final/pharmacotherapy.md
    depth: 1
  - section_id: first-line-agents
    file: output/{basename}/final/first-line-agents.md
    depth: 2       # child of pharmacotherapy
```

## Output
- `output/{basename}/combined/{basename}.md` — the single combined markdown document
- `output/{basename}/combined/00-manifest.yaml` — processing manifest

## Success criteria
- Every `.md` file in `final/` (except `_index.md`) is present in the combined document
- Section order matches the manifest / source PDF sequence
- Heading hierarchy correctly reflects `parent_section` nesting
- No YAML frontmatter leaks into the body
- No clinical content is added, removed, or rephrased
- All `<!-- REVIEW: … -->` flags are preserved verbatim
- Table of contents links resolve to real headings in the document
- `00-manifest.yaml` is complete and accurate
