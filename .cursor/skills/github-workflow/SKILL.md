---
name: github-workflow
description: >-
  Uses gh CLI for GitHub write operations and applies repo issue/PR standards
  for the GymVoice repository. Use when creating or editing issues, pull
  requests, or project board items; when linking PRs to issues; or when the user
  asks to create an issue, open a PR, or update GitHub project status.
---

# GitHub Workflow (GymVoice)

This skill ensures GitHub operations follow repository conventions: **gh CLI** for writes, **execution-ready issues**, and **traceable PRs**.

## Tooling: Prefer gh CLI

- **Write operations** (create/edit issues, create PRs, add to project, update fields): use **gh** CLI. Do not use GitHub MCP for the same write workflow.
- **Read-only** (list issues, read PR description): GitHub MCP is acceptable.
- Before any write with gh, run: `gh auth status`.
- **Repository:** https://github.com/jlmonroy13/gym-voice
- **Primary project:** GymVoice (number 3), https://github.com/users/jlmonroy13/projects/3/views/1?layout=board
- Use one consistent path per task; do not mix MCP and CLI in the same workflow. For project board updates, ensure token has `project` scope: `gh auth refresh -s project` if needed.

## Creating or Editing Issues

Apply these standards so issues are executable without guesswork.

### Required elements
- **Title** — clear and specific (e.g. "Parse voice phrase into exercise, set, weight, reps, notes")
- **Objective** — what must be achieved
- **Why it matters** — context for the change
- **Scope** — what is in scope
- **Out of scope** — explicit where it avoids drift
- **Dependencies** — visible (e.g. "Depends on #N")
- **Acceptance criteria** — verifiable outcomes, not vague hopes

### Acceptance criteria quality
Criteria must be:
- Explicit, testable, scoped, outcome-oriented
- Answer: what behavior must exist? success/failure behavior? state or persistence effect? what must be visible to user/system?
- For GymVoice, prefer "Given X, then Y" and "Given incomplete set, app asks for confirmation and does not save until confirmed"
- Avoid: "works correctly", "handles errors properly", "voice input is handled correctly"

### Sizing
- One meaningful outcome per issue; understandable in one pass; reviewable PR.
- Split when: multiple layers for unrelated reasons, multiple outcomes, long/mixed AC, or the issue would produce an oversized PR.
- Avoid umbrella issues ("implement entire voice logging flow", "add voice and history").

### Ready for active work when
- Objective clear; scope bounded; out-of-scope explicit where needed; dependencies visible and satisfied; AC meaningful; MVP-aligned; no key ambiguity left.

## Pull Requests

- **Link PR to issue:** every PR must reference the issue it implements (e.g. "Closes #N" or "Fixes #N" in description or when creating with `gh pr create`).
- When creating a PR with gh, pass the issue link: `gh pr create --fill` and ensure the body references the issue, or use `--body` with "Closes #N". Use `scripts/task-pr.sh N` when in repo.

## Project Board

- Use gh for adding issues to the project or updating status when the task involves moving work (Backlog → Ready → In progress → In review → Done).
- Keep milestone/epic assignment outcome-oriented (see rule 114 if organizing milestones or epics).

## Quick checklist (issues)

- [ ] Title and objective clear
- [ ] Scope and out-of-scope explicit
- [ ] Dependencies listed
- [ ] Acceptance criteria verifiable (not vague)
- [ ] One coherent outcome; not an umbrella task
- [ ] MVP-aligned

## Quick checklist (PRs)

- [ ] PR linked to issue
- [ ] Created/updated with gh when doing write operations
- [ ] `gh auth status` verified before first write

## References in this repo

- **Tooling:** `.cursor/rules/00-core/04-github-tooling-precedence.mdc`
- **Issue writing:** `.cursor/rules/110-planning/110-issue-writing-rules.mdc`
- **Acceptance criteria:** `.cursor/rules/110-planning/111-acceptance-criteria-rules.mdc`
- **Issue sizing:** `.cursor/rules/110-planning/112-issue-sizing-rules.mdc`
- **When issue is ready:** `.cursor/rules/110-planning/115-when-an-issue-is-ready.mdc`
- **Milestones/epics:** `.cursor/rules/110-planning/114-milestone-and-epic-structure.mdc`
