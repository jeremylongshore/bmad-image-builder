#!/usr/bin/env bash
set -euo pipefail
cmd="$1"; shift || true
case "$cmd" in
  generate)
    # expected: --input <file> --out <dir>
    INPUT=""
    OUT=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --input) INPUT="$2"; shift 2;;
        --out)   OUT="$2";   shift 2;;
        *) shift;;
      esac
    done
    [[ -f "$INPUT" ]] || { echo "input not found: $INPUT"; exit 2; }
    [[ -n "$OUT" ]] || { echo "--out required"; exit 2; }
    mkdir -p "$OUT"
    # TODO: call actual BMAD CLI once upstream defines it.
    # For now, write a placeholder proving the pipeline works.
    node -e "require('fs').writeFileSync('$OUT/RESULT.md', '# BMAD Output\n\nSource: $INPUT\nTime: '+new Date().toISOString())"
    ;;
  *)
    echo "Usage: bmad generate --input <file> --out <dir>"; exit 1;;
esac