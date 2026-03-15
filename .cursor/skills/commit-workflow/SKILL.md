---
name: commit-workflow
description: >-
  Helps create coherent git commits in GymVoice following the repository's
  commit message format and staging rules. Use when preparing or creating
  commits, or when deciding how to split changes into commits.
---

# Commit Workflow (GymVoice)

This skill applies the repository commit command rules so that commits are **coherent, traceable, and well-described**.

## When to Use

Use this skill when:
- preparing to commit changes
- deciding how to stage and split work into commits
- writing commit messages

## 1. Commit Message Format

Follow this format:

- Header: `<type>(<scope>): <short summary>`
- Body sections:
  - **Why:** 1–3 bullets explaining why this change exists.
  - **What:** 1–5 bullets describing what changed.
  - **Validation:** bullets describing checks performed, or `Not run`.

Allowed types:
- `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `ci`, `build`, `perf`.

Short summary:
- lowercase
- imperative tone
- ideally ≤ 72 characters
- describe the main outcome, not implementation detail.

## 2. Staging and Scope

- Inspect changes with:
  - `git diff --staged`
  - `git diff`
- Prefer committing **only staged changes** if anything is already staged.
- If nothing is staged:
  - inspect all current changes
  - stage only files that clearly belong to the **same coherent task**
- If the working tree contains unrelated changes:
  - **do not create a mixed commit**
  - explain how changes should be split into multiple commits instead.

One commit should represent **one coherent unit of work**.

## 3. Writing the Commit Message

For each commit:

- **Why** — bullets explaining the motivation or problem being solved.
- **What** — bullets summarizing changes at a meaningful level (e.g. "add ParseExerciseSkill for phrase → set structure", "update session persistence", "add tests for confirmation flow").
- **Validation** — bullets listing checks actually run (e.g. `npm test`, `pnpm lint`, manual workflow verification). Do not invent validation that did not run.

## 4. Quality Bar

A good commit:
- is a single coherent change
- has a clear type and scope
- has a short, meaningful summary
- includes accurate **Why/What/Validation** sections

Avoid:
- mixed-purpose commits
- vague summaries like "update stuff" or "fix issues"
- misleading scopes
- fabricated or omitted validation notes

## Quick Checklist Before Committing

- [ ] Changes staged represent one coherent task.
- [ ] Commit type and scope reflect the main area touched.
- [ ] Summary is short, imperative, and outcome-oriented.
- [ ] Why / What / Validation sections are accurate and concise.
- [ ] No unrelated changes are bundled into this commit.

## Reference in this Repo

- Commit command rules: `.cursor/commands/commit.md`
