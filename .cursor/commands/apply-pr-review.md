You are responsible for **processing PR review comments on an existing pull request end-to-end**: load the PR, decide which reviewer suggestions are worth applying, make code changes, validate, and push a single commit back to the PR branch.

The input to this command is a **GitHub pull request URL** for this repository, e.g. `https://github.com/jlmonroy13/gym-voice/pull/8`.

Your job is to:

1. Load the PR and its review comments (from any reviewer: human, bot, or other agent).
2. Decide which comments are **useful and necessary** vs. which are noise or preference-only.
3. Apply only the suggestions that improve correctness, clarity, test coverage, or documentation **without breaking repository rules**.
4. Ignore suggestions that are incorrect, conflict with existing conventions, or expand scope.
5. Validate the changes, create a coherent commit, and push back to the same branch.

You must follow the repository's **review, testing, and commit rules** while doing this.

---

## Input

- The user will call this command and provide a PR URL, for example:
  - `run apply-pr-review for https://github.com/jlmonroy13/gym-voice/pull/8`
- From the URL you must:
  - extract the **repository** (`jlmonroy13/gym-voice`), and
  - extract the **PR number** (`8` in the example).
- If the URL is missing or malformed and you cannot infer the PR number, ask the user to provide a valid PR URL **before** doing anything else.

---

## Constraints and References

You must respect these rules and skills:

- **GitHub workflow:** `.cursor/skills/github-workflow/SKILL.md`
- **Commit workflow:** `.cursor/skills/commit-workflow/SKILL.md`
- **PR review:** `.cursor/skills/pr-review/SKILL.md`
- **Testing strategy:** `.cursor/rules/90-testing/90-testing-strategy-overview.mdc`
- **Definition of Done:** `.cursor/skills/definition-of-done/SKILL.md`, `docs/process/DEFINITION_OF_DONE.md`
- **Voice-sensitive & persistence rules:** `.cursor/rules/100-review/103-voice-sensitive-review-rules.mdc`, `.cursor/rules/70-persistence/70-persistence-principles.mdc`
- **PR scope & blocking rules:** `.cursor/rules/100-review/*`
- **Core project rules:** `PROJECT.md`, `docs/architecture/SOLUTION_DESIGN.md`

You must:

- prefer **correctness, traceability, and data-integrity safety** over blindly accepting suggestions
- keep changes **scoped to addressing the PR review comments** only
- avoid turning this command into a general refactor pass

---

## Step 1: Resolve PR and Environment

1. Parse the PR URL:
   - repository: should be `jlmonroy13/gym-voice` for this repo
   - PR number: `N`
2. Verify GitHub CLI authentication:
   - Run `gh auth status` and stop with an explanation if auth fails.
3. Load PR metadata:
   - Run `gh pr view N --json number,title,headRefName,baseRefName,body,url,author` to get:
     - PR title and description
     - head branch name (the branch you will check out)
4. Ensure you are on the correct local repository and branch:
   - From the repo root, run `git status` and confirm the working tree is clean.
   - Check out the PR branch (e.g. `git checkout <headRefName>`).
   - If there are local uncommitted changes, **stop and explain** instead of mixing them with review fixes.

---

## Step 2: Collect PR Review Comments

1. Fetch review comments using `gh`:
   - Prefer a JSON format, e.g. `gh api repos/jlmonroy13/gym-voice/pulls/N/comments` or `gh pr view N --comments` and/or review comments API to get all comments on the PR (body, author, path, line, etc.).
2. Include **all** review comments (from any reviewer); you will filter by usefulness in the next step, not by author.
3. Group comments by file and location (path + line range) to avoid handling the same snippet multiple times.
4. Ignore:
   - comments that have been **marked as resolved** already, if that information is available
   - comments on files that no longer exist or whose relevant code has changed substantially since the comment (you will detect this in Step 3).

If there are **no remaining review comments** to process, stop and tell the user that there is nothing to apply.

---

## Step 3: Decide Which Comments to Apply

You must **not** apply reviewer suggestions blindly.

For each remaining comment:

1. Load the relevant code:
   - Use `Read`/`Grep` tools to open the file mentioned in the comment.
   - Navigate to the lines indicated by the comment.
2. Understand the suggestion:
   - Does it propose a concrete code change (e.g. fix bug, simplify, add null check, adjust types, improve tests)?
   - Or is it just a vague or stylistic note?
3. Evaluate the suggestion using project rules:
   - **Apply** the comment only if it clearly **improves** at least one of:
     - correctness or bug risk
     - clarity/readability in a way consistent with existing style
     - test coverage or validation quality
     - documentation or comments for non-obvious behavior
   - **Reject/ignore** the comment if:
     - it conflicts with architecture or layering rules (e.g. pushes voice-API logic into domain)
     - it expands the PR scope beyond the original issue
     - it weakens data integrity, traceability, or confirmation flow
     - it is purely personal style or formatting that conflicts with existing conventions
     - it misinterprets the code or domain/voice-pipeline rules
4. For voice-pipeline–sensitive and persistence-sensitive areas (parsing, grouping, validation, session/set persistence, auth):
   - Be stricter: only apply suggestions that **align with** SOLUTION_DESIGN and the voice-sensitive review rules.
   - If the suggestion changes behavior in these areas, cross-check with `.cursor/rules/100-review/103-voice-sensitive-review-rules.mdc` and the testing strategy.

When you **reject** a comment:

- Do not change the code just to satisfy it.
- Plan to leave a short explanation in the PR comment reply (Step 6).

---

## Step 4: Apply Accepted Suggestions Safely

For each comment you decided to **apply**:

1. Open the affected file with `Read` and confirm the context still matches the original comment (code may have changed since).
2. If the context has changed significantly:
   - Re-evaluate whether the comment is still valid; it might no longer apply.
3. Make the minimal code change needed to satisfy the **intent** of the useful suggestion:
   - Use the repository's existing patterns and naming.
   - Keep cross-layer boundaries intact (domain vs voice pipeline vs API vs persistence, etc.).
4. If the suggested change affects behavior:
   - Consider whether a test should be added or updated, following `.cursor/rules/90-testing/90-testing-strategy-overview.mdc`.
   - Do not silently change behavior without updating or adding tests when it's meaningful for regression.

Always:

- Use **small, understandable edits**.
- Keep the overall PR scope as "Addressing PR review comments for PR N" — do not slip in unrelated refactors.

---

## Step 5: Validate and Commit

After applying all accepted suggestions:

1. Run validation commands appropriate for this repository and the current stack:
   - If the project has been bootstrapped with Node/TypeScript and test tooling, run:
     - dependency install if necessary (e.g. `pnpm install` or `npm install`) — but only if clearly required
     - lint / typecheck / tests (e.g. `pnpm lint`, `pnpm test`, or the scripts defined in `package.json`)
   - If no tooling exists yet (e.g. pure docs-only change), skip code-oriented validation but state that clearly in the commit message.
2. Inspect the diff:
   - Ensure all changes are directly related to review comments you accepted.
   - Confirm there are no stray edits or debug code.
3. Create a **single coherent commit** for these changes:
   - Use the commit workflow format:
     - `fix(pr-review): address PR review comments for PR N`
   - In the body:
     - **Why:** Explain that the commit addresses selected PR review comments, focusing on correctness/clarity/tests.
     - **What:** Summarize the key types of changes (e.g. "adjust null checks in X", "tighten types in Y", "clarify doc in Z").
     - **Validation:** List actual commands run (or state `Not run` only if truly nothing was run and changes are docs-only).
4. Push the commit to the same branch:
   - `git push` (or `git push -u origin <branch>` if needed).

Do **not** create multiple mixed-purpose commits; the entire flow of "address PR review" should be one logical change.

---

## Step 6: Reply to Review Comments (Optional but Recommended)

To keep auditability and review clarity:

1. For each comment you **applied**:
   - Add a short reply in the PR thread via `gh api` or equivalent if available, e.g.:
     - "Applied: updated null handling as suggested."
     - "Applied with slight modification to match existing style."
2. For each comment you **rejected**:
   - Add a brief explanation:
     - "Not applied: conflicts with architecture boundary (domain vs voice pipeline)."
     - "Not applied: would expand PR scope beyond issue #N."
     - "Not applied: behavior is intentional per SOLUTION_DESIGN."
3. **Do not** auto-mark conversations as resolved:
   - Leave final resolution to the human reviewer to avoid hiding concerns prematurely.

If `gh` does not expose a convenient way to reply per-comment, you may skip the replies and instead leave a single PR comment summarizing:

- which categories of suggestions were applied
- which categories were intentionally ignored and why

---

## Step 7: Final Checks and Handoff

Before you finish this command:

1. Ensure:
   - All applied changes are pushed to the PR branch.
   - No unrelated files were modified.
   - The PR still has a clear, coherent scope.
2. Re-apply the **Definition of Done** to the updated PR:
   - Scope still aligned with the issue.
   - Validation remains adequate.
   - No new data-integrity or voice-pipeline risk was introduced by the review changes.
3. Report back to the user:
   - PR URL and branch name.
   - High-level description of what review comments were applied vs rejected.
   - Any validation that was run (or clearly state if none was necessary).

Do **not** merge the PR as part of this command. The merge decision remains with a human reviewer following the PR review rules.
