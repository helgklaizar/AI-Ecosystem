# AGENTS.md - Antigravity Bar

Welcome to the Antigravity Bar repository. This document serves as the entry point for all AI coding agents working on this project.

## 🛠 Tech Stack & Environment
- **Platform**: macOS Native Utility (Menu Bar app)
- **UI Standards**: Refer strictly to `DESIGN.md`. Do not hardcode custom hex colors if a system semantic macOS color (`label`, `secondaryLabel`) is available. Dark mode must be supported natively.

## 🏗 Coding Guidelines
- **System Integration**: Use native Apple APIs where natively possible to keep the app lightweight.
- **Performance is Critical**: Menu bar apps must have a minimal CPU/RAM footprint. Avoid unnecessary background loops.
- **Visuals**: Use SF Symbols. Maintain the "Clean & Native" Apple HIG look but with a "Pro" dark-first flair.

## 📝 Workflow
- Before creating visual components, read the token mappings in `DESIGN.md`.
- Keep commits isolated to specific features.
