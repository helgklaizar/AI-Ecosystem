# Antigravity AI Ecosystem

Welcome to the **Antigravity AI Ecosystem**. This repository contains a tailored setup of skills, workflows, agents, and templates explicitly adapted for the **Google Antigravity IDE**.

> **Note:** This system is constructed specifically for the **local Antigravity application** environment. We do NOT support cloud instances or other generalized toolkits, as these configurations rely heavily on the precise capabilities, project structure, and context parameters strictly native to the Antigravity IDE desktop environment.

## 🧩 Ecosystem Architecture

This ecosystem scales your productivity within the Antigravity IDE through an integrated library of processes both at the global environment and local workspace level:

### 1. Global Workflows (`/global_workflows`)
A powerful, diverse set of markdown-based workflows acting as deterministic execution plans for the global IDE:
- **Slash Commands:** Seamlessly execute by invoking `/[slash-command]`.
- **System Automation:** Supports fully automated pipelines like `/auto-test-loop`, `/deploy-desktop`, or `/feature-planning`.

### 2. Project Agents (`/agents`)
A dense selection of role-specific definitions meant for your local IDE workspace (`.gemini/agents/`). These grant specialized behaviors to the agent based on tasks:
- **Examples:** `architect.md`, `devops.md`, `quant-analyst.md`, `tester.md`, and more.

### 3. Comprehensive Skills Library (`/skills`)
A massive categorization of technical guidelines detailing *how* to perform granular analysis or specific domain logic. Included categories:
- **`ai/` & `tools/`:** Guidelines for integrating Gemini, Vertex, and prompt mastery.
- **`backend/`:** Extensive low-level systems logic, Rust optimizations, profilers, and zephyr RTOS integrations.
- **`frontend/`:** React, Tauri, and macOS native development practices.
- **`qa/`:** Checklists and pipelines for code reviews, testing, and system security auditing.

### 4. Templates (`/templates`)
Foundational templates, such as `GEMINI.md`, providing persistent memory and project intelligence protocols to ensure that Antigravity maintains its situational awareness across complex project lifecycles.

## 🚀 Setup & Integration

To inject this ecosystem into your Antigravity IDE:

1. **Clone this repository**:
   ```bash
   git clone https://github.com/helgklaizar/Antigravity-AI-Ecosystem.git
   ```
2. **Global Logic**: Copy `global_workflows`, `skills`, and `templates` folders to your core IDE config path (typically `~/.gemini/antigravity/`).
3. **Workspace Logic**: For project-specific setups across codebases, copy the `agents`, `skills`, and `workflows` directories directly into your workspace's local `.gemini/` directory (e.g., `<your-project>/.gemini/`).
4. **Restart Context**: Begin typing a slash `/` or `@` in your prompt window to see the exhaustive list of new configurations.

### 🛡️ Security
This public release has been carefully sanitized. It contains no API keys, tokens, or environment secrets. Everything is thoroughly reviewed for safe deployment to your local machine.
