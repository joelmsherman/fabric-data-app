# Semantic data model

The data app queries a **Power BI semantic model**, so this phase defines that model conceptually: the facts, dimensions, relationships, and key measures behind the pages. Keep it plain-language and conceptual — name the measures and what they mean, not the DAX.

**First, check the source data.** Look for sample data and a metadata description under `docs/data/`. If they're missing:

> "I don't see source data yet. Please add sample files and a description under `docs/data/` (CSV samples plus a metadata markdown following `docs/data/metadata-template.md`). That grounds the facts and dimensions so the model isn't guesswork."

Don't fabricate a model with no source data — pause here until it exists, unless the user explicitly wants to proceed from their description alone.

**Then propose the model.** Frame it as a **star schema**: facts (the numbers) surrounded by dimensions (the things you slice by), grounded in what the pages need.

1. **Facts** — for each fact, the numeric fields it provides and which measures/KPIs they feed. Prefer a **single fact table**; only add another if numeric data from separate sources genuinely can't be combined upstream.
2. **Dimensions** — for each dimension, the categorical fields it provides (what users filter and group by). Group like categorical fields together; include a Calendar/Date dimension.
3. **Relationships** — one line each, e.g. "Product (1) → (many) Sales", "Date (1) → (many) Sales". Aim for single-direction, one-to-many from dimensions to facts.
4. **Key measures** — the headline calculations the pages need (e.g., Total Sales, YTD Revenue, Margin %, Customer Count), each described in one plain-language line. These should cover every KPI referenced in the page specs.

Propose the full model at once, then ask the user to confirm or adjust via AskUserQuestion:
- Looks right, lock it in
- Mostly right, I'll edit in chat
- Missing something — let me describe

The ideal model is a star schema with single-direction one-to-many relationships and all tables in import mode. Note that for the data app you only need Build/Read on the model — the app never modifies it.
