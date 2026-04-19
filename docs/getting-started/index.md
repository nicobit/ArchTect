---
title: Getting Started
---

# Getting Started

Choose the path that matches how you use ArchTect.

---

## VS Code Extension

### Install
1. Install the extension from the [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=nicola-bitetti.archtect) or from a VSIX provided by your team.
2. Reload VS Code if prompted.

### Open a DSL file
1. Create or open any `.dsl` file in VS Code.
2. Click the **ArchTect icon** in the editor title bar to open the visual canvas.
3. Or right-click the file in the Explorer and choose **ArchTect: Open with ArchTect**.

### Create a new project
1. Open the Command Palette (`Ctrl+Shift+P`) and run **ArchTect: New Project**.
2. Choose a parent folder and a project name.
3. The extension creates a `workspace.dsl` file with a starter model.

### Supported file types
- `.dsl` — Structurizr DSL workspace
- `.nbc4` — ArchTect diagram file

---

## Browser App

1. Open the ArchTect web app URL provided by your team.
2. Sign in if your deployment requires authentication.
3. Create or open a workspace using the UI.

The browser app uses the same modeling concepts as the VS Code extension.

---

## Your First Project

Paste this into a new `workspace.dsl` file:

```dsl
workspace "My Workspace" {
  model {
    user = person "User"
    system = softwareSystem "My System"
    user -> system "Uses"
  }

  views {
    systemContext system {
      include *
      autoLayout
    }
  }
}
```

Then:

1. Open the file in VS Code.
2. Click the **ArchTect icon** in the editor title bar — the visual canvas opens.
3. The System Context view appears on the canvas with your elements laid out automatically.
4. **Add elements visually** — drag element types, shapes, or cloud icons from the **Palette** (left panel) onto the canvas.
5. **Create relationships** — drag from one element to another on the canvas.
6. **Edit properties** — click an element and edit its name, description, and technology in the **Inspector** (right panel).

The DSL updates automatically as you make changes on the canvas — and vice versa.

!!! tip "Add cloud icons"
    Activate icon themes (Azure, AWS, etc.) via the **Themes** button at the bottom of the Palette to get searchable cloud service icon libraries.

---

## UI Tour

ArchTect has four main areas:

| Area | Purpose |
|---|---|
| **Palette** (left panel) | Drag-and-drop elements, shapes, and cloud icons; switch views; theme picker |
| **Canvas** (center) | View and interact with the diagram |
| **Inspector** (right panel) | Edit properties of selected element, relationship, or view |
| **Toolbar** (top) | Export, zoom controls, undo/redo |

For a full breakdown of every control, see [UI Reference](../user-guide/ui-layout.md).
