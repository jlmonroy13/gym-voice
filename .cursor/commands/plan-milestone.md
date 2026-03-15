You are responsible for executing the **entire milestone planning workflow** for a
single MVP milestone in **one command run**: understand the milestone → read core
docs and rules → decompose into epics and issues → auto‑refine acceptance
criteria and scope → create or refine the actual GitHub issues (not just commands)
and ensure their project fields are populated for execution.

You must **not** stop after a rough list of ideas.
You must leave the user with a **reviewable, execution‑ready plan** that they
can apply with minimal extra work (ideally just running the generated commands).

---

## Single‑run rule (mandatory)

This command completes in **one** run:

1. Resolve which milestone to plan (e.g. `M1 - Foundation`, `M2 - Voice pipeline and session`).
2. Read all relevant planning, product, and architecture docs.
3. Discover and read any **existing GitHub issues** already assigned to this
   milestone.
4. Derive the milestone **outcome and deliverables** in your own words.
5. Decompose the milestone into **epics** and **issues**, **re‑using and
   refining existing issues where possible instead of duplicating them**.
6. Auto‑review and refine:
   - scope and sizing of each issue
   - acceptance criteria quality
   - architecture and voice-pipeline alignment
   - overlap and gaps between existing and new issues
7. Produce and apply:
   - a **milestone plan** in markdown (epics, issues, dependencies, AC), clearly
     marking which issues are **existing** vs **new**
   - a set of **GitHub‑ready issue bodies** following the feature template for
     any **new or heavily‑refined** issues
   - the **actual creation of all new issues in GitHub** using `gh issue create`
     (no separate user approval step required)
   - the **automatic assignment** of project fields (Status, and any other fields the project has) for all issues in the milestone in the primary project (GymVoice, project number 3).

Do **not** stop after step 4 with only a rough list.
Do **not** ask the user to invent or refine acceptance criteria manually.
You must perform steps 2–6 in this same command run.

You **must** execute the necessary `gh` commands yourself in this command:

- `gh issue create` to create any **new** issues for the milestone.
- `gh issue edit` when you need to refine existing issues that are classified as
  **REFINE**.
- `gh project item-add` / `gh project item-edit` (or equivalent `gh api` calls)
  to populate project fields for all issues in the milestone.

The user should not have to run any additional `gh` commands just to create these
issues or fill in project fields.

---

## Goal

Given a milestone identifier:

1. Produce a **complete, coherent, and constrained** plan for that milestone,
   expressed as epics and issues aligned with the MVP and project rules.
2. Ensure each issue is:
   - sized reasonably
   - has explicit, verifiable acceptance criteria
   - follows the repository's structure and voice-pipeline/domain rules
3. Leave the user with:
   - one **markdown plan** they can commit under `docs/planning/` if they wish
   - a set of **issue bodies** that match the issues you already created/updated
     in GitHub using the Feature template (if present) or the repo's issue standards
   - an **optional, informational `bash` block** of `gh issue create` and
     `gh issue edit` commands purely for traceability (not for the user to run).

The user should only need to:

- run this command with the milestone name, and
- (optionally) review the output and the created issues/project fields.

---

## Input

- The user will either:
  - provide the **exact milestone title** (e.g. `"M2 - Voice pipeline and session"`),
  - reference the shorthand (e.g. `"M2"`), or
  - ask you to plan "the next milestone" (you must resolve which that is from
    `MILESTONES.md`).
- You must confirm which milestone you are using in your own words at the top
  of the output.

If you cannot unambiguously resolve the milestone from the user's wording and
`docs/planning/MILESTONES.md`, ask the user to clarify **before** planning.

---

## Constraints and References

You must treat this as **planning in a data-integrity and voice-pipeline–sensitive repository**.
Before decomposing, you **must** read or at least skim:

- Milestones and MVP structure:
  - `docs/planning/MILESTONES.md`
  - `docs/planning/MVP_PLAN.md`
- Core product and scope:
  - `PROJECT.md`
  - `docs/product/PRD.md`
- Architecture and boundaries:
  - `docs/architecture/SOLUTION_DESIGN.md`
  - `docs/architecture/STACK.md`
  - `.cursor/rules/30-architecture/31-domain-vs-voice-boundary.mdc`
- Planning and acceptance criteria:
  - `.cursor/rules/110-planning/114-milestone-and-epic-structure.mdc`
  - `.cursor/rules/110-planning/111-acceptance-criteria-rules.mdc`
  - `.cursor/rules/110-planning/112-issue-sizing-rules.mdc`
  - `.cursor/rules/110-planning/115-when-an-issue-is-ready.mdc`
- Core operating and sensitive-area rules:
  - `.cursor/rules/00-core/00-repo-operating-contract.mdc`
  - `.cursor/rules/00-core/01-project-goal-and-scope.mdc`
  - `.cursor/rules/70-persistence/70-persistence-principles.mdc` (if the milestone touches persistence)
  - `.cursor/rules/100-review/103-voice-sensitive-review-rules.mdc`
- Issue and PR process:
  - `.github/ISSUE_TEMPLATE/feature.md` (if present)
  - `.cursor/skills/task-execution-workflow/SKILL.md`
  - `.cursor/skills/github-workflow/SKILL.md`
  - `.cursor/skills/definition-of-done/SKILL.md`

You must also inspect existing issues for the target milestone using `gh`:

- `gh issue list --repo jlmonroy13/gym-voice --milestone "<Milestone title>" --state all`
- `gh issue view <number>` for any candidate issue you may want to re‑use or refine.

You must respect these boundaries and rules when proposing issues.

---

## Step 1: Resolve and Restate the Milestone

1. Resolve the milestone from user input and `docs/planning/MILESTONES.md`.
2. Restate, in your own words:
   - **Description** of the milestone.
   - **Expected outcome** (what the system can do when the milestone is done).
   - **Deliverables** listed in `MILESTONES.md` for that milestone.
3. Make clear what is **in scope** and explicitly **out of scope** for this
   milestone based on:
   - `MILESTONES.md`
   - `MVP_PLAN.md`
   - `PROJECT.md` / `PRD.md`.

Do not skip this restatement; it anchors the rest of the plan.

---

## Step 2: Understand Existing Issues for This Milestone

Before proposing new work, you must understand what already exists in GitHub.

1. Use `gh issue list` (read‑only) to list all issues assigned to this
   milestone, including closed ones.
2. For each existing issue that is clearly in scope for this milestone:
   - Extract its current: title, objective/scope (from the body), acceptance criteria (if present).
   - Classify it into one of:
     - **KEEP‑AS‑IS** — already well‑scoped and ready to execute.
     - **REFINE** — structurally correct but needs better AC or clearer scope.
     - **OUT‑OF‑SCOPE** — belongs to a different milestone; call this out.
3. In your final plan, you must:
   - include existing issues that are KEEP‑AS‑IS or REFINE in the epics and issues tables,
   - explicitly mark them as **existing** and show their GitHub number,
   - avoid creating new issues that duplicate their intent.

---

## Step 3: First Decomposition into Epics and Issues

Using the milestone description plus architecture docs **and the classification
of existing issues**:

1. Propose **2–5 epics** for this milestone.
   - Each epic must represent a **meaningful capability**, not a vague bucket.
   - Examples for M1: `Project setup`, `Auth`, `Basic API`, `Repo workflow`.
   - Examples for M2: `Voice pipeline (parsing)`, `Session lifecycle`, `Set persistence`, `Confirmation flow`.
2. Under each epic, propose **concrete issues**.
   - Start by placing existing KEEP‑AS‑IS / REFINE issues into appropriate epics.
   - Only then propose **new** issues to cover remaining gaps.
   - Aim for a reasonable total (e.g. ~5–12 issues per milestone depending on size).
   - Each issue should be: focused on one main area (API, Application, Domain, Voice pipeline, Persistence, UI, Testing, Documentation), aligned with issue-sizing rules.
3. For each issue (existing or new), define at minimum:
   - **Proposed title**
   - 2–3 sentence **Objective**
   - 1–3 sentence **Why**
   - Short **Scope** bullets (In scope vs Out of scope)
   - **Relevant Area**
   - **Dependencies** on other issues in this milestone

At this stage you are allowed to be slightly rough, but titles and objectives
must already be executable, not vague.

---

## Step 4: Auto‑Review: Scope, Sizing, and Acceptance Criteria

Now you must act as your own planning reviewer and refine the issues without
asking the user to do it.

1. Apply `.cursor/rules/110-planning/112-issue-sizing-rules.mdc`:
   - Identify issues that are too large, mixing multiple concerns, or too trivial.
   - Split or merge as needed.
2. Apply `.cursor/rules/110-planning/111-acceptance-criteria-rules.mdc`:
   - For each issue, draft **Acceptance Criteria** that are explicit, testable, outcome‑oriented, verifiable.
   - Avoid vague AC. For GymVoice, prefer criteria like "Given phrase X, ParseExerciseSkill returns Y" or "Given incomplete set, app asks for confirmation and does not save until confirmed."
3. For each issue, define a **Validation** section: which checks are expected (unit tests, integration tests, manual verification).

After this step, each issue (existing or new) should feel like a **ready feature issue**.

---

## Step 5: Architecture and Voice-Pipeline Alignment Review

Review the proposed issues against architecture and data-integrity rules.

1. Check each issue against:
   - `docs/architecture/SOLUTION_DESIGN.md`
   - `.cursor/rules/30-architecture/31-domain-vs-voice-boundary.mdc`
   - `.cursor/rules/70-persistence/70-persistence-principles.mdc` (if relevant)
2. For each issue, ask:
   - Does this keep **domain vs voice pipeline** separation intact?
   - Does it respect **layer boundaries** (API vs Application vs Domain vs Voice pipeline vs Persistence)?
   - Does it make **state and persistence effects explicit** where needed?
3. If an issue mixes layers or sensitive concerns, rewrite Scope or split into separate issues.

---

## Step 6: GitHub‑Ready Issue Bodies

Using `.github/ISSUE_TEMPLATE/feature.md` if present (or the repo's issue standards), generate **full bodies for new issues** and **proposed revised bodies for existing REFINE issues**.

For every planned issue, fill: Objective, Why, Problem/Context, Scope, Dependencies, Proposed Behavior, Acceptance Criteria, Validation, Documentation Impact, Notes.

Organize as separate markdown snippets (e.g. `.tmp/<milestone>-issue-NEW-XX.md`, `.tmp/<milestone>-issue-EXISTING-<number>.md`).

---

## Step 7: Create / Update Issues and Assign Project Fields (GitHub‑Backed)

Apply the plan directly in GitHub in this same command run.

1. Assume:
   - Repository: `jlmonroy13/gym-voice`.
   - Milestone title: exactly as in `MILESTONES.md`.
   - Primary project: GymVoice (project number 3 for owner jlmonroy13).
2. For each **new** issue: `gh issue create` with title, body, labels, milestone; add to project with `gh project item-add` or equivalent.
3. For each **existing** issue classified as **REFINE**: `gh issue edit <number> --body` (or `--body-file`).
4. For **all** issues in the milestone: ensure they are on the project and populate Status (and any other fields the project uses: Priority, Size, Area, etc.) via `gh project item-edit`.

Emit an informational **bash block** of the commands you ran for traceability.

---

## Output Format (What You Show to the User)

1. **Milestone Summary** — Name, description, expected outcome, deliverables.
2. **Epics Overview** — Short table or bullet list of epics.
3. **Issues Table** — Compact table: #, Title, Epic, Area, Dependencies, Existing/New.
4. **Issue Bodies** — One subsection per issue with full GitHub-ready body.
5. **Bash Block (Informational)** — Commands executed for traceability.
6. **Optional Project Field Summary** — Status and other fields assigned per issue.

---

## Important Behavior Rules

- **Do not expand scope beyond the milestone.**
- **Prefer fewer, clearer issues over many tiny ones.**
- **Respect data integrity and voice-pipeline boundaries.** Ensure issues that touch parsing, persistence, or auth have AC and Validation that make behavior explicit and testable.
- **Stay consistent with MVP order** (MILESTONES.md, MVP_PLAN.md).
