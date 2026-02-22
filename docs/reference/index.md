---
title: Reference & Troubleshooting
---

# Reference & Troubleshooting

---

## VS Code Commands

All commands are available in the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`).

| Command | Description |
|---|---|
| `ArchTect: Open Editor` | Open the ArchTect visual editor |
| `ArchTect: Open Project` | Open a folder or DSL file as a project |
| `ArchTect: Open with ArchTect` | Open the selected `.dsl` or `.nbc4` file |
| `ArchTect: New Project` | Scaffold a new workspace in a chosen folder |
| `ArchTect: Save` | Save the current workspace and layout |
| `ArchTect: Export PNG` | Export the active view as PNG |
| `ArchTect: Export SVG` | Export the active view as SVG |
| `ArchTect: Create View` | Add a new view to the workspace |
| `ArchTect: Edit Architecture Info` | Edit workspace name and description |
| `ArchTect: Generate Documentation` | Generate documentation artifacts |
| `ArchTect: Validate Architecture` | Run DSL validation and report errors |
| `ArchTect: Toggle Explorer` | Show or hide the left panel |
| `ArchTect: AI Assistant` | Open the AI assistant |
| `ArchTect: Show Copilot Diagnostics` | Show Copilot diagnostic info |
| `ArchTect: Open User Guide` | Open this documentation |

---

## File Types

| File | Purpose |
|---|---|
| `workspace.dsl` | Main model file (Structurizr DSL) |
| `workspace.json` | View layouts and editor state |
| `.dsl` | Any DSL file openable directly in ArchTect |
| `.nbc4` | ArchTect diagram file format |
| `docs/` | Optional folder for documentation or exported artifacts |

---

## DSL Grammar

The authoritative grammar used by ArchTect is in `frontend/src/lib/dsl/grammar.txt` inside the extension source. It describes the supported syntax, view types, and configuration options. The canonical language reference for Structurizr DSL is at [structurizr.com/help/dsl](https://structurizr.com/help/dsl).

For what ArchTect specifically supports, see [DSL Support Matrix](dsl-support.md).

---

## Troubleshooting

### Validation errors

If the DSL parser reports errors:
1. Open the dsl editor and check for error.
2. Fix the reported line and try again.
3. For syntax rules, check the [DSL Support Matrix](dsl-support.md) or the [Structurizr DSL](https://docs.structurizr.com/dsl/language) reference

### View not appearing

If a view doesn't show up in the Views panel:
- Confirm the view exists in the `views { }` block of your DSL.
- Check that the view key is unique across all views.
- For filtered views: a base view can be hidden once a filtered view is defined for it. This is expected Structurizr-compatible behavior.

