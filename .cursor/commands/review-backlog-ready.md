# Review Backlog and Promote Ready Issues

You are responsible for **reviewing all issues in the Backlog** of the GitHub project, **moving to "Ready"** only those that meet the ready criteria **and have no dependencies on other issues that are not complete**, and **recommending which issue is the best next task** considering project scope and dependencies.

Run this command when the user wants to:
- Triage backlog issues into Ready
- Know which issue to pick next for implementation

---

## Goal

1. **List** all issues currently in **Backlog** on the GymVoice project board.
2. **Evaluate** each Backlog issue against the "when an issue is ready" criteria.
3. **Resolve dependencies**: for each issue that meets the ready criteria, identify dependencies (e.g. "Depends on #N", "Blocked by #N"). Only treat an issue as **eligible to move to Ready** if it has **no dependencies on other issues that are not complete** (i.e. every dependency issue is closed or in Done on the board).
4. **Move** to **Ready** only those Backlog issues that are ready **and** have all dependencies satisfied (using `gh` CLI).
5. **Recommend** the single issue that is most convenient to do next, considering:
   - Project scope (MVP and `docs/planning/MILESTONES.md`, `PROJECT.md`, `.cursor/rules/00-core/01-project-goal-and-scope.mdc`)
   - Dependencies between issues (e.g. "Depends on #N" — prefer issues whose dependencies are already Done or closed)
   - Milestone order (M1 before M2 before M3 before M4 for MVP)
   - No hidden blockers or vague scope

---

## Input

- The user runs this command (e.g. "run review-backlog-ready" or "revisa el backlog y mueve a ready los que estén listos").
- No issue number or URL is required; you operate on the full Backlog of the project.

---

## Constraints and References

- **When an issue is ready:** `.cursor/rules/110-planning/115-when-an-issue-is-ready.mdc`
- **Acceptance criteria quality:** `.cursor/rules/110-planning/111-acceptance-criteria-rules.mdc`
- **GitHub workflow:** `.cursor/skills/github-workflow/SKILL.md`
- **Project scope and MVP:** `.cursor/rules/00-core/01-project-goal-and-scope.mdc`, `docs/planning/MILESTONES.md`, `PROJECT.md`
- **Tooling:** Prefer **gh CLI** for all project board writes (`.cursor/rules/00-core/04-github-tooling-precedence.mdc`).

---

## Step 1: Verify Environment and Load Project Data

1. **Verify gh authentication**
   - Run `gh auth status`. If not authenticated or missing `project` scope, tell the user to run `gh auth login` and `gh auth refresh -s project`, then stop.

2. **Get project fields and status option IDs**
   - Run: `gh project field-list 3 --owner jlmonroy13 --format json` (GymVoice project number 3; adjust if different).
   - From the **Status** field (name `"Status"`), extract the option IDs for:
     - **Backlog**
     - **Ready**
   - Note the Status **field id**. You will use it when moving items to Ready.

3. **List all project items**
   - Run: `gh project item-list 3 --owner jlmonroy13 --limit 100 --format json`
   - Parse the JSON and separate items by **status**:
     - **Backlog** — issues to evaluate and possibly move to Ready
     - **Ready** — issues already ready; these are candidates for "best next" along with any you move in this run
   - From each item keep: `id` (project item id), `content.number` (issue number), `content.title`, status. For detailed evaluation you will fetch the full issue body with `gh issue view <number>`.

4. **Project and repo**
   - Repository: `jlmonroy13/gym-voice`
   - Project board: https://github.com/users/jlmonroy13/projects/3/views/1?layout=board
   - Project ID for `gh project item-edit`: from the same project (e.g. from `scripts/task-start.sh` or project URL). If in doubt, derive from the project URL or reuse the value from `task-start.sh` if it sets `GITHUB_PROJECT_ID`.

---

## Step 2: Evaluate Each Backlog Issue

For **each** issue currently in **Backlog**:

1. **Fetch full issue body**
   - Run: `gh issue view <number> --repo jlmonroy13/gym-voice --json number,title,body,state`
   - If the issue is closed (`state` is not OPEN), skip it (do not move to Ready).

2. **Apply "when an issue is ready" criteria** (from `.cursor/rules/110-planning/115-when-an-issue-is-ready.mdc`):
   - **Ready when:** objective clear, scope bounded, out-of-scope explicit where needed, dependencies visible, acceptance criteria meaningful, relevant ambiguity addressed, supports current MVP.
   - **Not ready when:** vague, bundles multiple outcomes, weak AC, missing dependencies, key decisions unresolved, relies on tribal knowledge.

3. **Resolve dependencies (required for moving to Ready)**
   - From the issue body, identify any dependency references (e.g. "Depends on #N", "Blocked by #N"). For each referenced issue number:
     - Fetch its state: `gh issue view <N> --repo jlmonroy13/gym-voice --json state` and, from the project item-list, whether that issue is in **Done** on the board.
     - A dependency is **satisfied** only if the referenced issue is **closed** (merged) or in **Done** on the project board. If it is in Backlog, Ready, or In progress, the dependency is **not satisfied**.
   - An issue is **eligible to move to Ready** only if it meets the ready criteria **and** has **no dependencies on other issues that are not complete** (all dependency issues are closed or Done).

4. **Decide**
   - If the issue **meets** the ready criteria **and** all its dependencies are satisfied → you will move it to **Ready** in Step 3 and include it in the "best next" candidate set.
   - If the issue **does not** meet the criteria → leave it in Backlog; in your final summary, list it and briefly state what is missing (e.g. "weak AC", "dependencies unclear", "scope too broad").
   - If the issue meets the criteria **but** has at least one unsatisfied dependency → leave it in Backlog; in your final summary, list it and state which dependency is not complete (e.g. "#N — depends on #K which is not Done").

---

## Step 3: Move Ready Issues to "Ready"

For each Backlog issue that you classified as **ready and with all dependencies satisfied** (eligible to move):

1. Use the **project item id** from Step 1 (the item's `id` in the project list).
2. Run:
   ```bash
   gh project item-edit --id <ITEM_ID> --project-id <PROJECT_ID> \
     --field-id <STATUS_FIELD_ID> --single-select-option-id <READY_OPTION_ID>
   ```
   - `PROJECT_ID`: from GymVoice project (e.g. from `scripts/task-start.sh` or project settings).
   - `STATUS_FIELD_ID`: the Status field id from Step 1.
   - `READY_OPTION_ID`: the option id for "Ready" from Step 1.

3. If `gh project item-edit` fails (e.g. permissions), report to the user and suggest moving those issues to Ready manually on the board.

After this step, the set of issues in **Ready** is: previous Ready items plus all issues you just moved.

---

## Step 4: Recommend the Best Next Issue

From **all issues now in Ready** (including ones that were already Ready and ones you moved):

1. **Dependencies**
   - For each issue, check the body for "Depends on #N", "Blocked by #N", or similar. Resolve issue #N: if it is closed (merged) or in Done on the board, the dependency is satisfied.
   - Prefer issues whose dependencies are **all satisfied**. If an issue depends on another that is still Backlog or In progress, do not recommend it as the very next task unless you explicitly state that the dependency should be completed first.

2. **Milestone and scope**
   - Use `docs/planning/MILESTONES.md` and `PROJECT.md` / `.cursor/rules/00-core/01-project-goal-and-scope.mdc` to prefer issues that:
     - Belong to the current or next logical milestone (e.g. M1 before M2 before M3 before M4).
     - Directly support the MVP (session lifecycle, voice pipeline, persistence, history, auth, data integrity).
   - Avoid recommending issues that are out of scope or that assume work that is not yet done.

3. **Pick one**
   - Choose **one** issue as the **recommended next task**.
   - If there are no Ready issues or all have unsatisfied dependencies, say so and suggest either: (a) complete the blocking issue(s) first, or (b) refine a Backlog issue so it can be moved to Ready.

4. **Justify briefly**
   - In 2–4 sentences, explain why this issue is the most convenient next (e.g. dependencies satisfied, aligns with current milestone (M1–M4), small and well-scoped, unblocks others).

---

## Step 5: Report to the User

Produce a clear summary in **English** (or in the same language the user used), structured as follows:

1. **Backlog review**
   - How many issues were in Backlog.
   - How many you **moved to Ready** (list issue numbers and titles). Only issues that were ready and had no dependencies on incomplete issues were moved.
   - How many you **left in Backlog** and why (list issue numbers and short reason per issue, e.g. "#N — weak AC", "#M — depends on #K which is not Done").

2. **Best next task**
   - **Recommended issue:** #X — Title
   - **Why:** (short justification: dependencies, milestone, scope).

3. **Optional**
   - Link to the project board: https://github.com/users/jlmonroy13/projects/3/views/1?layout=board
   - If no issue could be recommended, what to do next (e.g. run this command again after closing a dependency, or refine a specific Backlog issue).

---

## Final Rules

- Do **not** move closed issues to Ready.
- Do **not** move to Ready any issue that depends on another issue that is not complete (closed or in Done). Only move issues with no unsatisfied dependencies.
- Do **not** guess intent for vague issues; leave them in Backlog and state what is missing.
- Use **gh CLI** only for project board updates; do not mix with GitHub MCP for the same write workflow.
- Keep the recommendation aligned with the repository's MVP and milestone order; do not suggest out-of-scope or speculative work as the next task.
