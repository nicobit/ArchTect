---
title: Reference & Troubleshooting
---

# Reference & Troubleshooting

---

## VS Code Commands

### Command Palette commands

These commands are available via the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`):

| Command | Description |
|---|---|
| `ArchTect: New Project` | Scaffold a new workspace in a chosen folder |
| `ArchTect: Open Generation Center` | Open the documentation generation center |
| `ArchTect: Open User Guide` | Open this documentation |
| `ArchTect: Show Copilot Diagnostics` | Show Copilot diagnostic info |

### Entry points

| Action | How |
|---|---|
| Open a `.dsl` file visually | Open the file in VS Code → click the **ArchTect icon** in the editor title bar |
| Open via context menu | Right-click a `.dsl` file in Explorer → **ArchTect: Open with ArchTect** |

### Menu commands (available when editor is open)

| Command | Description |
|---|---|
| Export PNG / SVG | Export the active view |
| Generate Documentation | Generate arc42 documentation from the model |
| AI Assistant | Open the in-app AI assistant |

---

## File Types

| File | Purpose |
|---|---|
| `workspace.dsl` | Main model file (Structurizr DSL) |
| `.dsl` | Any DSL file openable directly in ArchTect |
| `.nbc4` | ArchTect diagram file format |

---

## Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl+Z` / `Ctrl+Y` | Undo / Redo |
| `Ctrl+0` | Fit to view |
| `Ctrl+A` | Select all |
| `Esc` | Deselect all |
| `Delete` / `Backspace` | Delete selected |
| `Shift+click` | Multi-select |
| `Space` + drag | Pan canvas |
| Arrow keys | Nudge selected elements |
| `Shift` + arrow keys | Large nudge |
| `Ctrl+G` | Group selected elements |
| `Ctrl+Shift+G` | Ungroup |
| `Ctrl+D` | Duplicate selected |
| `Ctrl+]` / `Ctrl+[` | Bring forward / send backward |

---

## DSL Grammar


For what ArchTect specifically supports, see [DSL Support Matrix](dsl-support.md).

---

## Troubleshooting

### Validation errors

If the DSL parser reports errors:
1. Open the DSL editor and check for errors.
2. Fix the reported line and try again.
3. For syntax rules, check the [DSL Support Matrix](dsl-support.md) or the [Structurizr DSL](https://docs.structurizr.com/dsl/language) reference.

### View not appearing

If a view doesn't show up in the Views panel:
- Confirm the view exists in the `views { }` block of your DSL.
- Check that the view key is unique across all views.
- For filtered views: a base view can be hidden once a filtered view is defined for it. This is expected Structurizr-compatible behavior.

### Missing icons in the Palette

If you expect to see cloud service icons (Azure, AWS, etc.) but the Palette only shows elements and shapes:
- Click the **Themes** button at the bottom of the Palette.
- Enable the relevant icon theme (e.g., "Azure (remote)", "AWS Icons").
- Or add a remote theme URL in your DSL `styles` block.
