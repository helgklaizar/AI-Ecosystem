# 📖 ECOSYSTEM GUIDE: Essential Stack & Installation

Welcome to the **AI Ecosystem Guide**. This document defines the curated list of skills, workflows, and agents that are actually useful for our development stack. We keep our environment clean by ONLY downloading what we actively use.

---

## 🎯 Our Tech Stack & Focus Areas

Our projects typically revolve around the following technologies:
1. **Apple Silicon Native Development**: macOS Status Bars, Swift, SwiftUI, Tauri apps.
2. **Modern Web Development**: Next.js, React, Tailwind, and high-end animations (Framer Motion).
3. **AI Engineering**: Local LLMs (MLX), Python backend integrations, Agent orchestration.
4. **DevOps & QA**: Strict CI/CD pipelines, automated PR reviews, GitHub Actions.

---

## 📦 What to Download (The Curated List)

Instead of cluttering the system with thousands of unused skills, we only use the following high-value tools. **If a tool is not on this list, do not install it by default.**

### 1. Essential Global Workflows (`~/.gemini/antigravity/global_workflows/`)
These define how our AI operates on a macro level:
- `global_workflows/agent-orchestration/acceptance-orchestrator.md` — End-to-end task validation before completion.
- `global_workflows/ci-cd/github-workflow-automation.md` — Syncing projects and managing GitHub.
- `global_workflows/code-review/pr-writer.md` — Automates Pull Request creation and code review.
- `global_workflows/qa-testing/qa-orchestrator.md` — Autonomous QA node for code quality.
- `global_workflows/ci-cd/build-local.md` — Fast local builds, especially for desktop (Tauri/Swift) apps.
- `global_workflows/planning-design/session-recap.md` — (`/recap`) Saves session context to `SWARM_STATE.md` to prevent AI amnesia.

### 2. High-Priority Skills (`~/.gemini/antigravity/skills/`)
These give the AI specialized knowledge for our specific stack:
- `skills/frontend/swiftui-guidelines.md` & `skills/backend/macos-native-dev.md` — For building perfect native Mac apps.
- `skills/backend/python-fastapi-development.md` — Backend standards and patterns.
- `skills/frontend/nextjs-app-router.md` & `skills/frontend/frontend_best_practices.md` — For high-end UI creation.
- `skills/design-ui/ui-taste-design.md` — Enforces premium, non-generic design principles.
- `skills/automation-tools/bash-scripting.md` — For safe, defensive shell operations.

### 3. Core Agents (`~/.gemini/antigravity/agents/`)
Specialized personas:
- `Architect` — System design and file structure.
- `Developer` — Clean code execution.
- `QA Tester` — Automated testing and edge-case discovery.
- `DevOps` — Deployment and GitHub CI/CD setup.

### 4. Core Templates & Swarm Orchestration (`~/.gemini/antigravity/templates/`)
These govern project-level AI operations, context sharing, and multi-agent concurrency:
- `SWARM_STATE.md` — Mandatory handover document when switching between AI agents (e.g., Backend -> Frontend).
- `SECRETS_MAP.md` — Explains where to find environment variables locally (No hardcoding!).
- `GEMINI.md` — Base configuration template for initializing new repos.

#### Parallel Swarm Execution (Git Worktrees)
When coordinating multiple agents on the same project simultaneously (e.g., one agent building the UI, another writing backend tests), we use **Git Worktrees** to prevent merge conflicts and file locking.
- **Pattern:** `git worktree add ../feature-branch feature-branch`
- **Execution:** Agent A operates in `/PROJECT`, Agent B operates in `/feature-branch`. They coordinate via GitHub Issues or `SWARM_STATE.md` before merging back.

---

## 🏗️ The Flat Global Architecture Rule

**CRITICAL:** Do NOT create `.gemini/agents/` or `.gemini/skills/` folders inside individual project repositories (e.g., `PROD/my-app/.gemini/`). 
All AI assets MUST be stored centrally in `~/.gemini/antigravity/`. This prevents version drift, avoids context fragmentation ("blind spots"), and ensures the IDE's Status Bar tools work seamlessly across all your projects.

## ⚙️ How to Clean Your System

If your `~/.gemini/antigravity/skills/` folder has thousands of files, **it's time for a purge.**
You can ask your AI to delete everything except the core files listed above by saying:
> *"Please clean up my local skills and workflows, leaving only the essential stack from `ECOSYSTEM_GUIDE.md`."*

---

## 🚀 How to Install for a New Project

When setting up a new repository, do NOT copy the entire ecosystem.
1. Run the Onboarding script (`AI_ONBOARDING.md`).
2. The AI will read this Guide.
3. The AI will pull **only** the relevant workflows and skills based on the specific project's needs (e.g., pulling Swift skills only for a macOS project).
