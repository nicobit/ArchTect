---
title: User Guide
---

# User Guide

ArchTect is a diagram-as-code tool for software architecture. You write your model in **Structurizr DSL** — a plain text file — and ArchTect renders it as interactive diagrams. The canvas and DSL stay in sync bidirectionally: edit on the canvas and the DSL updates, edit the DSL and the canvas updates.

## The basic workflow

1. **Create a `.dsl` file** — open it in VS Code and click the **ArchTect icon** in the editor title bar.
2. **Build visually** — drag elements, shapes, and cloud icons from the **Palette** (left panel) onto the canvas.
3. **Edit properties** — click an element or relationship to edit its name, description, technology, and tags in the **Inspector** (right panel).
4. **Create relationships** — drag from one element to another on the canvas.
5. **Switch views** — use the Views panel to navigate between System Context, Container, Deployment, and other views.
6. **Export** — export individual views as PNG or SVG.

!!! tip "Bidirectional sync"
    You can also edit the DSL directly — changes are reflected on the canvas automatically. Use whichever mode is most productive.

## What's in this guide

| Page | What it covers |
|---|---|
| [UI Reference](ui-layout.md) | Palette, canvas, toolbar, inspector, themes, layout engines |
| [View Types](view-types.md) | All view types: landscape, context, container, component, dynamic, sequence, filtered, deployment, custom |

## Projects

A project is a folder with at least one `.dsl` file. To get started:

- **New project**: Open the Command Palette → **ArchTect: New Project**, or create a folder with a `workspace.dsl` file.
- **Existing project**: open the `.dsl` file and click the ArchTect icon.
- **Split models**: use `!include` to compose a workspace from multiple files.

Keep a single primary workspace file (e.g. `workspace.dsl`) at the root of the folder.

See [Getting Started](../getting-started/index.md#your-first-project) for a step-by-step walkthrough.

## Editing

Editing in ArchTect can be done both visually and in the DSL:

### Visual editing (canvas + Palette)

- **Add elements** — drag element types, shapes, or cloud icons from the Palette onto the canvas.
- **Move elements** — drag to reposition; nudge with arrow keys.
- **Create relationships** — drag from one element to another.
- **Multi-select** — `Shift`+click to select multiple elements.
- **Group elements** — select multiple elements and use the group action (`Ctrl`+`G`).
- **Edit properties** — select an element or relationship and edit in the Inspector.
- **Delete** — select and press `Delete` or `Backspace`.

### DSL editing

For precise structural changes — names, descriptions, tags, relationships, view definitions — edit the DSL directly. Changes in the DSL are reflected on the canvas immediately.

See [UI Reference](ui-layout.md) and [View Types](view-types.md) for more.

## DSL reference

The Structurizr DSL is documented at [structurizr.com/help/dsl](https://structurizr.com/help/dsl). For what ArchTect specifically supports and any deviations, see [DSL support](../reference/dsl-support.md).
