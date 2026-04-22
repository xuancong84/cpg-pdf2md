#!/bin/bash
# CPG Pipeline Orchestrator
# Usage: ./scripts/run-pipeline.sh source/guideline.pdf

set -euo pipefail

PDF="$1"
BASENAME=$(basename "$PDF" .pdf)
TOOLS=Read,Write,Edit,Glob,Grep,Bash,WebSearch,WebFetch

if [ `find output/$BASENAME -iname '*' -type f 2>/dev/null | wc -l` != 0 ] || [ `find eval/$BASENAME -iname '*' -type f 2>/dev/null | wc -l` != 0 ]; then
	read -p "Output folder ./output/$BASENAME or eval folder ./eval/$BASENAME is not empty and will be deleted. Are you sure to continue? (y/n): " confirm
	if [[ "$confirm" == [Yy]* ]]; then
	    rm -rfv output/$BASENAME eval/$BASENAME
	else
	    echo "Aborted"
		exit
	fi
fi
mkdir -p output/$BASENAME eval/$BASENAME

echo "╔══════════════════════════════════════╗"
echo "║  CPG Pipeline: $BASENAME"
echo "╚══════════════════════════════════════╝"

# Phase 1: SCAN
echo ""
echo "▸ Phase 1/6: SCAN"
claude -p "You are Agent 1 (Scanner). Read .claude/skills/scanner/SKILL.md for your instructions. Process: $PDF. Output basename: $BASENAME" \
  --allowedTools "Read,Write,Bash" --permission-mode auto
echo "  Basename: $BASENAME"

if [ ! -s output/$BASENAME/raw/00-scan-manifest.yaml ]; then
	echo "Phase 1 failed: output/$BASENAME/raw/00-scan-manifest.yaml not found."
	exit 1
fi

# Phase 2: EXTRACT
echo ""
echo "▸ Phase 2/6: EXTRACT"
claude -p "You are Agent 2 (Extractor). Read .claude/skills/extractor/SKILL.md for your instructions. Process: $PDF using manifest at output/$BASENAME/raw/00-scan-manifest.yaml. Output basename: $BASENAME" \
  --allowedTools "Read,Write,Bash" --permission-mode auto

# Phase 3: STRUCTURE
echo ""
echo "▸ Phase 3/6: STRUCTURE"
claude -p "You are Agent 3 (Structurer). Read .claude/skills/structurer/SKILL.md for your instructions. Process all files in output/$BASENAME/raw/. Output basename: $BASENAME" \
  --allowedTools "Read,Write,Edit,Bash" --permission-mode auto

# Phase 4: CHECK (fresh context - never seen extraction)
echo ""
echo "▸ Phase 4/6: CHECK"
claude -p "You are Agent 4 (Checker). Read .claude/skills/checker/SKILL.md for your instructions. Validate output/$BASENAME/structured/ against $PDF. Output basename: $BASENAME" \
  --allowedTools "Read,Write,Bash" --permission-mode auto

# Phase 5: RECONCILE
echo ""
echo "▸ Phase 5/6: RECONCILE"
claude -p "You are Agent 5 (Reconciler). Read .claude/skills/reconciler/SKILL.md for your instructions. Reconcile output/$BASENAME/structured/ using reports in eval/$BASENAME/. Output basename: $BASENAME" \
  --allowedTools "Read,Write,Edit,Bash" --permission-mode auto

# Phase 6: COMBINE
echo ""
echo "▸ Phase 6/6: COMBINE"
claude -p "You are Agent 6 (Combiner). Read .claude/skills/combiner/SKILL.md for your instructions. Combine all reconciled files in output/$BASENAME/final/ into a single markdown document, using output/$BASENAME/raw/00-scan-manifest.yaml for section ordering and hierarchy. Output basename: $BASENAME" \
  --allowedTools "Read,Write,Bash" --permission-mode auto


echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Pipeline complete for $BASENAME"
echo "║  Final output:    output/$BASENAME/final/"
echo "║  Combined output: output/$BASENAME/combined/$BASENAME.md"
echo "║  Review items:    eval/$BASENAME/reconciliation-summary.md"
echo "╚══════════════════════════════════════╝"
