# Deferral block for scaffold-installed agent skills

Used by **Phase 5b**. When a scaffold-installed skill (e.g. Rayfin's
`.agents/skills/app-design/SKILL.md`) contains theming or token-authoring
instructions, replace those sections with the block below rather than deleting
the whole file — the layout and behavioral guidance in such skills is usually
worth keeping.

## What to remove

Delete sections whose subject is the *visual language*:

- Theming workflow / "customize `<file>.css` first" / "single source of truth"
- Token authoring — anything naming `@theme`, `--color-*`, `--font-*`, or
  telling the agent to update, customize, or invent token values
- Aesthetic direction, palette selection, font pairing
- Typography token instructions (font-family tokens, type scale authoring)
- "UI token rules" that point at a CSS file this skill no longer owns

## What to keep

Leave sections whose subject is *layout or behavior*, and which do not
prescribe color, type, or token values:

- Page structure, container sizing, dashboard grid
- Loading, empty and error states
- Giving visuals definite heights
- Accessibility requirements
- Validation and final-audit steps
- Framework/coding conventions unrelated to visual language

## Block to insert

Insert at the top of the file, immediately under the title, and substitute the
bracketed paths. Wrap it in the markers so a re-run can replace it idempotently.

```markdown
<!-- bm-design-system:start -->
> **This skill does not govern visual language.**
>
> This project has a codified design system. It owns every color, type, spacing,
> radius, elevation and component decision:
>
> - Tokens and component layer: `<TOKEN_FILE>`
> - Primitives: `<UI_DIR>`
> - Rules: the "Design system" section of `<AGENT_INSTRUCTIONS>`
>
> **Precedence:** design system > this skill > agent defaults.
>
> Use this skill for layout, container sizing, grid, loading/empty/error states,
> accessibility and validation only. Any instruction below to author, customize,
> or choose tokens, colors, fonts, or an aesthetic direction is **void** — the
> decisions are already made and codified. Do not create new tokens; compose the
> existing ones. If something is genuinely missing, propose it as a
> design-system addition instead.
<!-- bm-design-system:end -->
```

## Extra warning for Fabric data apps

When the target is a Fabric data app (Rayfin scaffold), append this to the
inserted block — the failure mode is worse than visual drift there:

```markdown
> Additionally: the Fluent-named `--color-*` variables in the entry CSS are a
> **runtime bridge**, not theme tokens. `readCssTheme()` in
> `@microsoft/fabric-visuals-core` reads them to theme `<VegaVisual>` and
> `<DataGrid>`, which cannot resolve `var()`. Editing them as if they were
> theme values breaks chart theming. Change the design-system token they point
> at instead.
```
