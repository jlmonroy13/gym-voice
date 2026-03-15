#!/usr/bin/env bash
# After merge: remind to move issue to "Done" (or do it via gh if project is configured).
# Usage: ./task-done.sh [N]
# Prerequisites: gh CLI. Repository: jlmonroy13/gym-voice.

set -e
GITHUB_REPO="${GITHUB_REPO:-jlmonroy13/gym-voice}"
N="$1"
if [[ -z "$N" ]]; then
  BRANCH=$(git branch --show-current)
  if [[ "$BRANCH" =~ ^issue/([0-9]+)- ]]; then
    N="${BASH_REMATCH[1]}"
  fi
fi
if [[ -z "$N" ]]; then
  echo "Usage: $0 [ISSUE_NUMBER]"
  echo "Or run from a branch named issue/N-title."
  exit 1
fi
echo "If not already done: move issue #$N to 'Done' on the project board."
echo "Repo: $GITHUB_REPO"
echo "Definition of Done: docs/process/DEFINITION_OF_DONE.md"
