# Write files

Once everything is locked, generate the files. **Just write them.** Don't show a draft for approval first — the user already approved each piece during the interview.

## What to write, based on the format choice

Recall the format the user picked in the **Format choice** phase:

- **HTML** → write `_build_plan/prd.html` only. Use the scaffold and section snippets in `steps/prd-html-template.md`.
- **Markdown** → write `_build_plan/prd.md` only. Use the markdown template below.
- **Both** → write **both** `_build_plan/prd.html` **and** `_build_plan/prd.md`. The two files must describe the same locked scope — HTML is a different presentation, not a different plan.

Milestone `prompt.md` files are **always written as markdown** regardless of the format choice. They're consumed by the coding agent in plan mode, not by the user.

Create this exact structure in the codebase root (file presence depends on the format choice above):

```
_build_plan/
  prd.html         # HTML or Both
  prd.md           # Markdown or Both
  milestones/
    1-{milestone-slug}/
      prompt.md
    2-{milestone-slug}/
      prompt.md
    ...
```

`{milestone-slug}` is a short kebab-case name derived from the milestone — usually the page (e.g., `sales-overview`, `product-detail`, `app-shell`).

After writing the `_build_plan/` files, also add a short note about the `_build_plan/` folder to the project's agent instructions file — see "Agent instructions note" below.

After writing, briefly tell the user the files are ready and how to use them. Tailor the message to what was written:

- If `prd.html` was written: tell them to open it in a browser (`open _build_plan/prd.html`) to review the plan visually, then open the milestone-1 `prompt.md` and ask the agent to start there.
- If only `prd.md` was written: tell them to open `_build_plan/prd.md` to review, then open the milestone-1 `prompt.md` and ask the agent to start there.
- Either way, mention that after each milestone the agent will write a `milestone-log.md` in that milestone's folder to record what was done.

## File templates

### prd.html structure

See `steps/prd-html-template.md` for the complete scaffold, per-section snippets, and icon hints. Read that file in full when generating `prd.html` and follow it closely.

### prd.md structure

Mirror the structure of a high-quality real PRD. Use these sections in order:

```markdown
# {App name}

> **About these build-plan files:** Everything in `_build_plan/` (this PRD and the per-milestone folders) is a **temporary documentation and guidance artifact** for the initial build-out of this codebase. These files are not functional — no code, configuration, runtime logic, tests, or deployment process should import, read, reference, or depend on anything in `_build_plan/`. Once the initial milestones are built and shipped, the entire `_build_plan/` folder is expected to be deleted from the codebase. Do not treat it as long-living documentation.

## What we're building

{1–3 sentence core purpose, expanded with a paragraph or two of context. End with a sentence noting it's a Fabric Data App over a Power BI semantic model, and that the build is structured one milestone per page.}

---

### Dashboard pages

{The locked page inventory, in priority order. One bullet per page: the page name and a one-line description of the decision/question it serves. Per-page detail (visuals, measures, interactions) lives in the milestones below.}

---

### Already provided by the Rayfin data-app template

{Bulleted list of what the Rayfin template + /design-system already give you and that the PRD does not re-spec: Fabric auth and live model connectivity, the visual primitives with cross-highlighting, the data grid, centralized theming, per-column format strings, Playwright validation.}

---

### Out of scope

{Top-level out-of-scope list with brief reasoning for each item. Each bullet is one line.}

---

### Semantic data model

{The conceptual Power BI semantic model behind the pages, as a star schema. Use sub-headings: **Facts** (the numeric tables and what measures they feed), **Dimensions** (the things users slice by, including a Date dimension), **Relationships** (one line each, e.g. "Product (1) → (many) Sales"), and **Key measures** (each headline calculation named with a one-line plain-language meaning). Conceptual only — name the measure ("Total Sales — sum of line-item revenue"), never the DAX.}

---

## Milestone 1 — {Name}

{1–2 sentence framing of what this milestone delivers.}

### What gets built

{The page this milestone delivers, from the per-page spec: the measures/KPIs shown, the visuals presenting them, the dimensions the user can slice/filter by, and the interactions (cross-highlighting, slicers). Describe what the user sees and does on the page — not the DAX, Vega-Lite specs, or component wiring. The agent figures those out in plan mode.}

### What milestone {N} explicitly does NOT include

{Bulleted list of things a coder might assume should be in this milestone but aren't — drill-through, extra breakdowns, other pages, etc.}

### Done when

{1–2 sentences describing the verification criteria — what the user should see and be able to do on this page when previewing with `npm run dev`.}

---

{Repeat for each milestone}
```

### milestones/N-{slug}/prompt.md structure

Keep this lean. The prompt.md is a thin trigger file — it does NOT re-summarize what's in the PRD.

In the template below, substitute `{PRD_PATH}`:

- If the user picked **HTML** only → `_build_plan/prd.html`
- If the user picked **Markdown** only or **Both** → `_build_plan/prd.md` (markdown is easier for the agent to parse; if both formats exist, prefer the markdown one for the agent's context)

```markdown
# Milestone {N} — {Name}

You are entering plan mode to plan and then build milestone {N} of this project.

## Context

- Read `@{PRD_PATH}` for the full project context, scope, semantic data model, and the per-page spec for this milestone's page.
- This page queries the Power BI semantic model via its **share link** — use the link the user provides (it carries the workspace and model IDs). If you don't have it, ask before building the visuals.
- Build the page in the Rayfin data app (the `<AppName>/` subfolder), using the template's visual primitives and centralized theming. Read previous milestone folders (`@_build_plan/milestones/1-*/milestone-log.md`, etc.) to reuse measures/dimensions already wired up. If this is milestone 1, there is no prior milestone to read.

## Your task

1. Plan the implementation for **only** milestone {N} as defined in the PRD. Do not plan or build anything from later milestones.
2. After the user confirms the plan, build only what is in milestone {N}'s scope.
3. Verify your work against the "Done when" criteria for milestone {N} in the PRD.
4. When complete, write a `milestone-log.md` in this folder (`_build_plan/milestones/{N}-{slug}/milestone-log.md`). Structure it as follows:
   - **Start with a `## What's new in the app` section at the very top.** This is a concise, human-readable, bulleted list of the main user-facing features or functionality that were added in this milestone — written so a non-technical reviewer can see at a glance what new things to expect in the app now that this milestone is done. Frame each bullet as a capability the user will now see or be able to do, not as a technical artifact. Keep it short and scannable.
   - Then include the implementation detail sections below for the next milestone's agent to reference:
     - What was built (files created, models added, routes added, etc.)
     - Any decisions made during implementation that weren't pre-specified in the PRD
     - Anything the next milestone will need to know
     - Any deviations from the PRD and why

Ask me any clarifying questions using AskUserQuestion tool to lock in the implementation plan for this milestone.
```

## Agent instructions note

After writing the `_build_plan/` files, append a short note to the project's agent instructions file so future agent sessions understand the role of `_build_plan/`.

1. Check the codebase root for an existing `CLAUDE.md` or `AGENTS.md`. Use whichever exists.
2. If neither exists, create `AGENTS.md` at the codebase root.
3. Append the section below at the **bottom** of the file (after any existing content). If a `## _build_plan/` section already exists, update it in place rather than duplicating.

```markdown
## `_build_plan/`

The `_build_plan/` folder contains the initial PRD and per-milestone prompts used to scaffold this codebase during its initial build-out phase. These files are **temporary** — they exist for documentation and guidance only. They are **not** functional: no code, configuration, or runtime logic in this codebase should import, reference, or depend on anything inside `_build_plan/`.

Do not treat `_build_plan/` as long-living documentation for the codebase. The codebase will evolve past the assumptions and decisions captured here. Once the initial milestones are complete, this folder is expected to be deleted.
```

## Style notes for the PRD output

- Mirror the voice of a sharp product spec: concrete, specific, opinionated. Not "the page should probably show X" but "the page shows X."
- Per-page specs are specific about analytical behavior: the measures shown, what the user can slice by, the visuals, the interactions. They are NOT specific about technical implementation (DAX, Vega-Lite internals, component wiring) — that's the agent's job in plan mode.
- The "Out of scope" lists are valuable — never skip them, never make them generic.
- The semantic data model is described in plain language (facts, dimensions, relationships, and measures with their meaning), never as DAX or TMDL.
- Refer to the starter as "the Rayfin data-app template" and the data source as "the Power BI semantic model."
- These style notes apply to both formats. The HTML version uses the same locked content as the markdown — it's a different presentation, not a different scope.
