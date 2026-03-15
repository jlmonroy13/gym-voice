---
name: definition-of-done
description: >-
  Applies the repository-wide definition of done and merge-readiness standard
  for GymVoice. Use when deciding whether an issue, task, or pull request is
  actually done and safe to merge.
---

# Definition of Done (GymVoice)

This skill enforces the repository **Definition of Done** so that work is not treated as finished just because code exists.

## When to Use

Use this skill when:
- deciding if a PR is ready to merge
- deciding if an issue or task can be moved to Done
- checking whether additional validation or documentation is needed

## Core Rule

Work is not done because code exists.
Work is done only when:
- the approved scope is implemented
- acceptance criteria are satisfied
- relevant validation is completed
- important behavior is explicit
- traceability is preserved
- documentation is updated when needed
- the result is safe to review and safe to merge

## Universal Done Criteria (Checklist)

Confirm all applicable items:

- **Scope alignment**
  - Implementation matches the issue scope.
  - Unrelated work is not bundled into the change.
  - Any scope deviation is surfaced and approved.

- **Acceptance criteria completion**
  - All AC are explicitly satisfied.
  - Ambiguous or missing AC were clarified before merge.

- **Correctness and code quality**
  - Logic, state behavior, and persistence effects are correct for intended use.
  - Naming is clear and consistent; code follows repo conventions.
  - No dead code, unexplained hacks, or accidental complexity left behind.

- **Validation**
  - Appropriate validation ran: lint, typecheck, tests, build, and/or manual workflow checks.
  - Edge cases and failure paths were considered where relevant.

- **Regression safety**
  - Existing behavior was not broken unintentionally.
  - Side effects and backward compatibility (where expected) were considered.

- **Traceability**
  - PR links to the related issue.
  - Issue reflects the actual delivered outcome.
  - Critical lifecycle effects and persistence outcomes are understandable.

- **Documentation**
  - Docs were updated when behavior, structure, or scope changed materially.
  - Architecture-impacting changes updated SOLUTION_DESIGN or ADRs as needed.
  - Voice-pipeline or data-model changes updated Business Logic or Technical Documentation when applicable.

- **Safety to merge**
  - CI checks pass (where applicable).
  - No known blocking defects remain.
  - No unresolved critical reviewer concerns remain.

## Extra Checks for Voice-Pipeline and Data-Integrity Work

For changes affecting:
- voice input → parsed structure (ParseExerciseSkill, GroupSeriesSkill, VoiceParserAgent, ErrorHandlerAgent)
- confirmation flow (incomplete or conflicting set → do not persist without confirmation)
- session and set persistence
- auth and token handling
- user and session data handling

Ensure additionally that:
- behavior is explicit and understandable
- traceability is preserved
- failure handling is intentional and reviewable
- regression risk is considered and tests are meaningful for critical paths
- voice-pipeline or persistence logic is not hidden in the wrong layer

## Extra Checks for Architecture, API, and Persistence Changes

- Architecture changes:
  - Acknowledged as architectural.
  - `docs/architecture/SOLUTION_DESIGN.md` and ADRs updated if needed.

- API changes:
  - Contract behavior, request validation, error behavior, and compatibility expectations are explicit.

- Persistence changes:
  - Data consistency and operational traceability are considered.
  - Migrations (if any) are safe and reviewed.
  - Business rule respected: no persisting incomplete or conflicting sets without confirmation.

## Things That Do Not Count as Done

Do not mark work as done solely because:
- code compiles locally
- a happy path worked once
- a PR was opened
- the feature "basically works"
- tests or docs will be added later

If a change technically works but is not validated, not documented when necessary, not traceable, or not safe to support in production, it is **not** done.

## References in this Repo

- Rule-level DoD: `.cursor/rules/00-core/02-definition-of-done.mdc`
- Process doc DoD: `docs/process/DEFINITION_OF_DONE.md`
- Voice-sensitive review: `.cursor/rules/100-review/103-voice-sensitive-review-rules.mdc`
