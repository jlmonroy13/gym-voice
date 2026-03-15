You are responsible for executing the **entire** workflow for a single GitHub
issue in one command run: readiness → start → **implementation** → **open PR** → **ensure issue is In review**.
You must **not** stop after moving the issue to "In progress". You must implement
the issue and open the PR in this same execution.

## Single-run rule (mandatory)

This command completes in **one** run:

1. Verify that the issue is **ready** to be worked on.
2. Run `scripts/task-start.sh N` (branch + move to **In progress**).
3. **Implement** the issue (code, tests, validation, commits).
4. **Open the PR** with `scripts/task-pr.sh N` and move the issue to **In review** on the project board using GitHub automation (scripts or `gh`); if no automation is configured, you must move it explicitly with `gh` instead of asking the user to do it.

Do **not** stop after step 2. Do **not** tell the user to "implement and then run
task-pr.sh". You must perform steps 3 and 4 in this same command run.

## Goal

Given an issue number **N**:

1. Verify that the issue is **ready** to be worked on.
2. Run the `scripts/task-start.sh N` script to:
   - create/activate the `issue/N-title-slug` branch, and
   - move the issue to **In progress** on the project board (when applicable).
3. Perform the **implementation** phase, following all relevant documentation and
   rules (workflow, DoD, voice pipeline, testing).
4. Leave the work ready for a PR and **open the PR as part of this command**, without requiring extra confirmation, and move the issue to **In review** after the PR is created using GitHub automation (scripts or `gh`). If the project does not yet have automation rules for this, use `gh` to update the project column yourself.

## Input

- The user will either:
  - provide an issue number explicitly (e.g. "run work-on-issue for #7"), or
  - ask you to work on "this issue" and then specify or confirm the number.
- If you **do not** have a clear issue number, ask the user for it **before**
  doing anything.

## Constraints and References

- **Main workflow doc:** `docs/process/TASK_EXECUTION_WORKFLOW.md`
- **Skill:** `.cursor/skills/task-execution-workflow/SKILL.md`
- **GitHub workflow:** `.cursor/skills/github-workflow/SKILL.md`
- **Commit workflow:** `.cursor/skills/commit-workflow/SKILL.md`
- **Definition of Done:** `.cursor/skills/definition-of-done/SKILL.md`,
  `docs/process/DEFINITION_OF_DONE.md`
- **PR template:** `.github/pull_request_template.md` (if present)
- **Planning rules:** `.cursor/rules/110-planning/*`
- **Voice pipeline & persistence rules:** `.cursor/rules/30-architecture/31-domain-vs-voice-boundary.mdc`,
  `.cursor/rules/70-persistence/70-persistence-principles.mdc`,
  `.cursor/rules/100-review/103-voice-sensitive-review-rules.mdc`

You must respect these boundaries and rules when implementing.

## Step 1: Confirm Issue Readiness

1. Resolve the issue number **N**.
2. Use `gh issue view N` (via Shell) to read the issue body and check that it
   meets the "ready" criteria:
   - objective clear
   - bounded scope and explicit out-of-scope where needed
   - dependencies visible
   - acceptance criteria meaningful and verifiable
   - aligned with the current MVP
3. If the issue is **not** ready:
   - Do **not** start implementation.
   - Explain to the user what is missing (e.g. weak AC, vague scope, missing
     dependencies) and propose concrete edits to the issue text.
   - Stop instead of guessing hidden intent.

Use `.cursor/rules/110-planning/115-when-an-issue-is-ready.mdc` as reference.

## Step 2: Start the Task (script + board)

1. Ensure `gh` is installed and authenticated (`gh auth status`). If not,
   instruct the user to fix their auth first.
2. Run the script (via Shell) from the repo root:

   - `./scripts/task-start.sh N`

   This should:
   - create or switch to branch `issue/N-title-slug`
   - move the issue to **In progress** on the GymVoice project board if the
     issue is on the project and the token has `project` scope.
3. If the script cannot update the project (e.g. missing `project` scope or the
   issue is not in the project), tell the user explicitly and remind them to
   move the card to **In progress** manually.

After this step, you must be on the correct branch for issue **N**.

**Do not stop here.** Proceed immediately to Step 3 (context), Step 4 (implementation), and Step 5 (open PR) in this same run.

## Step 3: Prepare Implementation Context

Before editing code:

1. Read `docs/process/TASK_EXECUTION_WORKFLOW.md` (at least the sections:
   "During Execution", "Closing the Task", and "Keeping the Board Up to
   Date").
2. Read `.cursor/skills/task-execution-workflow/SKILL.md` to align on how to:
   - use the issue as contract
   - structure commits
   - validate before PR
   - apply Definition of Done
3. If the issue touches voice pipeline, persistence, auth, or session/set model, read the relevant rules under `.cursor/rules/30-architecture/31-domain-vs-voice-boundary.mdc`,
   `.cursor/rules/70-persistence/70-persistence-principles.mdc`,
   `.cursor/rules/100-review/103-voice-sensitive-review-rules.mdc`.

## Step 4: Implementation Loop (required in this run)

You must implement the issue in this command run. Do not defer implementation to the user.

For the implementation phase:

1. Treat the issue's **acceptance criteria** as a checklist.
   - For each AC, decide which code changes and which tests are required.
   - Do not implement behavior that is clearly out of scope.
2. Keep changes **scoped** to the issue:
   - If you discover unrelated refactors or fixes, surface them and suggest
     separate issues instead of silently expanding scope.
3. Use small, coherent commits:
   - One logical unit of work per commit.
   - Follow `commit-workflow` skill for message format (type(scope): summary +
     Why/What/Validation sections).
4. Continuously validate:
   - Run the appropriate lint / typecheck / test / build commands.
   - For voice pipeline, persistence, or auth behavior, prefer adding or updating tests that make the
     new behavior explicit and regression-safe.

At all times, keep the separation of concerns described in the repo rules
(domain vs voice pipeline, API vs application vs persistence, etc.).

## Step 5: Ready for PR — then open it (required in this run)

When implementation is complete for the issue:

1. Re-check the issue:
   - Each acceptance criterion is satisfied and you can explain how.
2. Apply Definition of Done (DoD):
   - scope alignment
   - AC completion
   - validation (lint/tests/etc.) actually run
   - traceability (issue ↔ implementation)
   - documentation impact handled
3. **Open the PR in this same command run** (do not leave this for the user):
   - Push the current branch to the remote (`git push -u origin <branch>`) if not already pushed.
   - Run `./scripts/task-pr.sh N` via Shell. If the script does not populate the PR body using the repository template, follow up with `gh pr edit` so the body content comes from `.github/pull_request_template.md` if it exists.
   - After the PR is created, move the associated issue to **In review** on the GymVoice project board using GitHub automation (scripts or `gh`). If automation is not configured for this transition, use `gh` to update the issue's project status explicitly; do **not** rely on the user to move it manually.
   - Ensure the PR body includes `Closes #N` and is based on the PR template
     sections (Summary, Scope, AC check, Validation, Docs) if a template exists; do not leave the
     PR description empty.
   - Tell the user the PR URL and any important notes for review.

If you stop without opening the PR, this command is incomplete.

## Step 6: Closing Notes

- Never skip readiness checks or Definition of Done checks just because this is
  a command.
- Never mark the issue as done or move it to "Done" silently; when the PR is
  opened, make sure the issue is moved to **In review** (either via project
  automation or an explicit `gh` project update), and only move it to **Done**
  once the PR is merged (either by automation or manually).
- Always make scope and AC handling explicit in your explanation back to the
  user.
