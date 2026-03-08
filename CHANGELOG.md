# Changelog

All notable changes to the ArchTect extension will be documented in this file.

## [0.1.0] - 2026-02-23

### Added
- SVG export workflow:
  - Fixed bug to export edges
  - Ad-hoc export directly from an open diagram
  - Automatically saves SVG into the diagram’s corresponding `exports/` folder
  - Confirmation popup after successful export

- Documentation generation enhancements:
  - Automatic documentation generation/update when navigating away from a file
  - GitHub Copilot integration for documentation generation
  - Automatic inclusion of diagrams in the correct arc42 section

- Status bar integration:
  - Displays documentation generation progress in the VS Code status bar
  - Provides user feedback during generation

### Changed
- Improved documentation generation flow to keep DSL, diagrams, and docs synchronized with minimal manual steps.

---

## [0.0.1] - 2026-02-22

### Added
- Initial release of ArchTect
- Structurizr DSL architecture modeling support
- Visual diagram rendering
- Architecture documentation generation foundation