#!/usr/bin/env python3
"""Validate all output files against CPG schemas."""
import yaml, re, glob, sys, os

errors = []
warnings = []

REQUIRED_FM = [
    'cpg_id', 'cpg_name', 'publisher', 'country', 'version',
    'publication_date', 'section_id', 'section_title', 'source_pages',
    'content_types', 'extracted_date', 'pipeline_version', 'validated'
]

def check_frontmatter(filepath):
    with open(filepath) as f:
        content = f.read()
    if not content.startswith('---'):
        errors.append(f'{filepath}: missing YAML frontmatter')
        return
    parts = content.split('---', 2)
    if len(parts) < 3:
        errors.append(f'{filepath}: malformed frontmatter')
        return
    try:
        fm = yaml.safe_load(parts[1])
    except yaml.YAMLError as e:
        errors.append(f'{filepath}: invalid YAML - {e}')
        return
    for field in REQUIRED_FM:
        if field not in fm:
            errors.append(f'{filepath}: missing field "{field}"')

def check_no_ascii_art(filepath):
    with open(filepath) as f:
        content = f.read()
    box_chars = re.findall(r'[┌┐└┘├┤┬┴┼─│═║╔╗╚╝╠╣╦╩╬]', content)
    if box_chars:
        errors.append(f'{filepath}: contains {len(box_chars)} ASCII box-drawing characters')

def check_mermaid(filepath):
    with open(filepath) as f:
        content = f.read()
    blocks = re.findall(r'```mermaid\n(.*?)\n```', content, re.DOTALL)
    for i, block in enumerate(blocks):
        if not re.match(r'\s*(graph|flowchart)\s+(TD|TB|LR|RL|BT)', block):
            errors.append(f'{filepath}: mermaid block {i} missing graph direction')
        # Check for dead-end nodes (nodes that appear only as targets, never as sources)
        sources = set(re.findall(r'(\w+)\s*-->',  block))
        targets = set(re.findall(r'-->\s*\|?[^|]*\|?\s*(\w+)', block))
        # Entry node won't be a target, leaf nodes won't be sources - that's fine
        # But nodes that are neither source nor target are suspicious
        all_nodes = sources | targets
        if not all_nodes:
            warnings.append(f'{filepath}: mermaid block {i} has no edges')

def check_review_flags(filepath):
    with open(filepath) as f:
        content = f.read()
    flags = re.findall(r'<!-- REVIEW:.*?-->', content)
    if flags:
        for flag in flags:
            warnings.append(f'{filepath}: open review flag - {flag[:80]}')

# Run on all final output
for md_file in sorted(glob.glob('output/final/**/*.md', recursive=True)):
    if os.path.basename(md_file) == '_index.md':
        continue  # index files have different schema
    check_frontmatter(md_file)
    check_no_ascii_art(md_file)
    check_mermaid(md_file)
    check_review_flags(md_file)

# Also run on structured (pre-reconciliation)
for md_file in sorted(glob.glob('output/structured/**/*.md', recursive=True)):
    if os.path.basename(md_file) == '_index.md':
        continue
    check_no_ascii_art(md_file)
    check_mermaid(md_file)

print(f'\n=== Validation Results ===')
print(f'Errors:   {len(errors)}')
print(f'Warnings: {len(warnings)}')

if errors:
    print('\nERRORS:')
    for e in errors:
        print(f'  ✗ {e}')

if warnings:
    print('\nWARNINGS:')
    for w in warnings:
        print(f'  ⚠ {w}')

sys.exit(1 if errors else 0)
