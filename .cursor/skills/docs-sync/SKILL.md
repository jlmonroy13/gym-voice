---
name: docs-sync
description: >-
  Ensures documentation stays aligned with behavior, scope, architecture, and
  voice-pipeline/data-integrity in GymVoice. Use when a change may affect product scope,
  voice pipeline behavior, architecture, processes, or other documented
  assumptions.
---

# Documentation Sync (GymVoice)

This skill applies the repository **Documentation Update Rules** so implementation and docs stay aligned.

## When to Use

Use this skill when:
- a PR changes behavior, scope, architecture, or operating assumptions
- reviewing a PR that likely affects docs
- deciding whether additional doc work is needed before marking an issue done

## Core Rule

When behavior, scope, structure, or operating assumptions change, **evaluate documentation impact immediately**.
Do not leave doc updates as an undefined future task if the change makes existing docs inaccurate.

## 1. Decision Questions

Before finalizing work, ask:
1. Did the scope of the product or MVP change?
2. Did supported behavior change?
3. Did a voice-pipeline or data-integrity rule or assumption change?
4. Did architecture, boundaries, workflow orchestration, or state semantics change?
5. Did an important operational assumption change?
6. Did a major tradeoff get made that future contributors should understand?

If **yes** to any, documentation likely needs updating.

## 2. Primary Documentation Sources

Core project docs that may need updates:
- `PROJECT.md`
- `docs/product/PRD.md`
- `docs/architecture/SOLUTION_DESIGN.md`
- `docs/architecture/STACK.md`
- `docs/process/DEFINITION_OF_DONE.md`
- `docs/process/TASK_EXECUTION_WORKFLOW.md`
- `docs/planning/MILESTONES.md`
- `docs/planning/MVP_PLAN.md`
- `docs/architecture/adr/` (ADRs)
- `docs/architecture/# GymVoice – Business Logic.md` — user flow, business rules, data stored, special cases
- `docs/architecture/# GymVoice – Technical Documentation.md` — stack, structure, agents, skills, testing strategy

Treat these as living artifacts.

## 3. What to Update Where

- **`PROJECT.md`** — update when changes affect:
  - repository mission, operating principles, high-level scope
  - non-negotiables or working model of the repo
  - major product framing or expectations for contributors/agents

- **`docs/product/PRD.md`** — update when changes affect:
  - product goal or target users
  - MVP scope or included/excluded capabilities
  - milestone framing or success criteria
  - important product-level risks or direction

- **`docs/architecture/SOLUTION_DESIGN.md`** — update when changes affect:
  - module boundaries or core data flow
  - layer responsibilities or state lifecycle (session, set)
  - orchestration, persistence, or error-handling structure
  - voice pipeline or agent/skill boundaries

- **`docs/architecture/STACK.md`** — update when changes affect:
  - language, runtime, framework, database, or tooling decisions

- **`docs/process/DEFINITION_OF_DONE.md`** — update when changes affect:
  - validation expectations
  - review/merge-readiness standards
  - quality gates or completion standards for certain work types

- **`docs/process/TASK_EXECUTION_WORKFLOW.md`** — update when changes affect:
  - steps before starting, during execution, or when closing a task
  - checklist items or readiness criteria

- **`docs/planning/*`** — update when changes affect milestone outcomes, implementation order, or MVP boundary.

- **ADRs (`docs/architecture/adr/`)** — create or update when:
  - a meaningful architectural tradeoff was made
  - a significant design decision needs durable memory
  - long-term structure, not just local implementation, is affected

- **Domain docs (`# GymVoice – Business Logic.md`, `# GymVoice – Technical Documentation.md`)** — update when:
  - user flows, business rules, or data stored change (Business Logic)
  - stack, structure, agents, skills, or testing strategy change (Technical Documentation)

## 4. PR Expectations Around Documentation

For PRs that affect docs, the PR should clearly indicate one of:
- **Docs updated** — references to specific files.
- **Docs not needed** — with a clear reason.
- **Follow-up doc issue** — only if deferral is truly acceptable.

Do not silently omit docs when project understanding changed.

## Quick Checklist for Docs Sync

- [ ] Checked whether scope, behavior, architecture, or voice-pipeline/data-integrity assumptions changed.
- [ ] Identified which core docs (PROJECT, PRD, SOLUTION_DESIGN, STACK, DoD, TASK_EXECUTION_WORKFLOW, planning, domain docs, ADRs) are impacted.
- [ ] Updated the relevant docs or documented why no updates are required.
- [ ] In PR description, made the documentation impact explicit.

## References in this Repo

- Documentation update rules: `.cursor/rules/00-core/03-documentation-update-rules.mdc`
- Project contract: `PROJECT.md`
- Product PRD: `docs/product/PRD.md`
- Solution design: `docs/architecture/SOLUTION_DESIGN.md`
- Definition of Done (process): `docs/process/DEFINITION_OF_DONE.md`
