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
- Supported: remote theme loading via URL (e.g., Azure, AWS, GCP, Kubernetes from Structurizr CDN or any custom URL)
- Supported: multiple themes with precedence (later themes override earlier ones)
- Icon themes populate the Palette with searchable, draggable icon libraries

### Theme types

| Type | Purpose | Examples |
|---|---|---|
| **Color palette** | Sets element and relationship colors | C4 Default, C4 Blue, C4 Brown, Vivid |
| **Icon theme** | Provides cloud/technology icons for elements | Azure Icons, AWS Icons, GCP Icons, Kubernetes |

### Remote theme URLs

You can load any Structurizr-compatible theme via URL:

```dsl
views {
  styles {
    theme https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json
  }
}
```

## Notes
- Relationships always have the default tag `Relationship`, so a style like `relationship "Relationship" { ... }` applies to all relationships.
- If you rely on a DSL feature not marked "Supported," it may parse but not affect the visual output.
- Icon themes apply styles based on **tags** — when an element has a tag matching a theme entry (e.g., `Microsoft Azure - SQL Database`), the corresponding icon is applied automatically.
