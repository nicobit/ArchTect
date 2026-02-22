---
title: DSL Support Matrix
---

# DSL Support Matrix

This page summarizes what ArchTect supports from the Structurizr DSL and what is parsed but not rendered. It is intended for authors who want to know which features will affect diagrams inside ArchTect.

The canonical DSL reference is maintained by Structurizr:
```text
https://structurizr.com/help/dsl
```

## Legend
- **Supported** = parsed and rendered in the UI.
- **Parsed only** = accepted and stored, but not fully rendered.
- **Not supported** = not implemented in the editor or renderer.

## Workspace
- Supported: `workspace` (name/description), `model`, `views`, `properties`, `!identifiers`
- Parsed only: `branding`, `terminology`, `configuration`
- Not supported: `!script`, `!plugin`, `!components`

## Model Elements
- Supported: `person`, `softwareSystem`, `container`, `component`, `deploymentEnvironment`, `deploymentNode`, `infrastructureNode`, `softwareSystemInstance`, `containerInstance`, `element`
- Supported: `group` (nested groups, with same-level constraints)
- Supported: relationships (`->`, implicit `this ->`)
- Supported: `tags`, `tag`, `description`, `technology`, `url`, `properties`, `perspectives` (stored and used where applicable)

## Views
- Supported: `systemLandscape`, `systemContext`, `container`, `component`, `deployment`, `dynamic`, `filtered`, `custom`
- Supported: `include`, `exclude`, `autoLayout`, `title`, `description`, `properties`
- Supported: `default` (default view selection)
- Parsed only: `image` views (directives are parsed and stored, but may not render in all UI contexts)

## Styles — Elements
Element style blocks:
```
styles {
  element <tag> { ... }
}
```

Supported properties (rendered):
- `shape`
- `icon`
- `width`, `height`
- `background`
- `color` / `colour`
- `stroke`
- `strokeWidth`
- `border` (solid/dashed/dotted)
- `opacity`

Parsed only:
- `metadata`
- `description`
- `properties` (stored; not currently rendered)

## Styles — Relationships
Relationship style blocks:
```
styles {
  relationship <tag> { ... }
}
```

Supported properties (rendered):
- `color` / `colour`
- `thickness`
- `opacity`
- `routing` (Direct/Orthogonal)
- `style` (dashed supported; other styles may be ignored)

Parsed only (not rendered):
- `fontSize`
- `width` (label box width)
- `position` (label position along the line)
- `properties`

## Themes
- Supported: `theme` and `themes` (merged into element/relationship styles)
- Supported: element icons from themes

## Notes
- Relationships always have the default tag `Relationship`, so a style like `relationship "Relationship" { ... }` applies to all relationships.
- If you rely on a DSL feature not marked “Supported,” it may parse but not affect the visual output.
