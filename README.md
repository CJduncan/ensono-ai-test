# ensono-ai-test — pipeline sandbox

A throwaway repo to prototype a GitHub-native delivery pipeline: three
environment stages, automatic testing on every change, a one-click way to
onboard a project, and **opt-in, per-project promotion** toward production.
No production data, no client data — just the mechanics.

## The model

```
                          ┌── promote (owner, on demand) ──┐   ┌── promote ──┐
feature ──PR──▶ development ────────────────────────────▶ testing ────────▶ production
   (your branch)   (everyone lives here)                   (opted-in only)   (opted-in only)
```

Three branches, three stages:

- **`develop` = Development** — the commons. Everyone works here, CI tests every
  change, and a project can **stay here forever**. Experiments and internal
  tools that never need to ship just live in development. Nothing pushes them on.
- **`testing`** — a QA/UAT stage. Holds **only** the projects whose owner chose
  to promote them.
- **`main` = Production** — prod-ready. Holds **only** the projects promoted all
  the way. (Enforced by rulesets, deployed by whatever the platform uses.)

Promotion is **opt-in and owner-initiated** — never automatic. Not everyone who
commits wants to ship, so nobody is dragged toward production.

## Everyday flow (everyone)

1. Branch off `develop`, edit only your `projects/<slug>/` folder.
2. Open a PR into `develop`. CI tests **just your project** + a secret scan.
3. Green gate + review → merge. You're done — you can stop here indefinitely.

## Promoting a project (only when you want to)

Actions tab → **Promote a project** → **Run workflow** → your project slug +
target stage (`testing` or `production`). It:

1. copies **only your project's folder** from the source stage up to the target,
2. pushes a `promote/<slug>-to-<stage>` branch, and
3. hands you a **PR link** in the run summary.

You open that PR (deliberate, and so CI runs on it), it gets reviewed and gated,
and merging is what actually promotes. Because only your folder moves, other
people's experiments never ride along.

## Adding a project

Actions tab → **Scaffold new project** → **Run workflow** → name + owner. It
copies `projects/_template/`, wires CODEOWNERS, and opens a PR into `develop`.

## How testing works

`.github/workflows/ci.yml` runs on every PR into `develop`/`testing`/`main` and
on pushes to them:

1. **detect** — which `projects/<name>/` folders changed.
2. **test** — one runner per changed project, running that project's `ci.sh`.
3. **secret-scan** — repo-wide credential check.
4. **ci-status** — the single check branch protection requires to be green.

## Turning on the gates

Merges are only *blocked* on failing checks once branch protection is on, and
the ruleset must cover all three branches. See [docs/SETUP.md](docs/SETUP.md) —
import `.github/rulesets/develop-main-protection.json`.
