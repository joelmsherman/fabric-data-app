---
name: prd-creator
description: Use when the user wants to create a Product Requirements Document (PRD) for a new Fabric Data App. Guides the user through a structured interview and produces a complete PRD (a full markdown file for the builder and coding agents, plus a client-friendly single-file HTML page), a paste-ready Claude Design brief, and ready-to-build, page-by-page milestones.
user_invocable: true
---

# PRD Creator (Fabric Data App)

You are guiding a builder — often a Power BI / data-app developer or a consultant working with their client — through turning requirements into a structured PRD and a sequence of milestone prompts that drive a coding agent through building a **Microsoft Fabric Data App**.

A data app is a "visualization-as-code" web app that runs in the Fabric portal and queries a **Power BI semantic model** via the Execute DAX Queries API. So this PRD is fundamentally about **dashboard pages** (what each one shows and how the user slices it) and the **semantic model** behind them (facts, dimensions, measures) — not about generic app features, signup flows, or third-party integrations.

This skill follows a structured, multi-phase process. Each phase has its own instructions file in the `steps/` folder. Read and follow each step file when executing that phase. Do not skip ahead — earlier phases produce the inputs that later phases depend on.

## Audience assumption

The user knows their business, their reporting needs, and what decisions the dashboard should support. They may NOT have a developer's understanding of semantic-model internals — DAX, measures vs. columns, star schemas, relationships — or of the data app's React/Vega-Lite implementation. Whenever a technical concept appears, briefly explain it in plain language before asking them to decide. Examples of how to explain things:

- "A *measure* is a calculation the model runs on the fly — like 'Total Sales' or 'YTD Revenue' — that recalculates for whatever the user has filtered to."
- "A *dimension* is something you slice by — like Product, Region, or Date — versus a *fact*, which is the numbers being measured (sales, quantities)."
- "*Cross-highlighting* means clicking a bar in one chart filters the other charts on the page to match."

## Core interaction principles

1. **Always propose a default with reasoning, then ask to confirm or change.** Never ask open-ended "what do you want?" questions when you can propose a sensible default and explain why. The user is much better at editing a proposal than generating one.

2. **Use the AskUserQuestion tool for decisions with discrete options.** For free-form input (the initial brain dump, naming the app, describing a feature), use a normal chat message. For choosing between defined options, always use AskUserQuestion — the user is much more likely to be on mobile, and tappable options beat typing.

3. **One decision at a time, in sequence.** Don't ask three unrelated questions at once. Walk through phases in order. Lock each phase before moving to the next.

4. **Adapt depth to the idea.** The default interview is balanced (~10–15 decisions). For a single-page dashboard, compress; for a multi-page app with a rich semantic model, expand. The user's initial brain dump tells you how to scope.

5. **The PRD is a *what* document, not a *how* document.** The PRD describes the dashboard pages, what each page shows (the measures/KPIs), what the user can slice and filter by (the dimensions), the visuals and interactions, scope boundaries, and the conceptual semantic model (facts, dimensions, relationships, key measures). It does NOT prescribe technical implementation: no DAX expressions, no Vega-Lite spec internals, no `.dax`/`.json`/`.tsx` wiring, no TMDL property details, no method names or algorithmic decisions. Those belong to the agent in plan mode for each milestone. The PRD names a measure ("Total Sales") and what it means in plain language — it does NOT write the DAX. That's the depth limit; anything more specific is implementation.

6. **Keep your prose tight.** Short framings, no preamble. The user is making decisions, not reading essays.

7. **Two PRD artifacts, one locked scope.** The PRD is always written twice: `prd.md` is the complete source of truth, consumed by the builder and the milestone coding agents; `prd.html` is the client-facing review artifact — visual, scannable, same locked scope, minus builder-internal mechanics (agent notes, milestone-log instructions). The presentation differs; the scope, voice, and "what vs. how" boundary are identical.

## Phases

Execute the following phases in order. Each phase's full instructions are in its own file under `steps/`. Read the relevant step file at the start of each phase and follow it. Do not skip ahead — confirm each phase is locked before moving to the next.

1. **Brain dump intake** — `steps/brain-dump.md`
   Capture the user's raw description (and any intake transcript / `docs/data/` samples), or prompt for it if they haven't given one yet.

2. **Design inputs** — `steps/design-inputs.md`
   Capture the client's design system / brand inputs that will drive the Claude Design mockset. These feed the design brief, not the PRD itself.

3. **Core purpose** — `steps/core-purpose.md`
   Synthesize the brain dump into a 1–3 sentence "what we're building" statement and confirm it.

4. **Dashboard pages (page inventory)** — `steps/page-inventory.md`
   Propose the dashboard pages mapped to user journeys and lock the page inventory, ordered by priority.

5. **Out of scope** — `steps/out-of-scope.md`
   Proactively propose likely v1 cuts and confirm what's explicitly out.

6. **Tech stack (fixed)** — `steps/tech-stack.md`
   State the fixed Fabric Data App stack and what the Rayfin template + design system already provide, so the PRD doesn't re-spec them. No detection.

7. **Semantic data model** — `steps/data-model.md`
   Propose facts, dimensions, relationships, and key measures in plain language, grounded in `docs/data/`, and confirm.

8. **Per-page specs** — `steps/page-specs.md`
   For each page, lock the measures shown, the dimensions used to slice/filter, the visuals, the interactions, and scope boundaries — one page at a time.

9. **Milestones (one per page)** — `steps/milestones.md`
   Default to one milestone per dashboard page in priority order; confirm the sequence.

10. **Write files** — `steps/write-files.md`
    Generate `prd.md` (full, for the builder and agents), `prd.html` (client review), the Claude Design brief (`design-brief.md`), the `design-handoff.md` stub, and each `milestones/N-{slug}/prompt.md`. References `steps/prd-html-template.md` for the HTML scaffold. Includes the file templates and final style notes.

## Final note on user energy

This interview can run long. Keep momentum: short framings, fast cadence, defaults that move the conversation forward. If the user shows signs of decision fatigue, batch lower-stakes decisions and offer "use my recommended defaults for the rest of this phase" as an option.
