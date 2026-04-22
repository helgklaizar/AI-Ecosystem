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
└── .gemini/
    └── agents/                   ← workspace-wide agents
        ├── architect.md
        ├── developer.md
        ├── tester.md
        ├── huxley-coder.md
        ├── swarm-orchestrator.md
        └── <profession-specific>.md
```

**Set up by:** GravityHub on first run.

---

## 📁 Level 3 — Project Level (`<projects_root>/<project>/`)

```
<project>/
├── GEMINI.md                     ← Antigravity context
├── DESIGN.md                     ← always (design tokens)
├── .gitignore                    ← always (per tech stack)
├── .gemini/
│   ├── agents/                   ← project-specific agents
│   └── brain/                    ← local memory
│       └── logs/                 ← execution logs
└── <source files>
```

**Set up by:** GravityHub "New Project" flow or manually.

---

## 📄 Key Files Reference

| File | Purpose | Tool |
|---|---|---|
| `GEMINI.md` | Project context for AI | Antigravity |
| `AGENTS.md` | Universal agent instructions | Antigravity |
| `DESIGN.md` | Design tokens (single source of truth) | Antigravity |
| `SKILL.md` | Agent skill definition | Antigravity |

---

## 🔄 Update Mechanism

GravityHub checks this repo on startup for new agents/workflows/skills.
If a newer commit is detected, it offers to sync the local installation.

Compatible with: **Antigravity (Gemini)**


---

## 🚀 The New Universal Ecosystem Mapping

We have introduced a 3-pillar universal architecture alongside `base/`:
1. `agents/`: The Doers (AI personas).
2. `skills/`: The Knowledge (IDE rules, MCPs, API docs).
3. `workflows/`: The Processes (step-by-step guides).

Base files in this directory are integrated with these 3 pillars automatically.
