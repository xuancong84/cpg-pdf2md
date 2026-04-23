#!/usr/bin/env bash
# CPG Pipeline Orchestrator with multi-run pairwise reconciliation
#
# Usage:
#   ./scripts/run-pipeline.sh source/guideline.pdf [N]
#
# Example:
#   ./scripts/run-pipeline.sh source/guideline.pdf
#   ./scripts/run-pipeline.sh source/guideline.pdf 6

set -euo pipefail
shopt -s nullglob

usage() {
  echo "Usage: $0 source/guideline.pdf [N=4]" >&2
  exit 1
}

PDF="${1:-}"
RUN_COUNT="${2:-4}"

[[ -n "$PDF" ]] || usage
[[ -f "$PDF" ]] || { echo "PDF not found: $PDF" >&2; exit 1; }
[[ "$RUN_COUNT" =~ ^[1-9][0-9]*$ ]] || { echo "N must be a positive integer" >&2; exit 1; }

ROOT_BASENAME="$(basename "$PDF" .pdf)"

# Reconciliation locations
RECON_DIR="output/$ROOT_BASENAME/reconciled"
RECON_EVAL_DIR="eval/$ROOT_BASENAME"
CANDIDATE_DIR="$RECON_DIR/candidates"
ACC_DIR="$RECON_DIR/accumulator"
STEP_DIR="$RECON_DIR/steps"
MAX_RETRIES=3
RETRY_SLEEP_SECONDS=2

run_claude_with_retry() {
  local prompt="$1"
  local tools="$2"
  local attempt=1

  while (( attempt <= MAX_RETRIES )); do
    if claude -p "$prompt" \
      --allowedTools "$tools" \
      --permission-mode auto; then
      return 0
    fi

    if (( attempt == MAX_RETRIES )); then
      echo "Claude failed after $MAX_RETRIES consecutive attempts." >&2
      return 1
    fi

    echo "Claude call failed (attempt $attempt/$MAX_RETRIES). Retrying..." >&2
    sleep "$RETRY_SLEEP_SECONDS"
    ((attempt++))
  done
}

dir_nonempty() {
  local path="$1"
  [[ -d "$path" ]] && find "$path" -mindepth 1 -print -quit | grep -q .
}

run_phase() {
  local label="$1"
  local prompt="$2"
  local tools="$3"

  echo ""
  echo "▸ $label"
  run_claude_with_retry "$prompt" "$tools"
}

run_once() {
  local i="$1"
  local run_tag
  local run_basename
  local combined_md

  run_tag="$(printf 'run%02d' "$i")"
  run_basename="${ROOT_BASENAME}__${run_tag}"

  mkdir -p "output/$run_basename" "eval/$run_basename"

  echo ""
  echo "╔══════════════════════════════════════╗"
  echo "║  CPG Pipeline: $run_basename"
  echo "╚══════════════════════════════════════╝"

  # Phase 1: SCAN
  run_phase \
    "Phase 1/6 (Run $i/$RUN_COUNT): SCAN" \
    "You are Agent 1 (Scanner). Read .claude/skills/scanner/SKILL.md for your instructions. Process: $PDF. Output basename: $run_basename" \
    "Read,Write,Bash"

  if [[ ! -s "output/$run_basename/raw/00-scan-manifest.yaml" ]]; then
    echo "Phase 1 failed for $run_basename: output/$run_basename/raw/00-scan-manifest.yaml not found." >&2
    exit 1
  fi

  # Phase 2: EXTRACT
  run_phase \
    "Phase 2/6 (Run $i/$RUN_COUNT): EXTRACT" \
    "You are Agent 2 (Extractor). Read .claude/skills/extractor/SKILL.md for your instructions. Process: $PDF using manifest at output/$run_basename/raw/00-scan-manifest.yaml. Output basename: $run_basename" \
    "Read,Write,Bash"

  # Phase 3: STRUCTURE
  run_phase \
    "Phase 3/6 (Run $i/$RUN_COUNT): STRUCTURE" \
    "You are Agent 3 (Structurer). Read .claude/skills/structurer/SKILL.md for your instructions. Process all files in output/$run_basename/raw/. Output basename: $run_basename" \
    "Read,Write,Edit,Bash"

  # Phase 4: CHECK
  run_phase \
    "Phase 4/6 (Run $i/$RUN_COUNT): CHECK" \
    "You are Agent 4 (Checker). Read .claude/skills/checker/SKILL.md for your instructions. Validate output/$run_basename/structured/ against $PDF. Output basename: $run_basename" \
    "Read,Write,Bash"

  # Phase 5: RECTIFY
  run_phase \
    "Phase 5/6 (Run $i/$RUN_COUNT): RECTIFY" \
    "You are Agent 5 (Rectifier). Read .claude/skills/rectifier/SKILL.md for your instructions. Rectify output/$run_basename/structured/ using reports in eval/$run_basename/. Output basename: $run_basename" \
    "Read,Write,Edit,Bash"

  # Phase 6: COMBINE
  run_phase \
    "Phase 6/6 (Run $i/$RUN_COUNT): COMBINE" \
    "You are Agent 6 (Combiner). Read .claude/skills/combiner/SKILL.md for your instructions. Combine all rectified files in output/$run_basename/final/ into a single markdown document, using output/$run_basename/raw/00-scan-manifest.yaml for section ordering and hierarchy. Output basename: $run_basename" \
    "Read,Write,Bash"

  combined_md="output/$run_basename/combined/$run_basename.md"
  if [[ ! -s "$combined_md" ]]; then
    echo "Phase 6 failed for $run_basename: $combined_md not found." >&2
    exit 1
  fi

  cp "$combined_md" "$CANDIDATE_DIR/${run_tag}.md"

  echo ""
  echo "╔══════════════════════════════════════╗"
  echo "║  Pipeline complete for $run_basename"
  echo "║  Final output:    output/$run_basename/final/"
  echo "║  Combined output: $combined_md"
  echo "║  Review items:    eval/$run_basename/rectification-summary.md"
  echo "╚══════════════════════════════════════╝"
}

reconcile_pairwise() {
  local first_run_tag="run01"

  mkdir -p "$ACC_DIR" "$STEP_DIR" "$RECON_EVAL_DIR"

  if [[ ! -s "$CANDIDATE_DIR/${first_run_tag}.md" ]]; then
    echo "Reconciliation failed: missing first candidate $CANDIDATE_DIR/${first_run_tag}.md" >&2
    exit 1
  fi

  cp "$CANDIDATE_DIR/${first_run_tag}.md" "$ACC_DIR/current.md"

  cat > "$ACC_DIR/state.yaml" <<EOF
source_pdf: "$PDF"
root_basename: "$ROOT_BASENAME"
processed_candidates: 1
current_canonical: "$first_run_tag"
decisions: []
EOF

  if [[ "$RUN_COUNT" -eq 1 ]]; then
    cp "$ACC_DIR/current.md" "$RECON_DIR/$ROOT_BASENAME.md"
    cat > "$RECON_EVAL_DIR/reconciliation-summary.md" <<EOF
# Reconciliation summary

- Source PDF: \`$PDF\`
- Total candidates processed: 1
- No pairwise reconciliation was needed because only one run was requested.
- Final output copied from \`$first_run_tag\`.
EOF
    return
  fi

  local i
  for ((i = 2; i <= RUN_COUNT; i++)); do
    local run_tag
    local step_tag
    local current_md
    local current_state
    local next_md
    local updated_md
    local updated_state
    local step_log
    local recon_prompt

    run_tag="$(printf 'run%02d' "$i")"
    step_tag="$(printf 'step%02d' "$((i-1))")"

    current_md="$ACC_DIR/current.md"
    current_state="$ACC_DIR/state.yaml"
    next_md="$CANDIDATE_DIR/${run_tag}.md"

    updated_md="$ACC_DIR/current.next.md"
    updated_state="$ACC_DIR/state.next.yaml"
    step_log="$RECON_EVAL_DIR/reconciliation-${step_tag}.md"

    if [[ ! -s "$next_md" ]]; then
      echo "Reconciliation failed: missing candidate $next_md" >&2
      exit 1
    fi

    echo ""
    echo "▸ Phase 7/7: RECONCILE $run_tag into accumulator"

    run_claude_with_retry \
      "You are Agent 7 (Pairwise Reconciler). Read .claude/skills/reconciler/SKILL.md for your instructions. Inputs: source PDF=$PDF, accumulator=$current_md, state=$current_state, candidate=$next_md. Outputs: updated accumulator=$updated_md, updated state=$updated_state, step log=$step_log" \
      "Read,Write,Edit,Bash"

    [[ -s "$updated_md" ]] || { echo "Pairwise reconciliation failed: $updated_md not found." >&2; exit 1; }
    [[ -s "$updated_state" ]] || { echo "Pairwise reconciliation failed: $updated_state not found." >&2; exit 1; }
    [[ -s "$step_log" ]] || { echo "Pairwise reconciliation failed: $step_log not found." >&2; exit 1; }

    mv "$updated_md" "$ACC_DIR/current.md"
    mv "$updated_state" "$ACC_DIR/state.yaml"

    cp "$ACC_DIR/current.md" "$STEP_DIR/${step_tag}-canonical.md"
    cp "$ACC_DIR/state.yaml" "$STEP_DIR/${step_tag}-state.yaml"
  done

  cp "$ACC_DIR/current.md" "$RECON_DIR/$ROOT_BASENAME.md"

  {
    echo "# Reconciliation summary"
    echo ""
    echo "- Source PDF: \`$PDF\`"
    echo "- Total candidates processed: $RUN_COUNT"
    echo ""
    for f in "$RECON_EVAL_DIR"/reconciliation-step*.md; do
      echo "---"
      echo ""
      cat "$f"
      echo ""
    done
  } > "$RECON_EVAL_DIR/reconciliation-summary.md"

  if [[ ! -s "$RECON_DIR/$ROOT_BASENAME.md" ]]; then
    echo "Reconciliation failed: $RECON_DIR/$ROOT_BASENAME.md not found." >&2
    exit 1
  fi
}

# Build list of paths that may need cleanup.
declare -a CLEANUP_PATHS=()

for ((i = 1; i <= RUN_COUNT; i++)); do
  run_tag="$(printf 'run%02d' "$i")"
  CLEANUP_PATHS+=("output/${ROOT_BASENAME}__${run_tag}")
  CLEANUP_PATHS+=("eval/${ROOT_BASENAME}__${run_tag}")
done

CLEANUP_PATHS+=("$RECON_DIR")
CLEANUP_PATHS+=("$RECON_EVAL_DIR")

needs_cleanup=false
for path in "${CLEANUP_PATHS[@]}"; do
  if dir_nonempty "$path"; then
    needs_cleanup=true
    break
  fi
done

if [[ "$needs_cleanup" == true ]]; then
  echo "The following locations are not empty and will be deleted:"
  for path in "${CLEANUP_PATHS[@]}"; do
    if dir_nonempty "$path"; then
      echo "  - $path"
    fi
  done

  read -r -p "Are you sure you want to continue? (y/n): " confirm
  if [[ ! "$confirm" =~ ^[Yy] ]]; then
    echo "Aborted"
    exit 0
  fi

  rm -rf -- "${CLEANUP_PATHS[@]}"
fi

mkdir -p "$CANDIDATE_DIR" "$RECON_EVAL_DIR"

echo "╔══════════════════════════════════════╗"
echo "║  Multi-run CPG Pipeline: $ROOT_BASENAME"
echo "║  Runs: $RUN_COUNT"
echo "╚══════════════════════════════════════╝"

# Run the full pipeline N times.
for ((i = 1; i <= RUN_COUNT; i++)); do
  run_once "$i"
done

# Pairwise reconciliation over the N combined markdowns.
reconcile_pairwise

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Multi-run pipeline complete"
echo "║  Source PDF:       $PDF"
echo "║  Runs completed:   $RUN_COUNT"
echo "║  Candidates:       $CANDIDATE_DIR/"
echo "║  Reconciled file:  $RECON_DIR/$ROOT_BASENAME.md"
echo "║  Decision log:     $RECON_EVAL_DIR/reconciliation-summary.md"
echo "╚══════════════════════════════════════╝"
