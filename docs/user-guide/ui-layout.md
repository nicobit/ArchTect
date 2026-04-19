---
title: UI Reference
---

# UI Reference

ArchTect has three main areas: a **Palette** (left panel) for drag-and-drop element creation and navigation, a **Canvas** (center) for diagrams, and an **Inspector** (right panel) for editing properties and view settings.

<!-- screenshot: Annotated screenshot of the full UI with the three areas labeled -->

---

## Palette (left panel)

The Palette provides drag-and-drop element creation and icon browsing. Its content is **context-sensitive** — it changes based on the type of view you're editing.

### In model views (System Context, Container, Component)

| Section | Content |
|---|---|
| **Elements** | Draggable stencils grouped by type — People, Systems, Containers (groups vary by view scope) |
| **Shapes** | Person, Robot, Rounded Box, Box, Hexagon, Circle, Ellipse, Cylinder, Pipe, Folder, Web Browser, Mobile Portrait, Mobile Landscape |
| **Icon libraries** | One searchable, paginated section per active icon theme (e.g., "Microsoft Azure (505)", "Amazon Web Services (891)") |

### In Deployment views

| Section | Content |
|---|---|
| **Quick Create** | Buttons to add Deployment Environment, Filtered View, or Flow |
| **Deployment Nodes** | Deployment node stencils |
| **Infrastructure** | Infrastructure node stencils |
| **Instances** | System instance and container instance stencils |
| **Icon libraries** | Same theme-based icon sections as model views |

### Icon libraries from themes

Icon libraries appear in the Palette when you activate **icon themes**. Each theme adds a collapsible section with:

- A **search bar** to filter icons by name
- A **paginated grid** (12 icons per page) with navigation arrows
- The **total icon count** in the section header (e.g., "Microsoft Azure (505)")

Drag an icon onto the canvas to create a new element with that icon's tag applied automatically.

!!! note "Icons come from themes"
    The icon libraries are loaded from themes — they are not built-in. The number of icons depends on which themes are active. See [Themes](#themes) below for details.

### Theme picker

The **Themes** button at the bottom of the Palette opens a dropdown with two sections:

- **Color Palettes** — C4 Default, C4 Blue, C4 Brown, C4 Green, C4 Violet, C4 Blue (Wire), C4 Brown (Wire), C4 Green (Wire), C4 Violet (Wire), C4 Sandstone, C4 United, C4 Superhero, Vivid
- **Icon Themes** — Azure (remote), AWS Icons, Azure Icons, Icons Base

Toggle themes on/off with the checkmark. Active themes show a green checkmark. The badge on the Themes button shows how many themes are active.

You can also add **any remote theme** via URL in the DSL:

```dsl
views {
  styles {
    theme https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json
    theme https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json
  }
}
```

Common remote themes:

| Theme | URL |
|---|---|
| **Microsoft Azure** | `https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json` |
| **Amazon Web Services** | `https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json` |
| **Google Cloud Platform** | `https://static.structurizr.com/themes/google-cloud-platform-2023.01.26/theme.json` |
| **Kubernetes** | `https://static.structurizr.com/themes/kubernetes-0.3/theme.json` |

You can use **any** URL that serves a valid Structurizr theme JSON file — including custom themes on your own server.

<!-- screenshot: Theme picker dropdown showing Color Palettes (C4 Default checked, C4 Blue, etc.) and Icon Themes (Azure remote checked, AWS Icons checked) -->

---

## Canvas

The canvas renders the active diagram. Basic interactions:

| Action | How |
|---|---|
| Pan | Hold `Space` and drag, or middle-click drag |
| Zoom | Scroll wheel, or `Ctrl`+`+` / `Ctrl`+`-` |
| Select element or relationship | Click it |
| Multi-select | `Shift`+click |
| Move elements | Drag to reposition |
| Nudge elements | Arrow keys (hold `Shift` for larger increments) |
| Create a relationship | Drag from one element to another |
| Fit diagram to viewport | `Ctrl`+`0` |
| Select all | `Ctrl`+`A` |
| Delete selected | `Delete` or `Backspace` |
| Undo / Redo | `Ctrl`+`Z` / `Ctrl`+`Y` |

### Adding elements

Drag elements, shapes, or cloud icons from the **Palette** onto the canvas. The Palette content adapts to the active view type — see [Palette](#palette-left-panel) above.

<!-- screenshot: Canvas showing a container diagram with multiple elements, relationships labeled with technologies -->

---

## Toolbar

The toolbar sits at the top of the canvas. Common controls:

| Control | Description |
|---|---|
| View navigation | Previous / next view arrows |
| Export | Export the current view as PNG or SVG |
| Zoom controls | Zoom in, zoom out, fit to screen |
| Undo / Redo | Undo and redo recent actions |

### Dynamic view toolbar

Dynamic views add playback controls when steps are defined:

- **Step back / step forward** — move through interaction steps one at a time.
- **Play / pause** — auto-advance through all steps.

### Sequence diagram toolbar

When a dynamic view uses `properties { flowType sequence }`, the toolbar shows sequence-specific controls:

- Zoom in / zoom out
- Fit to view
- Export SVG / PNG

---

## Inspector (right panel)

The inspector updates to show details for whatever is currently selected. If nothing is selected, it shows view-level settings.

### Element inspector

When you select an element:

| Field | What it controls |
|---|---|
| Name | Display name of the element |
| Description | Shown in the diagram and exported metadata |
| Technology | Label shown on container/component shapes |
| Tags | Used for filtering and applying styles |
| Properties / metadata | Custom key-value pairs |
| Style overrides | Background color, text color, border style, icon |

### Relationship inspector

When you select a relationship (line/arrow):

| Field | What it controls |
|---|---|
| Description | Label shown on the line |
| Technology | Secondary label (e.g. protocol) |
| Tags | Used for filtering and styles |
| Style overrides | Line color, thickness, routing (curved/orthogonal/direct) |

### View inspector

When nothing is selected (click the canvas background):

| Field | What it controls |
|---|---|
| **View source** | Badge: "Auto-generated view" or "Defined in DSL" (with action button — see below) |
| **Title** | View display title |
| **Description** | View description |
| **Theme** | Applied themes — add, remove, or reorder |
| **Compact mode** | Toggle condensed element rendering |
| **Auto layout** | Enable/disable and direction (tb, bt, lr, rl) |
| **Layout engine** | Default, Graphviz, Dagre, or ELK (under "Advanced layout") |
| **Layout parameters** | Engine-specific tuning (see below) |
| **Custom properties** | Key-value pairs for view metadata |

#### View persistence (Add to DSL / Remove from DSL)

The Inspector shows a badge indicating the view's origin:

- **Auto-generated view** — The view was created automatically (not in your DSL). An **"Add to DSL"** button lets you persist it to your workspace file.
- **Defined in DSL** — The view exists in the DSL. A **"Remove from DSL"** button lets you delete the view definition.

#### Themes

The Theme section in the view inspector shows which themes are active. You can add theme URLs, remove themes, and reorder them. Later themes take precedence where styles conflict.

#### Compact mode

Toggle **compact mode** to render elements in a more condensed style. Useful for views with many elements. Stored in the view's `properties` block as `compactMode`.

#### Layout engine (Advanced layout)

Each view can use a different layout engine. The choice is **saved per view** in the DSL properties block.

| Engine | Best for |
|---|---|
| **Default** | General use |
| **Graphviz** | Dense, interconnected graphs |
| **Dagre** | Tree-like / directed acyclic structures |
| **ELK** | Complex diagrams with many layers |

When you select a non-default engine, additional tuning parameters appear:

**Graphviz:** Node separation, Rank separation, Cluster margin, Cluster external margin, Graph padding, Edge routing (spline mode)

**Dagre:** Node separation, Rank separation

**ELK:** Spacing

!!! note "Saved in DSL"
    The layout engine and its parameters are stored in the view's `properties` block:

    ```dsl
    systemContext mySystem "Context" {
      include *
      autoLayout
      properties {
        layoutEngine graphviz
      }
    }
    ```

<!-- screenshot: Inspector showing view-level settings with Theme section, Compact mode checkbox, Auto layout direction dropdown, and Advanced layout section with Graphviz selected and node/rank separation fields -->
