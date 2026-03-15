#!/usr/bin/env bash
# Create branch issue/N-title-slug and remind to move issue to "In progress".
# Usage: ./task-start.sh N
# Prerequisites: gh CLI, optionally jq. Repository: jlmonroy13/gym-voice.

set -e
GITHUB_REPO="${GITHUB_REPO:-jlmonroy13/gym-voice}"
if [[ -z "$1" ]]; then
  echo "Usage: $0 ISSUE_NUMBER"
  exit 1
fi
N="$1"
# Fetch issue title and create slug (lowercase, spaces to hyphens, remove non-alnum/hyphen)
TITLE=$(gh issue view "$N" --repo "$GITHUB_REPO" --json title -q .title 2>/dev/null || true)
if [[ -z "$TITLE" ]]; then
  echo "Could not fetch issue #$N. Check gh auth and repo $GITHUB_REPO."
  exit 1
fi
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
BRANCH="issue/${N}-${SLUG}"
git checkout -b "$BRANCH" 2>/dev/null || git checkout "$BRANCH"
echo "Branch: $BRANCH"
echo "Move issue #$N to 'In progress' on the project board (or use project automation)."
echo "Then implement and run scripts/task-pr.sh $N when ready for PR."
