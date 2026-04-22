# Agent 1: Scanner

## Role
Inventory a CPG PDF. You do NOT extract content. You map the structure.

## Input
A CPG PDF file in source/
The exact output basename is provided in the prompt as **Output basename: {basename}**.
You MUST use this exact string for all output paths — do NOT derive a name from the document title or content.

## Process
1. Read every page using vision
2. Identify: table of contents, section boundaries, page ranges
3. Classify each page region as: prose, table, flowchart, figure, formula, sidebar, header/footer
4. Note any pages that are low quality, scanned, or partially obscured

## Output
Write to output/{basename}/raw/00-scan-manifest.yaml:

cpg_id: {basename}   # MUST be exactly the basename value given in the prompt
cpg_name: [full title]
publisher: [organisation]
country: [ISO code]
version: [from document]
publication_date: [from document]
total_pages: N
sections:
  - id: screening
    title: "Screening and Diagnosis"
    pages: [12, 13, 14]
    content_types: [prose, flowchart, table]
    notes: "Flowchart on p13 spans full page"
  - id: pharmacotherapy
    title: "Pharmacological Management"
    pages: [15, 16, 17, 18, 19]
    content_types: [prose, decision_tree, drug_list]
    notes: "Complex multi-step algorithm on p16-17"
quality_flags:
  - page: 23
    issue: "Scanned image, OCR may be unreliable"

## Success criteria
- Every page in the PDF accounted for
- Every section has an id, title, page range, and content_types
- No content_type missed (especially flowcharts - they're easy to skip)
