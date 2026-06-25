# Per-page specs

Now revisit each page in the inventory one at a time and lock its detailed spec. Focus on **user-facing, analytical decisions only** — what the page shows, what the user can slice and do. Do NOT discuss technical implementation (DAX expressions, Vega-Lite spec internals, `.dax`/`.json`/`.tsx` wiring). Those are the agent's job to plan later.

For each page, lock:

1. **Overview** — 1–2 sentences: what decision or question this page serves.
2. **Measures / KPIs shown** — the numbers on the page (e.g., Total Sales, YTD Revenue, Margin %), named in plain language. These should trace back to the key measures from the Semantic data model phase.
3. **Slice / filter by (dimensions)** — what the user can break the numbers down by or filter on (e.g., by Region, Product, Date range).
4. **Visuals** — which visuals present each measure, drawn from the data-app primitives: bar (grouped/stacked), line, area, scatter, pie/donut, heatmap, bubble, waterfall, KPI cards, and the data grid. Pair each measure/breakdown with a sensible visual.
5. **Interactions** — cross-highlighting between visuals, slicers/filters that apply to the page, default selections, sort order.
6. **Out of scope for this page** — things a more ambitious version would have but v1 won't (drill-through to detail, what-if inputs, extra breakdowns, secondary axes, etc.).

Example of the right level of specificity (for a "Sales Overview" page):
- In scope: three KPI cards (Total Sales, Orders, Avg Order Value); a stacked bar of Sales by Month split by Category; a horizontal bar of Top 10 Products by Sales; a Region slicer and a Date-range slicer; clicking a Category segment cross-highlights the other visuals.
- Out of scope: drill-through to individual orders, a what-if discount slider, a map visual, exporting the grid to Excel.

What does NOT belong here: the DAX for "Total Sales", the Vega-Lite encoding, how the `{{FILTERS}}` token is substituted, component file names. The agent decides all of that in plan mode.

Move through pages one at a time. Don't batch.
