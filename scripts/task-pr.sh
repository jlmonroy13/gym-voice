#!/usr/bin/env bash
# Open PR for current branch with "Closes #N". N from argument or inferred from branch name (issue/N-...).
# Usage: ./task-pr.sh [N]
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
  echo "Usage: $0 ISSUE_NUMBER"
  echo "Or run from a branch named issue/N-title and omit N."
  exit 1
fi
BODY="Closes #${N}"
gh pr create --repo "$GITHUB_REPO" --body "$BODY" "$@"
echo "Move issue #$N to 'In review' on the project board."
echo "After merge, run scripts/task-done.sh $N or move to 'Done' manually."