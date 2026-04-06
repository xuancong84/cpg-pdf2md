#!/bin/bash
# CPG Pipeline Orchestrator
# Usage: ./scripts/run-pipeline.sh source/guideline.pdf

set -euo pipefail

PDF="$1"
BASENAME=$(basename "$PDF" .pdf)

echo "╔══════════════════════════════════════╗"
echo "║  CPG Pipeline: $BASENAME"
echo "╚══════════════════════════════════════╝"

# Phase 1: SCAN
echo ""
echo "▸ Phase 1/5: SCAN"
claude -p "You are Agent 1 (Scanner). Read .claude/skills/scanner/SKILL.md for your instructions. Process: $PDF" \
  --allowedTools "Read,Write,Bash" --permission-mode auto

# Read the manifest to get cpg-id
CPG_ID=$(grep 'cpg_id:' output/raw/*/00-scan-manifest.yaml | head -1 | awk '{print $2}')
echo "  CPG ID: $CPG_ID"

# Phase 2: EXTRACT
echo ""
echo "▸ Phase 2/5: EXTRACT"
claude -p "You are Agent 2 (Extractor). Read .claude/skills/extractor/SKILL.md for your instructions. Process: $PDF using manifest at output/raw/$CPG_ID/00-scan-manifest.yaml" \
  --allowedTools "Read,Write,Bash" --permission-mode auto

# Phase 3: STRUCTURE
echo ""
echo "▸ Phase 3/5: STRUCTURE"
claude -p "You are Agent 3 (Structurer). Read .claude/skills/structurer/SKILL.md for your instructions. Process all files in output/raw/$CPG_ID/" \
  --allowedTools "Read,Write,Edit,Bash" --permission-mode auto

# Phase 4: CHECK (fresh context - never seen extraction)
echo ""
echo "▸ Phase 4/5: CHECK"
claude -p "You are Agent 4 (Checker). Read .claude/skills/checker/SKILL.md for your instructions. Validate output/structured/$CPG_ID/ against $PDF" \
  --allowedTools "Read,Write,Bash" --permission-mode auto

# Phase 5: RECONCILE
echo ""
echo "▸ Phase 5/5: RECONCILE"
claude -p "You are Agent 5 (Reconciler). Read .claude/skills/reconciler/SKILL.md for your instructions. Reconcile output/structured/$CPG_ID/ using reports in eval/$CPG_ID/" \
  --allowedTools "Read,Write,Edit,Bash" --permission-mode auto

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Pipeline complete for $BASENAME"
echo "║  Final output: output/final/$CPG_ID/"
echo "║  Review items: eval/$CPG_ID/reconciliation-summary.md"
echo "╚══════════════════════════════════════╝"
