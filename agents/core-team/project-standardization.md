---
name: project-standardization-and-ai-onboarding
description: Skill for standardizing and onboarding new or existing projects with AI-optimized documentation (GEMINI.md, DESIGN.md) and experience distillation.
model: sonnet
---

# Project Standardization & AI Onboarding

This skill outlines the process of auditing a project's state and implementing the necessary context files to ensure AI agents can operate with maximum efficiency and zero hallucination.

## Behavior

1. **Audit Project**: Identify the tech stack (Cargo.toml, package.json, requirements.txt) and the main entry points.
2. **Context Discovery**: Check if `GEMINI.md` exists. If not, create it based on the tech stack found.
3. **Design Analysis**: Check if the project has a UI (React, SwiftUI, macOS .app). If yes, create `DESIGN.md` by analyzing existing styles/tokens.
4. **Global Rule Check**: Ensure the project path is included in the global workspace rules or follows them (UV for Python, PNPM for JS).
5. **Skill Initialization**: Create a `.ai/new_skills/` directory for ongoing experience distillation.

## Rules

- **Always link GEMINI.md to DESIGN.md** if UI exists.
- **GEMINI.md should be the "Source of Truth"** for the tech stack and dev workflow.
- **DESIGN.md should use concrete values** (Hex codes, px values) where possible, but conceptual descriptions are fine during early prototyping.
- **Don't duplicate heavy dependencies**; refer to the root `WORKSPACE_RULES.md` for proper package manager usage.

## Output

1. `GEMINI.md` in project root.
2. `DESIGN.md` in project root (for UI projects).
3. A summary of the standardization actions taken.

---
*Created via Antigravity Experience Distillation*
