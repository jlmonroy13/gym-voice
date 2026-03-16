# Task Execution Workflow

**Purpose:** Single reference for how to execute GitHub project tasks in this repository so that work is done in the same way every time: orderly, acceptance-criteria driven, board up to date, and traceable.

**Related documents:**
- [DEFINITION_OF_DONE.md](DEFINITION_OF_DONE.md) — When work is considered done and safe to merge.
- [.cursor/skills/github-workflow/SKILL.md](../../.cursor/skills/github-workflow/SKILL.md) — Issue/PR standards and gh CLI usage.
- [MILESTONES.md](../planning/MILESTONES.md) — Milestone order and deliverables.
- [MVP_PLAN.md](../planning/MVP_PLAN.md) — MVP boundary and implementation order.

**GymVoice:** Align scope and behavior with [PRD](../product/PRD.md) and [SOLUTION_DESIGN](../architecture/SOLUTION_DESIGN.md). In sensitive areas (auth, user data, voice pipeline) apply stricter DoD.

---

## Branching and pull requests

Use this section as the single place to find **how to start a task and open a PR**.

### Branch naming

- One branch per issue: **`issue/<N>-<title-slug>`** for issue #N.
- Example: for issue #1 "Document branching convention and PR template", the branch is `issue/1-document-branching-convention-and-pr-template`.
- The slug is the issue title in lowercase, spaces and non-alphanumeric characters replaced by hyphens.

### Starting a task (create branch)

- Run **`scripts/task-start.sh N`** from the repository root (with `N` = issue number). This creates or checks out the branch `issue/N-title-slug` and reminds you to move the issue to "In progress" on the project board.
- Prerequisites: `gh` CLI installed and authenticated (`gh auth status`). For board updates, ensure token has `project` scope (`gh auth refresh -s project` if needed). See [scripts/README.md](../../scripts/README.md).

### Opening a pull request

- Use the repository **PR template** for every PR: [.github/pull_request_template.md](../../.github/pull_request_template.md). Fill in Summary, Issue (Closes #N), Scope, Acceptance criteria, Validation, and Documentation.
- Run **`scripts/task-pr.sh N`** (or `scripts/task-pr.sh` to infer N from the branch name) to open a PR with "Closes #N". Then ensure the PR body matches the template (Summary, Scope, AC checklist, Validation, Docs).
- Full process: [TASK_EXECUTION_WORKFLOW.md](TASK_EXECUTION_WORKFLOW.md) §1–§3; [DEFINITION_OF_DONE.md](DEFINITION_OF_DONE.md) before merge.

---

## 1. Before Starting a Task

### 1.1 Pick Only "Ready" Issues

An issue is ready for implementation when:

- [ ] **Objective** is clear.
- [ ] **Scope** is bounded and **out of scope** is explicit where it matters.
- [ ] **Dependencies** are visible (other issues, milestones).
- [ ] **Acceptance criteria** are concrete and verifiable (not vague).
- [ ] No important **architecture or domain ambiguity** remains for the scope.
- [ ] The issue is **aligned with the current MVP**.

If any of the above is missing, do **not** move the issue to "In progress". Refine the issue first (edit description, clarify AC, or split it).

See: `.cursor/rules/110-planning/115-when-an-issue-is-ready.mdc`.

### 1.2 Respect Dependencies and Order

- **Milestones:** Follow the order in `docs/planning/MILESTONES.md` and `docs/planning/MVP_PLAN.md`. Do not start work that depends on a later milestone before the current one is in place where applicable.
- **Issue dependencies:** If the issue states "Depends on #N", do not start until #N is merged (or at least in PR and unblocked).
- **Board:** Pick tasks from the "Ready" (or "Backlog") column of the project board. Move to "In progress" only when you actually start work.

**Backlog triage:** To review backlog issues, move ready ones to "Ready", and get a recommended next task, use the Cursor command **Review Backlog and Promote Ready Issues** (`.cursor/commands/review-backlog-ready.md`).

### 1.3 Checklist: Before Moving to "In progress"

- [ ] Issue meets "ready" criteria above.
- [ ] Dependencies are satisfied.
- [ ] Milestone order is respected (if applicable).
- [ ] You have run `gh auth status` if you will use gh for board updates.

---

## 2. During Execution

### 2.1 Use the Issue as Contract

- **Acceptance criteria:** Treat them as a mandatory checklist. Each AC must be verifiable (behavior, success/failure, state, persistence). See: `.cursor/rules/110-planning/111-acceptance-criteria-rules.mdc`.
- **Scope:** Implement only what is in scope; do not bundle unrelated refactors or features. If something must be included, create a separate issue or get explicit approval. See: `.cursor/rules/110-planning/112-issue-sizing-rules.mdc`.
- If the issue turns out to be too large (multiple outcomes, mixed AC), split it into smaller issues before continuing.

### 2.2 Commits and Pull Request

- **Commits:** One commit = one coherent unit of work. Use the repository commit message format (type, scope, summary; optional Why/What/Validation). See: `.cursor/skills/commit-workflow/SKILL.md`.
- **Pull request:** One branch per issue (or per sub-issue if you split). PR description must include **"Closes #N"** (or "Fixes #N"). Summarize what changed and why; add notes for the reviewer if relevant. Use **gh CLI** or `scripts/task-pr.sh` when creating/updating PRs. See: `.cursor/skills/github-workflow/SKILL.md`.

### 2.3 Validation Before Marking "Done"

- Run lint, typecheck, tests, and build.
- Verify **each** acceptance criterion explicitly; do not assume.
- For **voice-pipeline or data-integrity work** (parsing, grouping, persistence, auth): ensure behavior is explicit, traceable, and that regression coverage is meaningful. See: [DEFINITION_OF_DONE.md](DEFINITION_OF_DONE.md) and `.cursor/skills/definition-of-done/SKILL.md`.
- If the change affects design, scope, or documented behavior, update the relevant docs (PRD, Business Logic, Technical Documentation, SOLUTION_DESIGN) per `.cursor/rules/00-core/03-documentation-update-rules.mdc`.

### 2.4 Checklist: Before Opening PR

- [ ] All acceptance criteria are satisfied and checked.
- [ ] Lint, typecheck, tests, build pass.
- [ ] Commits are coherent and follow commit message format.
- [ ] PR will reference the issue with "Closes #N".
- [ ] Documentation updated if required by the change.

---

## 3. Closing the Task (Definition of Done)

Work is not done until:

- [ ] Scope matches the issue; no unapproved scope creep.
- [ ] All acceptance criteria are satisfied and verified.
- [ ] Validation (lint, tests, build) is green.
- [ ] Traceability: PR linked to issue; outcome understandable.
- [ ] Documentation updated when behavior, scope, or architecture changed.
- [ ] PR is reviewable (size and description clear).
- [ ] CI green; no blockers; no unresolved critical review comments.

Then: merge the PR and move the issue to "Done" on the board (or use project automation). Optional: `scripts/task-done.sh [N]` as a reminder.

See [DEFINITION_OF_DONE.md](DEFINITION_OF_DONE.md) for full criteria, including additional requirements for voice-pipeline, auth, persistence, and architecture changes.
