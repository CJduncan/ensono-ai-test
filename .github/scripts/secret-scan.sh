#!/usr/bin/env bash
# Minimal, dependency-free credential scan. Deliberately conservative: it looks
# for a few high-confidence patterns so a real leak is caught without drowning
# PRs in false positives. Swap for gitleaks/trufflehog when you want depth.
set -euo pipefail

# AWS access key id | PEM private key header | Slack token | GitHub PAT
patterns='AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[0-9A-Za-z-]+|ghp_[0-9A-Za-z]{36}'

# Scan tracked files only; never match this script's own pattern list.
if git grep -nIE "$patterns" -- ':!.github/scripts/secret-scan.sh'; then
  echo "::error::Potential credential found above. Remove it, rotate anything real, and recommit."
  exit 1
fi

echo "Secret scan clean."
