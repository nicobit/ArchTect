---
title: UI Reference
---

# UI Reference

ArchTect has three main areas: a **left panel** for navigation, a **center canvas** for diagrams, and a **right panel (inspector)** for details and editing.

> Placeholder: Annotated screenshot of the full UI with the three areas labeled

---

## Left panel

The left panel lists your views and elements. Use it to:

- **Switch views** — click a view name to open it on the canvas.
- **Browse the model** — see elements and relationships defined in the DSL.
- **Search** — filter views or elements by name (if enabled in your build).

> Placeholder: Screenshot of the left panel with the views list and model tree

---

## Canvas

The canvas renders the active diagram. Basic interactions:

| Action | How |
|---|---|
| Pan | Click and drag on empty space |
| Zoom | Scroll wheel, or pinch on trackpad |
| Select element or relationship | Click it |
| Multi-select | Shift+click, or drag a selection box |
| Move elements | Drag (only when manual layout is enabled) |
| Create a relationship | Drag from a node's edge handle to another node |
| Fit diagram to viewport | **Fit** button in the toolbar, or press `F` |

> Placeholder: GIF showing pan, zoom, select, and element drag

### Canvas modes

- **Auto layout**: ArchTect arranges elements automatically. You cannot move elements manually.
- **Manual layout**: You can drag elements freely. Toggle this in the toolbar.

---

## Toolbar

The toolbar sits at the top of the canvas. Its contents vary slightly by view type, but the common controls are:

| Control | Description |
|---|---|
| View navigation | Previous / next view arrows |
| Layout algorithm | Choose between available layout modes (when in auto layout) |
| Auto layout toggle | Switch between auto and manual layout |
| Fit | Fit the diagram to the current viewport |
| Fullscreen | Enter fullscreen mode |
| Export | Export the current view as PNG or SVG |
| Theme / background | Change the color theme or background |

> Placeholder: Annotated screenshot of the toolbar with each control labeled

### Dynamic view toolbar

Dynamic views add playback controls when steps are defined:

- **Step back / step forward** — move through interaction steps one at a time.
- **Play / pause** — auto-advance through all steps.

> Placeholder: Screenshot of the dynamic view toolbar with playback controls

### Sequence diagram toolbar

When a dynamic view uses `flowType = sequence`, the toolbar shows sequence-specific controls:

- Zoom in / zoom out
- Fit to view
- Export SVG / PNG

> Placeholder: Screenshot of the sequence diagram toolbar

---

## Inspector (right panel)

The inspector updates to show details for whatever is currently selected. If nothing is selected, it shows view-level details.

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

> Placeholder: Screenshot of the element inspector showing the fields above

### Relationship inspector

When you select a relationship (line/arrow):

| Field | What it controls |
|---|---|
| Description | Label shown on the line |
| Technology | Secondary label (e.g. protocol) |
| Tags | Used for filtering and styles |
| Style overrides | Line color, thickness, routing (curved/orthogonal/direct) |

> Placeholder: Screenshot of the relationship inspector

### View inspector

When nothing is selected (or you click the canvas background):

| Field | What it controls |
|---|---|
| Include / exclude rules | Which elements appear in the view |
| Layout settings | Locked positions, padding |
| View properties | Title, description, default view flag |

> Placeholder: Screenshot of the view inspector
