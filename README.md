# AI Ecosystem

> A profession-aware AI development environment setup system.

**AI Ecosystem** is a methodology + toolkit that configures your local machine for AI-assisted development — automatically, based on your role and tech stack.

You get the right agents, workflows, and skills for your profession. Nothing more, nothing less.

---

## How It Works

## How It Works

```
1. Give this repository link to your AI (Antigravity, Cursor, Claude).
2. Ask the AI to read `AI_ONBOARDING.md`.
3. The AI will conduct a quick onboarding interview in the chat.
4. The AI uses its terminal access to automatically deploy your environment:
   ├── ~/.gemini/            ← global AI config
   ├── <projects>/.gemini/   ← workspace agents
   └── Copied from this repo:
       ├── agents/           ← for your profession
       ├── workflows/        ← for your stack
       └── skills/           ← specific skills you need
```

No manual setup. No standalone installers. Just talk to your AI.

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

AI-Ecosystem/
├── AI_ONBOARDING.md      ← The Agent Setup Script (Start here!)
├── base/
│   ├── STRUCTURE.md      ← the standard: what files go where and why
│   └── SOURCES.md        ← attribution for external skills/workflows
│
├── agents/               ← AI agent definitions (.md)
├── workflows/            ← global workflow guides (.md)
├── skills/               ← modular skill packs by category
│   ├── frontend/
│   ├── backend/
│   ├── ml/
│   ├── qa/
│   └── tools/
└── templates/            ← base templates (GEMINI.md, AGENTS.md, CLAUDE.md)

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
| **Claude** | `CLAUDE.md`, `AGENTS.md`, `.claude/` hierarchy |
| **Cursor** | `.cursorrules`, `.cursorignore`, `.cursor/rules/` hierarchy |
| **GitHub Copilot** | `.github/copilot-instructions.md`, `.github/copilot-agents/` hierarchy |
| **Windsurf** | `.windsurfrules`, `.windsurf/rules/` hierarchy |

---

## Agent-Driven Setup (Eat Your Own Dogfood)

We replaced the standalone macOS installer with a pure Agentic workflow. 
Why download a standalone app when an AI can just read a file and configure your system itself?

**How to start:**
1. Open Antigravity (or your preferred AI agent).
2. Say: *"Read `AI_ONBOARDING.md` from the AI-Ecosystem repo and bootstrap my system."*
3. The AI will ask where your projects are, scan the directory, and then ask you about your profession and stack.
4. The AI will automatically run the bash commands needed to deploy the ecosystem across your machines.

It is fully idempotent (safe to run multiple times) and automatically maps your tools (Cursor, Claude, Copilot) to the single source of truth.

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

This repository is the source of truth for all configs. To update your local installation, simply ask your AI agent to run `AI_ONBOARDING.md` again. It will safely merge any new templates or agents without destroying your local project code.

---

## License

MIT
