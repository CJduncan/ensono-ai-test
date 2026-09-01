# ensono-ai-test — pipeline sandbox

A throwaway repo to prototype a GitHub-native delivery pipeline: two long-lived
environment branches, automatic testing on every change, and a one-click way to
onboard a new project. No production data, no client data — just the mechanics.

## The model

```
feature branch ──PR──▶ develop (testing) ──PR──▶ main (prod-ready)
                  │                          │
                  └── CI runs ───────────────┴── CI runs + review gate
```

- **`develop`** is the testing branch. Everyday work merges here first.
- **`main`** is the prod-ready branch. Only vetted, `develop`-tested changes
  reach it, via a PR from `develop`.
- Every project lives in its own folder under `projects/`. CI only tests the
  projects a given change actually touches.

## Adding a project (the automated way)

Actions tab → **Scaffold new project** → **Run workflow** → give it a name and
an owner. It copies `projects/_template/`, wires up CODEOWNERS, and opens a PR
into `develop`. Merge that and start editing.

## How testing works

`.github/workflows/ci.yml` runs on every PR into `develop`/`main` and on pushes
to them:

1. **detect** — which `projects/<name>/` folders changed.
2. **test** — one runner per changed project, running that project's `ci.sh`.
3. **secret-scan** — repo-wide credential check.
4. **ci-status** — the single check branch protection requires to be green.

Each project owns its own `ci.sh`, so how a project is tested is up to the
project, not the pipeline.

## Turning on the gates

Merges are only *blocked* on failing tests once branch protection is on. See
[docs/SETUP.md](docs/SETUP.md) — import `.github/rulesets/develop-main-protection.json`
or flip the toggles by hand. Two minutes, one-time.
