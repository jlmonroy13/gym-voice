---
name: pr-review
description: >-
  Reviews pull requests for scope, readiness, and voice-pipeline/data-integrity
  behavior in the GymVoice repository. Use when preparing a PR for review, performing a
  PR review, or deciding whether to block or approve a PR.
---

# PR Review (GymVoice)

This skill helps apply repository PR rules: **coherent scope**, **review readiness**, and **stricter checks for voice-pipeline and data-integrity changes**.

## When to Use

Use this skill when:
- preparing a PR before requesting review
- reviewing an existing PR
- deciding whether a PR should be blocked or can be approved

## 1. Scope Check (What is this PR trying to do?)

- A PR should implement **one coherent unit of work**.
- Review for:
  - alignment with the linked issue
  - hidden scope expansion or "while I was here" changes
  - bundled unrelated refactors
  - architectural changes disguised as local cleanup
  - product scope creep vs current MVP
- Good PR scope:
  - solves a clear problem
  - stays inside approved issue boundaries
  - keeps intent easy to review
  - avoids mixing orthogonal changes

If the reviewer cannot clearly explain what the PR is supposed to accomplish, the PR scope is too broad or too vague.

## 2. Review Readiness (Is this PR ready to review?)

A PR is review-ready when:
- the linked issue is clear
- scope is understandable
- implementation intent is summarized in the PR description
- validation was performed (lint/tests/build as applicable)
- acceptance criteria were considered
- the diff is small enough or sufficiently explained
- obvious incomplete work is not hidden behind review

A PR is **not** review-ready if:
- the main behavior is still changing rapidly
- the PR lacks context
- key validation is missing
- known blockers remain unresolved
- the reviewer would need to guess the goal

Use review to **validate** the change, not to guess what the author meant to build.

## 3. Voice- and Data-Integrity–Sensitive Review (Stricter checks)

Apply stricter review when the PR affects:
- voice input → parsed structure (ParseExerciseSkill, GroupSeriesSkill, VoiceParserAgent, ErrorHandlerAgent)
- confirmation flow (incomplete or conflicting set → do not persist without confirmation)
- session and set persistence
- auth and token handling
- user and session data handling

For such PRs, ask:
- Is the behavior explicit and located in the correct layer?
- Is the lifecycle effect and state transition clear (pending → confirmed → persisted)?
- Is the behavior traceable later (persistence, no silent overwrite)?
- Is failure handling intentional and understandable (unrecognized, incomplete, conflict)?
- Is validation meaningful (not superficial tests)?

Block if:
- data-integrity meaning is ambiguous (e.g. incomplete set could be persisted without confirmation)
- critical outcomes are not persisted or are overwritten incorrectly
- voice or auth logic leaks into the wrong layer (e.g. domain depends on voice API)
- failures become harder to interpret
- validation is too weak for the risk level

## 4. When to Block a PR

Block a PR when merge would create meaningful **risk, ambiguity, or incomplete delivery**, for example:
- missing acceptance criteria coverage
- broken or ambiguous state transitions (session, set)
- hidden scope expansion
- voice-pipeline or persistence behavior with weak validation
- critical persistence gaps or data-integrity regressions
- unsafe contract changes
- architectural changes without documentation
- supportability regressions
- incomplete or misleading failure handling

Do **not** block for:
- minor preference-only style comments
- optional cleanup
- non-essential naming improvements
- future optimization ideas not required for correctness

## Quick Checklist for PR Review

- [ ] PR scope is one coherent unit of work
- [ ] PR linked to the correct issue and aligned with it
- [ ] PR description states intent and summarizes the change
- [ ] Validation has been run and is appropriate (tests/lint/build)
- [ ] Acceptance criteria are obviously addressed
- [ ] Voice-pipeline and data-integrity changes (if any) are explicit, traceable, and validated
- [ ] No persistence or data-integrity regressions
- [ ] No hidden scope expansion or architectural changes without docs

## References in this Repo

- PR scope rules: `.cursor/rules/100-review/100-pr-scope-rules.mdc`
- Review readiness rules: `.cursor/rules/100-review/101-review-readiness-rules.mdc`
- Voice-sensitive review rules: `.cursor/rules/100-review/103-voice-sensitive-review-rules.mdc`
- When to block a PR: `.cursor/rules/100-review/104-when-to-block-a-pr.mdc`
