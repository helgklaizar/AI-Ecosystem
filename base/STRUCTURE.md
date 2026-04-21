# AI Ecosystem — Universal Architecture Standard

> This document defines the canonical layout for any AI development environment.
> "Everything is a Skill, an Agent, or a Workflow."

## 📁 Repository Root (`AI-Ecosystem/`)

```
AI-Ecosystem/
├── agents/                   ← The Doers: AI personas and system prompts (e.g., backend-developer.md)
├── skills/                   ← The Knowledge: Universal capabilities, IDE rules, MCP configurations, API docs
├── workflows/                ← The Processes: Step-by-step operational guides
└── base/                     ← The Templates: Base files injected into new projects
```

## 📄 Base Templates (`base/`)

These files act as the foundation for any new project that hooks into the ecosystem.

| File | Universal Purpose |
|---|---|
| `PROJECT_CONTEXT.md` | The single source of truth for project stack, goals, and status. |
| `AGENTS.md` | The universal manifesto dictating how any AI should behave in the project. |
| `CLAUDE.md` | Universal gateway for Claude (instructs it to read the files above). |
| `.cursorrules` | Universal gateway for Cursor (instructs it to read the files above). |
| `DESIGN.md` | Universal design tokens and UI standard. |
| `PROFESSIONS_ANALYSIS.md` | Ecosystem taxonomy and domain breakdown. |
| `SOURCES.md` | Ecosystem origins and skill mapping. |

## 🔄 Universal Adaptation

Every tool (Cursor, Windsurf, Claude Code, Gemini) is treated simply as an execution interface. 
They all read from the same `PROJECT_CONTEXT.md` and utilize the exact same `skills/` and `agents/` libraries.
There is no vendor lock-in.
