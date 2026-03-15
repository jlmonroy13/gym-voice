---
name: task-execution-workflow
description: >-
  Follows the repository task execution workflow when starting, implementing,
  or closing a GitHub issue. Use when executing a project task so the same
  process is used every time (orderly, AC-driven, board up to date).
---

# Task Execution Workflow (GymVoice)

This skill ensures that work on GitHub issues follows the process in **`docs/process/TASK_EXECUTION_WORKFLOW.md`**: one consistent flow for starting, implementing, and closing tasks.

## When to Use

Use this skill when:
- the user asks to start, implement, or close a task from the GitHub project
- the user refers to an issue number as the current unit of work
- you are about to move an issue to "In progress", open a PR for an issue, or mark work as done

## Core Rule

Execute GitHub project tasks by following the workflow doc. Do not skip readiness checks, acceptance criteria, traceability (PR ↔ issue), or Definition of Done.

## Before Starting a Task

1. **Confirm the issue is ready.** Read the issue; verify:
   - Objective clear, scope bounded, out-of-scope explicit where needed
   - Dependencies visible; acceptance criteria meaningful and verifiable
   - MVP-aligned; no key ambiguity
   If not ready, do not move to "In progress"; refine or split the issue first. See: `.cursor/rules/110-planning/115-when-an-issue-is-ready.mdc`.

2. **Respect dependencies and order.** Check issue body and `docs/planning/MILESTONES.md` / `MVP_PLAN.md`. Do not start if dependencies are not satisfied. For voice pipeline or persistence tasks, ensure dependent work (e.g. auth, session API) is done first when the issue says so.

3. **Start the task.** Move issue to "In progress" (with gh). Create branch (e.g. `issue/N-short-title`). Run `scripts/task-start.sh N` when in repo.

## During Implementation

1. **Use the issue as contract.** Implement only in-scope work; treat each acceptance criterion as a checklist item. Do not bundle unrelated refactors or features. See: `.cursor/rules/110-planning/111-acceptance-criteria-rules.mdc`, `112-issue-sizing-rules.mdc`.

2. **Commits.** One coherent unit per commit; use the repo commit message format (type, scope, Why/What/Validation). See: `.cursor/skills/commit-workflow/SKILL.md`.

3. **Validation before PR.** Run lint, typecheck, tests, build. Verify each AC explicitly. Update docs if the change affects design, scope, or documented behavior. See: `.cursor/rules/00-core/03-documentation-update-rules.mdc`. For voice pipeline, auth, or persistence: ensure tests cover critical paths per `.cursor/rules/90-testing/90-testing-strategy-overview.mdc`.

## When Opening a PR

1. **Link PR to issue.** PR description must include "Closes #N" (or "Fixes #N").
2. **Use gh for write operations.** Create/update PR with gh; ensure body references the issue. See: `.cursor/skills/github-workflow/SKILL.md`.
3. **Fill the PR template** (if present). Summary, scope, AC check, validation, documentation impact. Run `scripts/task-pr.sh N` when ready.

## Before Marking "Done"

1. **Apply Definition of Done.** Do not mark done just because code compiles or "works". Confirm: scope implemented, all AC satisfied, validation run, traceability (PR linked), docs updated if needed, CI green, no blocking defects or unresolved critical review comments. See: `.cursor/skills/definition-of-done/SKILL.md` and `docs/process/DEFINITION_OF_DONE.md`.

2. **Voice-pipeline and data-integrity work.** Ensure behavior is explicit, traceable, and regression coverage is meaningful where applicable. See: `.cursor/rules/100-review/103-voice-sensitive-review-rules.mdc`.

3. **Close.** Only after DoD is met: merge the PR, then move the issue to "Done" on the board (or rely on Project automation). Run `scripts/task-done.sh` if not using automation.

## Quick Checklist (start → done)

- [ ] Issue is ready (objective, scope, AC, dependencies)
- [ ] Issue moved to "In progress"; branch created
- [ ] Implementation matches issue scope; AC used as checklist
- [ ] Lint, typecheck, tests, build pass; each AC verified
- [ ] PR created with "Closes #N"; template filled
- [ ] Definition of Done met; PR merged
- [ ] Issue moved to "Done" (or automation does it)

## References in This Repo

- **Full workflow:** `docs/process/TASK_EXECUTION_WORKFLOW.md`
- **Cursor rule:** `.cursor/rules/110-planning/116-task-execution-workflow.mdc`
- **GitHub / issues / PRs:** `.cursor/skills/github-workflow/SKILL.md`
- **Definition of Done:** `.cursor/skills/definition-of-done/SKILL.md`
- **Commit format:** `.cursor/skills/commit-workflow/SKILL.md`
- **Scripts:** `scripts/task-start.sh`, `scripts/task-pr.sh`, `scripts/task-done.sh`
