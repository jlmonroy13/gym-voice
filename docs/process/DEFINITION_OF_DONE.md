# Definition of Done

## Purpose
This document defines the minimum completion standard for all work delivered in the GymVoice repository. An issue, task, or pull request is only considered done when the work is correct, validated, traceable, reviewable, aligned with scope, and safe to merge. This document exists to prevent incomplete work, hidden regressions, undocumented behavior changes, and data-integrity shortcuts.

**Related baseline docs:**

- Workflow: [TASK_EXECUTION_WORKFLOW.md](TASK_EXECUTION_WORKFLOW.md)
- Repository operating contract: [PROJECT.md](../PROJECT.md)
- Product scope and MVP framing: [PRD.md](../product/PRD.md)
- Architecture and data flow: [SOLUTION_DESIGN.md](../architecture/SOLUTION_DESIGN.md)
- Stack and tooling decisions: [STACK.md](../architecture/STACK.md)
- Milestones and MVP boundary: [MILESTONES.md](../planning/MILESTONES.md), [MVP_PLAN.md](../planning/MVP_PLAN.md)

---

## Core Rule
Work is not done when code exists. Work is done only when the agreed scope is implemented, acceptance criteria are satisfied, validation is completed, relevant documentation is updated, the change is reviewable and supportable, and the result is safe to merge.

---

## Universal Definition of Done

A task is considered done only if all applicable conditions below are true.

### 1. Scope Completion
- The implementation matches the approved issue scope.
- No unrelated work was bundled unless explicitly approved.
- Out-of-scope additions were avoided.
- Any scope deviation was documented and approved before merge.

### 2. Acceptance Criteria Completion
- All issue acceptance criteria are satisfied.
- Acceptance criteria were checked explicitly, not assumed.
- Missing or ambiguous acceptance criteria were clarified before merge.

### 3. Code Quality
- The code is readable and maintainable.
- Naming is clear and consistent.
- The solution follows repository conventions.
- The implementation avoids unnecessary complexity.
- Dead code, temporary hacks, and unexplained workarounds were not left behind.

### 4. Validation
- The change was validated at the appropriate level.
- Relevant automated checks passed (lint, typecheck, tests, build).
- Relevant manual validation was performed when necessary.
- Edge cases and failure paths were considered where applicable.

### 5. Regression Safety
- Existing behavior was not broken unintentionally.
- The change was reviewed for side effects.
- Backward compatibility was preserved when expected.
- The implementation does not silently alter unrelated flows.

### 6. Traceability
- The PR references the related issue (e.g. Closes #N).
- The issue reflects the actual delivered outcome.
- Important implementation notes were documented when useful.
- Data-integrity or voice-pipeline behavior changes are traceable.

### 7. Documentation
- Documentation was updated when required.
- Architecture-impacting changes updated the relevant design docs.
- Behavior or scope changes updated PRD, Business Logic, or Technical Documentation when applicable.
- New operational or user-facing behavior was documented if support or future developers would need it.

### 8. Review Readiness
- The PR is small enough to review effectively, unless a larger change was explicitly necessary.
- The PR description clearly explains what changed and why.
- Reviewers can understand the change without reverse-engineering intent from the diff alone.

### 9. Merge Readiness
- CI checks passed.
- No known blocking issues remain.
- No unresolved critical comments remain.
- The branch is safe to merge into the target branch.

---

## Required Checks Before Marking Work Done

Unless explicitly not applicable:

- [ ] Lint passes
- [ ] Typecheck passes
- [ ] Tests pass
- [ ] Build passes
- [ ] Acceptance criteria were verified
- [ ] PR is linked to the issue
- [ ] Relevant documentation is updated
- [ ] Reviewer feedback is addressed
- [ ] No known blocking bug remains in the delivered scope

---

## Additional Requirements for Voice-Pipeline Work

The following rules apply to any change affecting:

- voice-to-text integration
- ParseExerciseSkill or VoiceParserAgent
- GroupSeriesSkill or ExerciseLoggerAgent
- validation of parsed data before persist
- ErrorHandlerAgent or error/confirmation flows

Such work is not done unless:

- The behavior is explicit and reviewable (no silent or ambiguous saves).
- Relevant regression coverage exists (unit tests for parsing and grouping where applicable).
- Incomplete or conflicting data paths are handled with confirmation or clarification (no silent persist).
- Documentation (Business Logic or Technical Documentation) is updated where behavior or rules change.
- Failure handling was considered (unrecognized phrase, missing fields, conflict).

---

## Additional Requirements for Authentication and User Data

Changes affecting auth (OAuth, custom login, tokens) or user/session persistence are not done unless:

- Sensitive data is handled intentionally (no secrets in code or unsafe logs).
- Failure behavior is explicit (e.g. auth failure, session load failure).
- Relevant tests cover success and failure paths where critical.
- Environment or configuration assumptions are documented when relevant.

---

## Additional Requirements for Persistence Changes

Changes affecting database schema or how sessions, exercises, sets, or set groups are stored are not done unless:

- The schema or persistence shape is intentional and documented.
- Migrations (if any) were reviewed.
- Data consistency and integrity rules (e.g. no incomplete set without confirmation) are preserved or explicitly updated.
- The new persistence shape supports history and progress queries where needed.

---

## Additional Requirements for Architecture Changes

A change that alters architecture is not done unless:

- The change is explicitly acknowledged as architectural.
- `docs/architecture/SOLUTION_DESIGN.md` is updated if needed.
- A new ADR is added if the decision is significant.
- The reasoning and tradeoffs are documented.
- Module boundaries (mobile, backend, voice pipeline, agents/skills) remain clear after the change.

---

## Additional Requirements for API Changes

A change affecting API contracts (backend routes, request/response shape) is not done unless:

- The request and response shape is intentional.
- Validation behavior is explicit.
- Error responses remain consistent.
- Backward compatibility is evaluated.
- Callers (e.g. mobile) have enough information to use the API safely.

---

## Testing Expectations by Work Type

### Parsing / Voice Pipeline Changes
Must include validation of:
- ParseExerciseSkill: given phrase → expected structure; missing or ambiguous fields → no silent persist.
- GroupSeriesSkill: grouping logic for bisets/trisets; edge cases (e.g. last set of group).
- VoiceParserAgent / ErrorHandlerAgent: success and at least one error path.

### Session and Persistence Changes
Must include validation of:
- Session start/end and duration.
- Set and set-group persistence.
- History/progress queries return consistent data.

### UI Changes
Must include validation of:
- Key screens and flows (e.g. confirm set, view history) where applicable.
- Spanish strings and accessibility where relevant.
- React Native Testing Library or equivalent for critical components.

### Bug Fixes
Must include:
- Confirmation of root cause.
- Verification that the bug is fixed.
- Reasonable confidence that the bug will not immediately recur through the same path.

---

## Documentation Expectations

Update documentation whenever applicable.

### Update `PROJECT.md` when:
- Repository operating principles or core scope change.

### Update `docs/product/PRD.md` when:
- MVP scope, product goals, or primary flows change.

### Update `docs/architecture/# GymVoice – Business Logic.md` when:
- User flow, business rules, special cases, or data stored change.

### Update `docs/architecture/# GymVoice – Technical Documentation.md` when:
- Tech stack, repository structure, agents, skills, or testing strategy change.

### Update `docs/architecture/SOLUTION_DESIGN.md` when:
- Module boundaries, data flow, or architecture change.

### Add or update ADRs when:
- A significant architectural or product decision is made.
- A tradeoff needs to be recorded for later.

---

## PR Quality Standard

A PR is not done unless:

- It has a clear summary.
- It references the related issue (Closes #N).
- It explains what changed and why.
- It explains anything the reviewer should pay attention to (e.g. sensitive area, data-integrity rule).
- It avoids bundling unrelated refactors.
- It is reviewable without guessing intent.

Preferred: small and focused PRs, explicit scope notes, clear validation notes.

---

## Issue Completion Standard

An issue is not done unless:

- The linked implementation matches the issue.
- Acceptance criteria are actually met.
- Blockers are resolved or explicitly documented.
- Follow-up work is captured as new issues if needed.
- The delivered result is real, not partially complete work disguised as done.

---

## Things That Do Not Count as Done

The following do not qualify as done on their own:

- Code compiles locally.
- A happy path works once.
- A feature appears to work without validation.
- The PR is open.
- The implementation is “almost finished.”
- Documentation will be added later.
- Tests will be added later.
- Unresolved reviewer concerns remain.
- The implementation depends on hidden knowledge not written anywhere.
- Incomplete or conflicting data can be persisted without user confirmation (in voice/set scope).

---

## GymVoice Sensitive Areas (Stricter DoD)

For **authentication**, **user data and session persistence**, and **voice-to-structured-data pipeline** (parsing, grouping, validation before save): apply stricter DoD. Require explicit behavior, traceability, and sufficient tests. Block merge if behavior is unclear, data could be corrupted, or tests are missing for critical paths. Define and extend the list in PROJECT.md and `.cursor/rules/00-core/02-definition-of-done.mdc`.

---

## Human Review Requirement

Human review is still required for:

- Architecture changes
- Voice-pipeline or data-integrity behavior changes
- Auth or persistence contract changes
- API contract changes

AI assistance can accelerate delivery but does not replace accountable review for these changes.

---

## Final Rule
If a change technically works but is not validated, not documented, not traceable, or not safe to support (e.g. allows invalid data to be persisted), it is not done.
