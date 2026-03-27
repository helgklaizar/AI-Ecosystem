# Antigravity Spec-Driven AI Framework

A structured, predictable, and highly efficient AI agent ecosystem designed for Google Antigravity IDE (and adaptable to Claude Code or cursor). This framework stops the AI from blindly generating massive amounts of broken code by enforcing a **Spec-Driven Development** approach, a multi-stage orchestrator, and strict project-level memory.

## Core Philosophy

1. **Architecture first, code second**: The agent is restricted from writing code for large epics or abstract requests without first generating a `micro-spec.md` or doing a `/feature-interview`.
2. **Project Memory**: Every project must contain a `GEMINI.md` file in its root directory containing tech stack, architectural decisions, technical debt, and pending tasks. This acts as the agent's short-term memory, eliminating the need to read 30+ files on startup.
3. **No Bullshit Rule**: The AI is instructed to give ultra-short "yes/no" responses by default, acknowledge errors instantly, and only elaborate when asked.

## Framework Structure

This repository provides the configuration files you need to map into your global IDE AI settings (e.g., `~/.gemini/` for Antigravity).

```
.
├── global_rules/
│   ├── GEMINI.md           # Global rules and the template project memory file
│   └── agent-behavior.md   # System prompts to trigger spec-driven development
├── templates/
│   ├── project-index.md    # Template for architectural boundaries and constraints
│   └── micro-spec.md       # Template for feature specifications and Acceptance Criteria
└── workflows/              # Orchestrator and specific AI modes
    ├── master.md           # The Master Orchestrator (Full Track vs Fast Track)
    ├── adversarial.md      # "Devil's Advocate" technical review mode
    └── feature-interview.md# Requirement gathering interview mode
```

## Setup & Implemenation

1. Copy the contents of this repository to your AI assistant's global configuration directory (e.g., `~/.gemini/` or `~/.config/claude-code/`).
2. Add the path to `global_rules/GEMINI.md` to your custom AI prompt settings.
3. For any new project you start, copy the `GEMINI.md` template into the project root directory.

## Features

### 1. Spec-Driven Triggers
The AI is instructed to stop and ask:
- *"This is too broad. Let's do a `/feature-interview` to narrow down the scope?"*
- *"This is a major feature. Shall we write a `micro-spec.md` with Acceptance Criteria first?"*
- *"Do you want me to run this through an `/adversarial-review` to find edge cases before we code?"*

### 2. The Master Orchestrator (`/master`)
Complex tasks flow through specialized "agent states":
- **CEO Mode**: Validates the business idea.
- **Engineering Mode**: Plans the architecture.
- **Implementation Mode**: Writes the code.
- **Smoke Test Mode**: Validates functionality via browser/terminal subagents.
- **Audit Judge Mode**: Checks for vulnerabilities and technical debt.
- **Context Compress**: Updates the project's `GEMINI.md` and clears context to save tokens.

## License
MIT
