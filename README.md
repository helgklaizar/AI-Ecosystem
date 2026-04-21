# AI Ecosystem

> A profession-aware AI development environment setup system.

**AI Ecosystem** is a methodology + toolkit that configures your local machine for AI-assisted development — automatically, based on your role and tech stack.

You get the right agents, workflows, and skills for your profession. Nothing more, nothing less.

---

## How It Works

```
1. Run Configurator (macOS app)
2. Answer 5 questions in a chat:
   └── Name / Profession / Stack / AI Tools / Projects folder
3. Your environment is configured automatically:
   ├── ~/.gemini/            ← global AI config
   ├── <projects>/.gemini/   ← workspace agents
   └── Downloaded from this repo:
       ├── agents/           ← for your profession
       ├── workflows/        ← for your stack
       └── skills/           ← specific skills you need
```

No manual setup. No copy-pasting configs. Just open the app and answer questions.

---

## What Gets Installed

The setup is profession-specific. Examples:

| Profession | Agents | Workflows | Skills |
|---|---|---|---|
| **ML Engineer** | architect, quant-analyst, developer | mac-port-factory, quant-scout, quant-backtest | python-async, mlx-optimizer |
| **Frontend Dev** | architect, developer, tester | new-project, crash-detect | react-components, ui-ux-animator, tauri-integrator |
| **iOS / macOS Dev** | architect, developer, tester | build-local, new-project | macos-native-dev |
| **Backend Dev** | architect, developer, devops, tester | safe-prod-sync, pentest-qa | python-async, rust-systems, sandbox-orchestrator |
| **DevOps** | architect, devops, tester | safe-prod-sync, deploy-prod | sandbox-orchestrator |
| **Designer** | architect, developer | new-project | ui-ux-animator, react-components |

All professions also receive a base set: `huxley-coder`, `swarm-orchestrator`, `code-reviewer`, `debugger`, `new-project`, `github-publish`, `crash-detect`.

---

## Repository Structure

```
AI-Ecosystem/
├── base/
│   ├── STRUCTURE.md      ← the standard: what files go where and why
│   └── SOURCES.md        ← attribution for all external skills/workflows
│
├── agents/               ← AI agent definitions (.md)
├── workflows/            ← global workflow guides (.md)
├── skills/               ← modular skill packs by category
│   ├── frontend/
│   ├── backend/
│   ├── ml/
│   ├── qa/
│   └── tools/
├── templates/            ← base templates (GEMINI.md, AGENTS.md, CLAUDE.md)
│
└── installer/            ← Configurator: macOS app that runs the setup
    ├── Package.swift
    └── Sources/Configurator/
```

---

## The Methodology

Every project configured by AI Ecosystem follows a 3-level structure:

**Level 1 — User** (`~/.gemini/antigravity/`)
Global config, templates, workflows, and skills shared across all your projects.

**Level 2 — Workspace** (`<projects_root>/.gemini/`)
Workspace-wide agents available in every project in that folder.

**Level 3 — Project** (`<project>/`)
Project-specific files: `GEMINI.md`, `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `DESIGN.md`, local memory (`brain/`), git.

This structure is defined in [`STRUCTURE.md`](./base/STRUCTURE.md) and evolves with each version of the app.

---

## Supported AI Tools

AI Ecosystem is not tied to one tool. During setup you pick what you use:

| Tool | Config files generated |
|---|---|
| **Antigravity / Gemini** | `GEMINI.md`, `AGENTS.md`, `.gemini/` hierarchy |
| **Claude** | `CLAUDE.md`, `AGENTS.md` |
| **Cursor / Codex** | `.cursorrules`, `.cursorignore` |

---

## Configurator App (macOS Installer)

The `installer/` folder contains the Swift macOS app that drives the setup.

**Features:**
- Chat-based onboarding — no forms, just a conversation
- Downloads the right files from this repo for your profession
- Real-time setup log in chat
- Auto-updates: checks this repo for new agents/workflows on startup
- App updater: checks GitHub Releases for new versions of Configurator itself
- Commands after setup: `статус`, `обновить`, `починить`

**Build:**
```bash
cd installer
swift build
swift run
```

**Requirements:** macOS 13+, Swift 5.9+

---

## Skill Sources

Skills come from multiple curated sources. See [`SOURCES.md`](./base/SOURCES.md) for full attribution.

Key external sources:
- [angular/skills](https://github.com/angular/skills) — Angular Team
- [stripe/agent-toolkit](https://github.com/stripe/agent-toolkit) — Stripe Team  
- [vercel/vercel](https://github.com/vercel/vercel) — Vercel Team
- [trycourier/courier-skills](https://github.com/trycourier/courier-skills) — Courier Team
- [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) — community index

---

## Updates

This repository is the source of truth for all configs. When you run `обновить` in Configurator, it pulls the latest agents, workflows, and skills from here and updates your local installation.

---

## License

MIT
