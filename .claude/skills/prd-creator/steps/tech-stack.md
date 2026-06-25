# Tech stack (fixed)

For a Fabric Data App the stack is **already determined** — there is nothing to detect or choose. State it plainly so the user knows it's settled, then move on. Don't scan for Rails/Next/etc., and don't offer stack alternatives.

The stack:

- **Data app:** the Microsoft Rayfin template — Vite + React + TypeScript + Tailwind v4, with [Vega-Lite](https://vega.github.io/vega-lite/) for visuals. Run with npm, deployed to Microsoft Fabric (OneLake) via `npx rayfin up`.
- **Data source:** a **Power BI semantic model**, queried live via the Execute DAX Queries REST API. The app connects using the model's share link; row-level security and Build/Read permissions carry through automatically.

**Then lock what's already provided** so the PRD doesn't re-spec it. The Rayfin data-app template plus the `/design-system` skill already give you, out of the box:

- Fabric authentication and live connectivity to the semantic model (no sign-in screen to design)
- Preconfigured visual primitives (bar, line, area, scatter, pie/donut, heatmap, bubble, waterfall, KPI cards) with cross-highlighting
- A data grid (sortable, formatted columns, custom cell renderers)
- Centralized theming via one style file, and per-column format strings applied everywhere
- Playwright browser validation before publish

Briefly confirm with the user that they have (or will create) the semantic model to connect to, and that they can get its share link. That's the only "setup" decision here — everything else is fixed.
