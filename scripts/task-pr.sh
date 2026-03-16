#!/usr/bin/env bash
# Open a pull request for the current branch, linking it to the given issue
# with "Closes #N" so the issue is closed when the PR is merged.
#
# Usage: ./task-pr.sh [ISSUE_NUMBER] [extra gh pr create args...]
# Examples:
#   ./task-pr.sh 2
#   ./task-pr.sh            # when on a branch named issue/N-title-slug
#
# Prerequisites: gh CLI authenticated (gh auth status). Repository: jlmonroy13/gym-voice.

set -e

GITHUB_REPO="${GITHUB_REPO:-jlmonroy13/gym-voice}"

if ! command -v gh &>/dev/null; then
  echo "Error: gh CLI is required. Install it and run: gh auth status"
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo "Error: gh is not authenticated. Run: gh auth login"
  exit 1
fi

BRANCH="$(git branch --show-current)"
if [[ -z "$BRANCH" ]]; then
  echo "Error: Not on a branch (detached HEAD?)"
  exit 1
fi

# Issue number: from first argument or from branch name issue/N-...
N="${1:-}"
if [[ -n "$N" ]]; then
  shift
else
  if [[ "$BRANCH" =~ ^issue/([0-9]+)- ]]; then
    N="${BASH_REMATCH[1]}"
  fi
fi

if [[ -z "$N" ]]; then
  echo "Usage: $0 [ISSUE_NUMBER]"
  echo "  Provide ISSUE_NUMBER or run from a branch named issue/N-title-slug."
  exit 1
fi

# Ensure issue exists
if ! gh issue view "$N" --repo "$GITHUB_REPO" --json number -q .number &>/dev/null; then
  echo "Error: Could not load issue #$N (check number and repo: $GITHUB_REPO)"
  exit 1
fi

BODY="Closes #${N}"
echo "Creating PR for branch '$BRANCH' (Closes #$N)..."
gh pr create --repo "$GITHUB_REPO" --fill --body "$BODY" "$@"
echo ""
echo "Move issue #$N to 'In review' on the project board (or use project automation)."
echo "After merge, run scripts/task-done.sh $N or move to 'Done' manually."