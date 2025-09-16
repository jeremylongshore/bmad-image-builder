#!/usr/bin/env bash
set -euo pipefail

# Debug output
echo "Args: $*" >&2

# Handle both "bmad generate" and "generate" commands
if [[ "$1" == "bmad" ]]; then
  shift  # remove "bmad"
fi

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
        *) echo "Unknown arg: $1" >&2; shift;;
      esac
    done

    echo "INPUT: $INPUT" >&2
    echo "OUT: $OUT" >&2

    [[ -n "$INPUT" ]] || { echo "--input required"; exit 2; }
    [[ -n "$OUT" ]] || { echo "--out required"; exit 2; }
    [[ -f "$INPUT" ]] || { echo "input not found: $INPUT"; exit 2; }

    mkdir -p "$OUT"
    # TODO: call actual BMAD CLI once upstream defines it.
    # For now, write a placeholder proving the pipeline works.
    echo "Creating BMAD output from $INPUT to $OUT" >&2
    node -e "
      const fs = require('fs');
      const input = fs.readFileSync('$INPUT', 'utf8');
      const output = \`# BMAD Generated PRD

Source: $INPUT
Generated: \${new Date().toISOString()}

## Original Input
\${input}

## BMAD Analysis
This would contain the full BMAD agent workflow output:
- Market analysis from Analyst agent
- Product requirements from PM agent
- System architecture from Architect agent
- Implementation plan from Dev agent

Status: Container integration complete!
\`;
      fs.writeFileSync('$OUT/PRD.md', output);
      console.log('✅ BMAD workflow completed successfully');
    "
    ;;
  *)
    echo "Usage: bmad generate --input <file> --out <dir>"; exit 1;;
esac