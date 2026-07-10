# Fabric Data App Template

A GitHub template for full-lifecycle development of **Microsoft Fabric Data Apps** with Claude Code — from client intake and PRD through design mocks, build, and deployment. The Power BI semantic model behind the app is built separately, from the sibling [`fabric-semantic-model`](https://github.com/joelmsherman/fabric-semantic-model) template.

## Introduction

A [Fabric Data App](https://learn.microsoft.com/en-gb/fabric/apps/data-apps-template) is a **"visualization-as-code"** web application that runs inside the Microsoft Fabric portal and queries a Power BI **semantic model** via the Execute DAX Queries REST API. Where a Power BI report is drag-and-drop, a data app is built from explicit code: DAX queries, [Vega-Lite](https://vega.github.io/vega-lite/) visual specs, and React components — giving you full control over layout, interactivity, and branding while reusing your governed semantic model and its row-level security.

Data apps are scaffolded and deployed with the **[Rayfin CLI](https://www.npmjs.com/package/@microsoft/rayfin)** (a Vite + React + Tailwind v4 stack, driven here with npm). This template doesn't replace that scaffold — it wraps the whole lifecycle around it:

1. **Plan** the product with the `/prd-creator` skill — a full PRD for you and the agents, a client-friendly PRD for review, a design brief for the mockset, and a portable model spec for the semantic-model repo.
2. **Design** the mockset in [Claude Design](https://claude.ai/design) from that brief, using the client's design system; iterate to client approval. The approved mockset becomes the visual source of truth for the build.
3. **Build & deploy the semantic model** the data app reads from — in a **separate repo** created from the [`fabric-semantic-model`](https://github.com/joelmsherman/fabric-semantic-model) template. Bring `_build_plan/model-spec.md` and your `docs/data/` there; come back with the model's **share link**.
4. **Create the App item in Fabric, then scaffold it** into an `<AppName>/` subfolder with the Rayfin CLI, codify the approved mockset with the `/design-system` skill, and build its visuals as DAX + Vega-Lite + React.
5. **Validate** DAX via Tabular Editor and **deploy** with `npx rayfin up`.

The development model is **source-first and agent-assisted**: the data app lives as code under source control, and Claude Code does the heavy lifting on DAX, visual specs, and deployment.

## Requirements

### Claude Code

Install Claude Code per the [official instructions](https://docs.claude.com/en/docs/claude-code/overview).

### Node.js

**Node.js v18+** (npm is included — used for the Rayfin data app). Check with `node -v`; install/update from [nodejs.org](https://nodejs.org/) or via [nvm](https://github.com/nvm-sh/nvm).

### Rayfin CLI

Run later at the project root, after the semantic model is deployed and you're ready to scaffold the app.

### Fabric CLI

The [Fabric CLI](https://microsoft.github.io/fabric-cli/) (`fab`) is used to discover workspace/model IDs and for workspace operations. Install and authenticate:

```bash
pip install ms-fabric-cli
fab auth login
```

### Tabular Editor

Used to browse the model schema and validate DAX before wiring it into visuals. See [tabulareditor.com](https://www.tabulareditor.com/).

### Claude Code Plugins

The `.claude/settings.json` in this template points to the [`data-goblin/power-bi-agentic-development`](https://github.com/data-goblin/power-bi-agentic-development) marketplace and pre-enables three plugins (model-authoring and report-authoring plugins are intentionally left off — the model is built in its own repo, and visualization lives in the data app):

- `fabric-cli` — Fabric workspace and deployment operations
- `semantic-models` — DAX authoring/performance and lineage tracing
- `tabular-editor` — DAX validation against the deployed model

On your first `claude` launch in the cloned project, accept the marketplace trust prompt; the plugins install (and auto-update) from there.

### Fabric prerequisites

- Access to Microsoft Fabric with **contributor or admin** permissions on a workspace.
- The **Fabric Apps workload enabled** in your tenant ([how to enable](https://learn.microsoft.com/en-gb/fabric/apps/create-app#enable-fabric-app-in-tenant-admin-settings)).
- The **Semantic Model Execute Queries REST API** tenant setting enabled (Admin portal → Integration settings).
- **Build and Read** permissions on the semantic model, hosted on a Fabric or Power BI capacity.

## Getting Started

```bash
# Clone from this template (or use GitHub's "Use this template")
git clone https://github.com/joelmsherman/fabric-data-app.git my-data-app
cd my-data-app

# Remove the template remote
git remote remove origin

# Launch Claude Code (accept the marketplace trust prompt on first run)
claude
```

No init script is needed — naming comes later from the Fabric App item you create in step 4 (`<AppName>`).

## Workflow

### 0. Client intake

Conduct and record an intake meeting with the client to discover:
- background on the business context
- pain points and existing issues
- what they're looking to acheive with a new solution
- existing data (ask them to email examples before meeting, and walk thru during meeting)

### 1. Plan the product

Place source data samples under `docs/data/` and describe them using `docs/data/metadata-template.md`.

Invoke the `/prd-creator` skill and provide Claude with the intake meeting transcript; ask Claude in the prompt to review `docs/data` so that it can ground the plan for the semantic model.

The skill writes everything to `_build_plan/`:

- `prd.md` — the full PRD, consumed by you and the milestone coding agents
- `prd.html` — the client-friendly PRD; open it in a browser and send it to the client for review
- `design-brief.md` — a paste-ready brief for Claude Design (next step)
- `design-handoff.md` — a stub where the approved mockset link goes after sign-off
- `model-spec.md` — a portable semantic-model handoff, copied into the model repo in step 3
- `milestones/N-{slug}/prompt.md` — one build prompt per dashboard page

### 2. Design mocks

Once the client approves the PRD, paste `_build_plan/design-brief.md` into [Claude Design](https://claude.ai/design) — along with the client's design system, if they have one there — and create contained high-fidelity interactive mocks. Iterate with the client until final approval.

When approved, **paste the mockset's handoff/share URL into `_build_plan/design-handoff.md`**. The `/design-system` skill (step 5) and every milestone prompt (step 6) read it from there.

### 3. Build & deploy the semantic model (separate repo)

The model lives in its own repo, created from the [`fabric-semantic-model`](https://github.com/joelmsherman/fabric-semantic-model) template:

1. Create a repo from that template and run its `./setup.sh`.
2. Copy `_build_plan/model-spec.md` and your `docs/data/` samples into it.
3. Build the model there (TMDL), validate it with BPA, and deploy it to a Fabric workspace — the model repo's README walks through it.

Once deployed, copy the model's **share link** from the Power BI Service — the URL contains the workspace ID and model ID and is how the data app connects, e.g.:

```
https://app.powerbi.com/groups/<workspace-id>/modeling/<model-id>/modelView
```

### 4. Create the Fabric App item, then scaffold it locally

The App item must exist in Fabric **before** you scaffold. In the Fabric portal, open your workspace and select **New item → App** ([create-app steps 1–3](https://learn.microsoft.com/en-gb/fabric/apps/create-app)), give it a name — this becomes your `<AppName>` — and select **Create**.

Then, **from the root of this repo**, run the command the portal shows you (it pre-fills the app name and workspace). Like any `npm create` scaffolder, it downloads the data app into a **new `<AppName>/` subfolder** next to `docs/` — keeping the planning artifacts and the app in one repo:

```bash
npm create @microsoft/rayfin@latest -- "<AppName>" --template dataapp --workspace "<WorkspaceName>"
cd <AppName>
npx rayfin ai-files install
```

> `<AppName>` must match the App item you created in Fabric. If the Rayfin scaffold initializes its own git repo inside `<AppName>/`, **delete that nested `<AppName>/.git`** (keep the repo-root `.git`) so the whole solution stays one git repo. Run this from the repo root:
> ```bash
> rm -rf <AppName>/.git
> ```
> This matters for more than tidiness: Claude Code discovers the repo-root `.claude/skills/` (design-system, prd-creator) and `settings.json` plugins only when `<AppName>/` is part of **this** repo. The nested `<AppName>/.git` would make Claude treat `<AppName>/` as a separate project and lose those skills.
>
> **Keep your Claude session at the repo root** for all agent work — it can read and edit files under `<AppName>/` just fine, and only there does it see the skills and plugins. Use a terminal in `<AppName>/` only to run the shell commands (`npm run dev`, `npx rayfin up`).

### 5. Set up the design system

From your **repo-root Claude session**, invoke the **`/design-system`** skill (it operates on the `<AppName>/` app files). Claude detects the approved mockset link in `_build_plan/design-handoff.md`, extracts the brand color and fonts from the mockset, confirms them with you, then scaffolds a central style file and a live reference page that future agents defer to (Tailwind v4). If there's no mockset, it falls back to three quick picks — brand color, display font, body font.

### 6. Build solution milestone by milestone

Hand Claude the first milestone prompt and the **model share link** — the prompt already points at the PRD and the approved mockset via `_build_plan/design-handoff.md`.

Iterate locally:
> use terminal in `<AppName>/`
```bash
npm run dev      # preview at http://localhost:5173
```

Theming and number/date formatting are centralized — styling lives in the app's `global.css` (use the `/design-system` skill), and a column's format string is set once and applied everywhere (axes, tooltips, labels, grid cells).

### 7. Deploy the data app
> use terminal in `<AppName>/`
```bash
npx rayfin up
```

This builds the app, uploads the static files to OneLake, and creates/updates the Fabric App item. Open it in the Fabric portal under your Entra identity.

> **Note:** Apps connected to a semantic model currently run **inside the Fabric portal only** — opening them in a standalone browser window causes the visual queries to error. This is a temporary Fabric limitation.

### 8. Document

When finished, ask Claude to overwrite this `README.md` with a proper one that fully documents your data app.

## Folder Structure

```
.claude/
  settings.json                # Claude Code marketplace + plugin configuration
  skills/
    design-system/             # /design-system — approved mockset (or brand picks) → central style file + reference page
    prd-creator/               # /prd-creator — interview → PRDs (full + client) + design brief + model spec + milestone prompts
CLAUDE.md                      # Data-app conventions for Claude
docs/
  data/                        # Source data samples + metadata-template.md
<AppName>/                     # Rayfin data app — scaffolded as a subfolder in step 4 (its own
                               #   package.json, fabric.yaml, AI files; runs npm run dev / npx rayfin up)
```

The template ships without `<AppName>/`; step 4 scaffolds it into your repo as a self-contained Rayfin project. The semantic model lives in its own repo, created from the [`fabric-semantic-model`](https://github.com/joelmsherman/fabric-semantic-model) template; this app connects to it via its share link.

## Theming

There is no Power BI report layer and no report theme JSON — visualization lives entirely in the data app. The client-approved Claude Design mockset (linked in `_build_plan/design-handoff.md`) is the design source of truth; the **`/design-system`** skill codifies it once into the app's central style file, and changes flow from that one file to every card, chart, grid, and tooltip. Without a mockset, the skill sets brand color and fonts from quick picks instead.
