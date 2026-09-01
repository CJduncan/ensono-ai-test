# One-time setup: turn on the branch gates

Pushing this repo gives you the branches and the CI. What it *cannot* set from
code alone is branch protection — that lives in repo settings. Do this once.

CI (the workflows) runs the moment the files are on GitHub. Branch protection is
what makes a failing check actually **block** a merge. Until you turn it on,
checks run but merging is not enforced.

## Option A — import the ruleset (fastest)

1. Repo → **Settings** → **Rules** → **Rulesets** → **New ruleset** →
   **Import a ruleset**.
2. Choose `.github/rulesets/develop-main-protection.json` from this repo.
3. **Create**. Done — `develop` and `main` now require a PR and a green
   `ci-status` check, and block force-push and deletion.

## Option B — by hand

Settings → **Branches** → **Add branch ruleset** (or classic branch protection),
targeting `develop` and `main`, with:

- **Require a pull request before merging** (0 approvals is fine for a solo
  sandbox; set 1+ and "require review from Code Owners" for a real team repo).
- **Require status checks to pass** → add **`ci-status`**. Tick "Require
  branches to be up to date before merging".
- **Block force pushes** and **Restrict deletions**.

## After it's on

- Set **`develop`** as the default branch (Settings → General → Default branch)
  so new PRs target it automatically.
- Try it: edit `projects/hello-service/src/example.py` on a branch, open a PR
  into `develop`, watch **CI** run in the Checks tab, and confirm Merge is
  blocked until it's green.

## Notes / known edges

- A PR opened by the **Scaffold new project** workflow uses the built-in
  `GITHUB_TOKEN`, and GitHub deliberately does **not** trigger CI on commits made
  by that token (loop-prevention). The scaffold PR will show no checks; the next
  human commit to that branch runs CI normally. If you want CI on bot PRs, swap
  in a fine-grained PAT or a GitHub App token.
- For the real Ensono repo, bump required approvals to 1 and enable Code Owner
  review so a project's owner signs off on changes to their folder.
