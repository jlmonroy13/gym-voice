# Scripts

Optional helpers for the repository task execution workflow.

## Task execution (GitHub issues)

| Script | Purpose |
|--------|--------|
| `task-start.sh <N>` | Create branch `issue/N-title-slug` for issue #N and move the issue to "In progress" on the project board (if the issue is on the project and the script is configured with project/field IDs). If project automation is not set up, the script reminds you to move the issue manually. |
| `task-pr.sh [N]` | Open a PR for the current branch with "Closes #N". If `N` is omitted, it is inferred from the branch name (`issue/N-...`). |
| `task-done.sh [N]` | After merging, remind to move issue #N to "Done" (or rely on Project automation). |

**Requirements:** `gh` CLI installed and authenticated (`gh auth status`). For moving issues on the project board, `task-start.sh` may need the `project` scope: run `gh auth refresh -s project` if you get permission errors. Repository default: `jlmonroy13/gym-voice` (override with `GITHUB_REPO`). Optional: `jq` for parsing GraphQL responses when updating the board (if the script is extended to auto-move like dian-api).

**Full process:** See [docs/process/TASK_EXECUTION_WORKFLOW.md](../docs/process/TASK_EXECUTION_WORKFLOW.md).
