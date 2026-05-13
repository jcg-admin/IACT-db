# develop Merge Regression Analysis (Nov 2025)

## Context
- Reported symptom: after merging the latest `develop` into the working branch, all Copilot-agent documentation rewrites appeared to vanish.
- Investigation performed from commit `0c92951` (`work` branch head) to understand where the content lives and how the merge workflow handled conflicts.

## Evidence Collected
1. `git log --graph --oneline --decorate` shows the local branch contains commit `0c92951` on top of merge `33db249`, while `develop` only carries the merge commit. This means the tagged-agent rewrite lives exclusively in `0c92951`, so any merge that ignores this commit will surface the old state. *(command output reference: `git log --graph --oneline --decorate | head -n 40`).*【312303†L1-L24】
2. `MERGE_STRATEGY_PR_175.md` mandates that every conflicting file must prefer `--theirs` (the Claude/develop version) and even states "**REGLA DE ORO**: siempre elegir --theirs". Following those steps inherently discards any local edits inside `.github/agents/` when they diverge from `develop`. 【F:MERGE_STRATEGY_PR_175.md†L50-L169】
3. The automation script `execute_merge_strategy.sh` implements the same policy: when conflicts occur it loops through each file and runs `git checkout --theirs "$file"` before committing the merge. That hard-codes "take remote/develop" for every conflict, guaranteeing that local changes disappear if the same paths were edited upstream. 【F:execute_merge_strategy.sh†L79-L107】

## Root Cause
The merge workflow purposefully resolves conflicts by discarding the current branch (`--ours`) and accepting whatever lives in `develop`/Claude (`--theirs`). Because the Copilot-agent overhaul only exists in commit `0c92951`, merging `develop` with that policy removes the rewrite and leaves the repository in the pre-overhaul state, which looks like the changes "disappeared" even though the commit still exists locally.【312303†L1-L24】

## Recovery & Prevention
1. **Recover the rewrite**
   - Stay on the feature branch (e.g., `work`).
   - Reapply the missing commit onto `develop` once conflicts are resolved: `git checkout develop && git cherry-pick 0c92951` (or merge the branch without the forced `--theirs`).
   - Push the updated `develop` so the tagged-agent docs are part of the shared history.
2. **Update merge practice**
   - Only fall back to `git checkout --theirs` when you are certain the remote version is correct. For documentation-heavy branches, resolve conflicts manually or favor `--ours` where appropriate so local work is preserved.
   - Consider replacing the blanket rule in `MERGE_STRATEGY_PR_175.md` with file-by-file guidance, or prompt the script to ask whether each conflict should take `--ours`/`--theirs` before executing.
3. **Validate before pushing**
   - After merging develop, run `git log --graph --decorate -n 5` to ensure the commits you expect are still on top.
   - Inspect `.github/agents/` diff before pushing; if the directory suddenly matches develop, the local rewrite was dropped and needs to be restored from `0c92951` or another saved branch/reflog entry.
