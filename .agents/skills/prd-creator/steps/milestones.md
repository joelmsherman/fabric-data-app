# Milestones (one per page)

For a data app, milestones follow the **page inventory**: the default is **one milestone per dashboard page**, built in the priority order locked earlier. Each page is a self-contained, testable unit of work — exactly the right size for a coding-agent session.

Propose the default sequence (one milestone per page) plus two alternatives, and let the user pick via AskUserQuestion:

- **Default (recommended):** one milestone per page — Milestone 1 = first page, Milestone 2 = second page, etc.
- **Alternative A — add a foundation milestone first:** if the pages share a navigation shell, common slicers, or a non-trivial model connection, make Milestone 1 a small "app shell + model connection + shared layout" step, then one milestone per page after it. (Skip this if the Rayfin scaffold + design system already cover the shell — often they do.)
- **Alternative B — group small pages:** combine two closely related, lightweight pages into a single milestone.

Each milestone must:
- Deliver a **working, previewable page** the user can see and test with `npm run dev`
- Be a self-contained working session for a coding agent
- Build on earlier milestones (shared measures/dimensions defined once, reused later)

Explain the tradeoff in plain language: one-page-per-milestone gives the most checkpoints and the tightest feedback loop; grouping pages means fewer, larger sessions with more risk per session.

After the user picks, restate the final milestone list — each milestone named for its page, with a one-line scope — and confirm. The per-page spec from the previous phase becomes that milestone's detailed scope.
