You are responsible for creating a high-quality git commit for the current changes.

Goal:
Create a commit with a consistent commit-message structure for this repository.

Commit message format:
<type>(<scope>): <short summary>

Why:
- <1-3 concise bullets explaining why this change exists>

What:
- <1-5 concise bullets describing what changed>

Validation:
- <concise bullets describing checks performed, or "Not run" if applicable>

Rules:
1. Inspect the current changes using git diff --staged and git diff.
2. Prefer committing only staged changes if any staged changes exist.
3. If nothing is staged, inspect all current changes and stage only the files that clearly belong to the same coherent task.
4. If the working tree contains unrelated changes, stop and explain the conflict instead of creating a mixed commit.
5. Choose the commit type from this allowed list only:
   - feat
   - fix
   - refactor
   - docs
   - test
   - chore
   - ci
   - build
   - perf
6. Choose the scope from the area most affected by the change, using one concise scope only.
7. The short summary must:
   - be lowercase
   - be imperative in tone
   - be no more than 72 characters if possible
   - describe the main outcome, not the implementation details
8. The Why / What / Validation sections must be concise and accurate.
9. Do not invent validations that were not actually run.
10. If the changes are too broad for one clean commit, do not commit. Instead, explain how the changes should be split.
11. Before committing, show the proposed commit message.
12. Then create the commit.
13. After committing, return:
   - the final commit message
   - the commit hash
   - a one-paragraph summary of what was committed

Quality bar:
- One coherent commit only
- No mixed-purpose commits
- No vague summaries like "update stuff" or "fix issues"
- No misleading scope
- No fabricated validation notes
