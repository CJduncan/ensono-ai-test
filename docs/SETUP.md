# One-time setup: stages + gates

Pushing this repo gives you the branches and the CI. Two things live in repo
settings and must be done by hand, once.

CI (the workflows) runs the moment the files are on GitHub. Branch protection is
what makes a failing check actually **block** a merge.

## 1. Create the `testing` stage

The pipeline has three stages: `develop` (development) → `testing` → `main`
(production). Create the middle one from the current development branch:

- Branch dropdown → type `testing` → **Create branch: testing from develop**, or
- locally: `git checkout develop && git pull && git branch testing && git push -u origin testing`

## 2. Protect all three branches

1. Repo → **Settings** → **Rules** → **Rulesets** → **New ruleset** →
   **Import a ruleset**.
2. Choose `.github/rulesets/develop-main-protection.json` (it now targets
   `develop`, `testing`, and `main`).
3. **Create**. If you imported the earlier two-branch version, delete that
   ruleset first so you don't have two.

Each stage now requires a PR and a green `ci-status` check, and blocks
force-push and deletion.

## 3. Enable the workflows to open branches

Settings → **Actions** → **General** → **Workflow permissions** → check
**"Allow GitHub Actions to create and approve pull requests"** (needed by the
scaffold workflow). The **promote** workflow doesn't need it — it hands you a PR
link to open yourself.

## After it's on

- Keep **`develop`** as the default branch (Settings → General) so new PRs and
  scaffolds target development.
- **Try the promotion flow:** Actions → **Promote a project** → run it with an
  existing project slug and target `testing`. Open the PR link from the run
  summary, watch CI run, merge. Confirm only that project's folder appears on
  `testing`.

## Notes / known edges

- A PR opened by the **Scaffold** workflow uses the built-in `GITHUB_TOKEN`, and
  GitHub does not trigger CI on token-made commits. The **promote** workflow
  sidesteps this by handing *you* the PR link — you open it, so CI runs.
- For the real Ensono repo: bump required approvals to 1 and enable Code Owner
  review; provision a GitHub App token so automation can open PRs directly.
