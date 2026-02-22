---
title: User Guide
---

# User Guide

ArchTect is a diagram-as-code tool for software architecture. You write your model in **Structurizr DSL** — a plain text file — and ArchTect renders it as interactive diagrams. The DSL is the source of truth; the UI is how you navigate, explore, and export the result.

> Placeholder: Hero screenshot showing the full UI (left panel, canvas, inspector)

## The basic workflow

1. **Open a project** — a folder containing a `.dsl` workspace file.
2. **Write or edit the DSL** — define elements, relationships, and views.
3. **Browse the diagrams** — select a view in the left panel, explore it on the canvas.
4. **Inspect and refine** — select elements or relationships to see details in the inspector.
5. **Export** — export individual views as PNG or SVG.

ArchTect is available as a web app and as a VS Code extension. Both expose the same UI; the VS Code extension additionally gives you a live preview alongside your editor.

## What's in this guide

| Page | What it covers |
|---|---|
| [UI Reference](ui-layout.md) | The three-panel layout, toolbar controls, and the inspector |
| [View Types](view-types.md) | All view types: landscape, context, container, component, dynamic, sequence, filtered, deployment, custom |

## Projects

A project is a folder with at least one `.dsl` file. To get started:

- **New project**: create a folder, add a `workspace.dsl` file, open the folder in ArchTect.
- **Existing project**: open the folder. If multiple DSL files exist, select the one you want.
- **Split models**: use `!include` to compose a workspace from multiple files.

Keep a single primary workspace file (e.g. `workspace.dsl`) at the root of the folder. The file name matters only for your own organization; ArchTect reads any `.dsl` file you point it at.

See [Getting Started](../getting-started/index.md#your-first-project) for a step-by-step walkthrough.

## Editing

Editing in ArchTect is primarily done in the DSL. The UI lets you:

- **Move elements** on the canvas when manual layout is enabled (drag the element).
- **Multi-select** with click-drag or Shift+click to move or align groups.
- **Create relationships** by dragging from a node handle to another node (when editing is on).
- **Group elements** by selecting multiple elements and using the group action.
- **Override styles** per element or relationship via the inspector.

For precise changes — names, descriptions, tags, relationships — edit the DSL directly. Changes in the DSL are reflected in the diagram immediately.

See [UI Reference](ui-layout.md) and [View Types](view-types.md) for more.

## DSL reference

The Structurizr DSL is documented at [structurizr.com/help/dsl](https://structurizr.com/help/dsl). For what ArchTect specifically supports and any deviations, see [DSL support](../reference/dsl-support.md).
