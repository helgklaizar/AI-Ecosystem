# AI Ecosystem — Project Structure Standard

> This document defines the canonical layout for any AI development environment.
> It is version-controlled. When the app version changes, this document may evolve.

## Version: 1.0.0

---

## 📁 Level 1 — User Level (`~/`)

```
~/.ai/
└── antigravity/                  ← Antigravity (Gemini) config
    ├── settings.json             ← profile + selected AI tools
    ├── templates/
    │   ├── GEMINI.md             ← project context template
    │   ├── AGENTS.md             ← agent instructions template
    │   └── CLAUDE.md             ← Claude-specific template
    ├── global_workflows/         ← all workflow files (*.md)
    ├── skills/                   ← all skill files (by category)
    │   ├── frontend/
    │   ├── backend/
    │   ├── ml/
    │   ├── qa/
    │   └── tools/
    ├── knowledge/                ← Knowledge Items (KI)
    └── brain/                    ← local AI memory (per conversation)
```

**Set up by:** GravityHub installer app on first run.

---

## 📁 Level 2 — Workspace Level (`<projects_root>/`)

```
<projects_root>/
├── .ai/
│   └── agents/                   ← workspace-wide agents
│       ├── architect.md
│       ├── developer.md
│       ├── tester.md
│       ├── huxley-coder.md
│       ├── swarm-orchestrator.md
│       └── <profession-specific>.md
└── .cursorignore                 ← if Cursor is selected
```

**Set up by:** GravityHub on first run.

---

## 📁 Level 3 — Project Level (`<projects_root>/<project>/`)

```
<project>/
├── GEMINI.md                     ← if Antigravity selected
├── AGENTS.md                     ← if Antigravity or Claude selected
├── CLAUDE.md                     ← if Claude selected
├── .cursorrules                  ← if Cursor selected
├── DESIGN.md                     ← always (design tokens)
├── .gitignore                    ← always (per tech stack)
├── .ai/
│   ├── agents/                   ← project-specific agents
│   └── brain/                    ← local memory
│       └── .system_generated/
│           └── logs/
└── <source files>
```

**Set up by:** GravityHub "New Project" flow or manually.

---

## 📄 Key Files Reference

| File | Purpose | Tool |
|---|---|---|
| `GEMINI.md` | Project context for AI | Antigravity |
| `AGENTS.md` | Universal agent instructions | Antigravity + Claude |
| `CLAUDE.md` | Claude-specific instructions | Claude |
| `.cursorrules` | Cursor agent rules | Cursor |
| `DESIGN.md` | Design tokens (single source of truth) | All |
| `SKILL.md` | Agent skill definition | All |

---

## 🔄 Update Mechanism

GravityHub checks this repo on startup for new agents/workflows/skills.
If a newer commit is detected, it offers to sync the local installation.

Compatible with: **Antigravity (Gemini)**, **Claude**, **Cursor/Codex**, **GitHub Copilot**
