#!/usr/bin/env bash
# Wire the Rayfin-scaffolded app's agent files into Claude Code's discovery paths.
#
# Rayfin owns <AppName>/AGENTS.md and <AppName>/.agents/skills/ (the canonical,
# vendor-neutral locations). Claude Code only reads CLAUDE.md and .claude/skills,
# so this script adds two symlinks inside <AppName>/:
#
#   <AppName>/CLAUDE.md      -> AGENTS.md
#   <AppName>/.claude/skills -> ../.agents/skills
#
# Claude Code loads nested CLAUDE.md files and .claude/skills lazily — only when
# it touches a file under <AppName>/ — so the app-scope instructions and skills
# activate exactly when they're relevant, without polluting repo-root sessions.
#
# The links point at paths, not content, so `npx rayfin ai-files install`
# rewriting the files does not break them. Re-run this script after any scaffold
# refresh anyway: it is idempotent, and it detects the one case that does break
# the wiring (Rayfin replacing a symlink with a real file of its own).
#
# Usage, from the repo root:  scripts/wire-app-agents.sh <AppName>

set -euo pipefail

app="${1:-}"
if [[ -z "$app" ]]; then
  echo "Usage: scripts/wire-app-agents.sh <AppName>" >&2
  exit 2
fi
app="${app%/}"

if [[ ! -d "$app" ]]; then
  echo "FAIL  '$app/' not found — run from the repo root, after scaffolding the app." >&2
  exit 1
fi

status=0
say()  { printf '%-6s%s\n' "$1" "$2"; }
fail() { say FAIL "$1"; status=1; }

# --- <AppName>/CLAUDE.md -> AGENTS.md -----------------------------------------
if [[ ! -f "$app/AGENTS.md" ]]; then
  fail "$app/AGENTS.md missing — run 'npx rayfin ai-files install' in $app/ first."
elif [[ -L "$app/CLAUDE.md" ]]; then
  if [[ "$(readlink "$app/CLAUDE.md")" == "AGENTS.md" ]]; then
    say OK "$app/CLAUDE.md -> AGENTS.md"
  else
    fail "$app/CLAUDE.md is a symlink to '$(readlink "$app/CLAUDE.md")', expected 'AGENTS.md'. Fix or remove it, then re-run."
  fi
elif [[ -e "$app/CLAUDE.md" ]]; then
  if cmp -s "$app/CLAUDE.md" "$app/AGENTS.md"; then
    rm "$app/CLAUDE.md" && ln -s AGENTS.md "$app/CLAUDE.md"
    say OK "$app/CLAUDE.md was an identical copy of AGENTS.md — replaced with symlink"
  else
    fail "$app/CLAUDE.md is a real file that differs from AGENTS.md. Merge its content into $app/AGENTS.md (or repo-root AGENTS.md if it's a durable override), delete it, and re-run."
  fi
else
  ln -s AGENTS.md "$app/CLAUDE.md"
  say OK "created $app/CLAUDE.md -> AGENTS.md"
fi

# --- <AppName>/.claude/skills -> ../.agents/skills ----------------------------
if [[ ! -d "$app/.agents/skills" ]]; then
  fail "$app/.agents/skills/ missing — run 'npx rayfin ai-files install' in $app/ first."
elif [[ -L "$app/.claude/skills" ]]; then
  if [[ "$(readlink "$app/.claude/skills")" == "../.agents/skills" ]]; then
    say OK "$app/.claude/skills -> ../.agents/skills"
  else
    fail "$app/.claude/skills is a symlink to '$(readlink "$app/.claude/skills")', expected '../.agents/skills'. Fix or remove it, then re-run."
  fi
elif [[ -e "$app/.claude/skills" ]]; then
  fail "$app/.claude/skills is a real directory. Move its skill folders into $app/.agents/skills/, delete it, and re-run."
else
  mkdir -p "$app/.claude"
  ln -s ../.agents/skills "$app/.claude/skills"
  say OK "created $app/.claude/skills -> ../.agents/skills"
fi

# --- verify -------------------------------------------------------------------
for link in "$app/CLAUDE.md" "$app/.claude/skills"; do
  if [[ -L "$link" && ! -e "$link" ]]; then
    fail "$link does not resolve"
  fi
done

if [[ $status -eq 0 ]]; then
  echo "All wired. Claude Code will load $app/'s scaffold instructions and skills when working under $app/."
else
  echo "Wiring incomplete — resolve the FAIL lines above and re-run." >&2
fi
exit $status
