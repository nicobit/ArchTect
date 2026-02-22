---
title: Getting Started
---

# Getting Started

Choose the path that matches how you use ArchTect.

---

## VS Code Extension

### Install
1. Install the extension from the VS Code Marketplace or from a VSIX provided by your team.
2. Reload VS Code if prompted.

### Open the editor
1. Open the Command Palette and run `ArchTect: Open Editor`.
2. Or right-click a `.dsl` file and choose `ArchTect: Open with ArchTect`.

### Create a new project
1. Open the Command Palette and run `ArchTect: New Project`.
2. Choose a parent folder and a project name.
3. The extension creates:
   - `workspace.dsl` — your model
   - `workspace.json` — layout data
   - `docs/` — empty by default

### Open an existing project
1. Open the Command Palette and run `ArchTect: Open Project`.
2. Pick a folder that contains a `.dsl` file, or pick a `.dsl` or `.nbc4` file directly.

### Optional sidebar
Enable the ArchTect sidebar in the Activity Bar via Settings → `ArchTect: Show Sidebar`.

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
1. Open the file in ArchTect.
2. Select the System Context view in the Views panel.
3. Drag nodes to adjust layout (enable manual layout first).
4. Save to persist layout in `workspace.json`.

---

## UI Tour

ArchTect has four main areas:

| Area | Purpose |
|---|---|
| **Left panel** | Switch views, browse the model |
| **Canvas** | View and interact with the diagram |
| **Inspector** (right panel) | Edit properties of selected element, relationship, or view |
| **Toolbar** | Layout controls, export, theme, fit-to-screen |

For a full breakdown of every control, see [UI Reference](../user-guide/ui-layout.md).
