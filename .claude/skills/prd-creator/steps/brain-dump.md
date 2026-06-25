# Brain dump intake

If the user's first message is already a substantive description of the dashboard/app they want, you have your brain dump — proceed to the Core purpose phase. If their first message is just "help me plan a data app" or similar, ask them to describe in their own words: what business questions should the dashboard answer, who uses it, and what decisions it should support. Free-form text response, no AskUserQuestion needed here.

Also pull in context that's likely already in the repo:

- If the user mentions (or you see) an **intake meeting transcript**, read it — it usually contains the business context, pain points, and goals.
- Check `docs/data/` for **source data samples** and a metadata description. If present, skim them — they tell you what facts and dimensions are actually available, which grounds the page inventory and semantic model later. If absent, don't block here; just note you'll need them before the Semantic data model phase.
