<div align="center">
  <h1>🚀 Antigravity Spec-Driven AI Framework</h1>
  
  <p>
    <strong>A structured, predictable, and highly efficient AI agent ecosystem designed for IDE-based AI Assistants.</strong>
  </p>

  <p>
    <a href="https://github.com/helgklaizar/antigravity-ai-framework/blob/main/LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-blue.svg"></a>
    <a href="#"><img alt="Status: Active" src="https://img.shields.io/badge/Status-Active-success.svg"></a>
    <a href="#"><img alt="Platform: IDE AI" src="https://img.shields.io/badge/Platform-Antigravity%20%7C%20Claude%20Code%20%7C%20Cursor-orange"></a>
  </p>
</div>

---

## 📖 About Us & Project Vision

This framework was born out of a real-world necessity: AI coding assistants (like Google Antigravity, Claude Code, or Cursor) often suffer from context bloat and unpredictable, destructive code generation. Left unchecked, agents will eagerly write 500 lines of broken code for features they barely understand, without considering existing architecture or constraints.

We built this framework to enforce **Spec-Driven Development**. Instead of an overly obedient "code generator", this system turns the AI into a strict "Tech Lead" that refuses to write large chunks of code without a proper `micro-spec.md` and enforces rigorous project memory.

### Key Philosophy
1. **Architecture first, code second**: The agent halts abstract requests and forces a `/feature-interview`.
2. **Project Memory (`GEMINI.md`)**: The AI doesn't need to read 50 files. It reads one central file in your project root to understand your stack, constraints, and tech debt.
3. **No Bullshit Rule**: The AI is instructed to give ultra-short "yes/no" responses by default and acknowledge errors instantly.

---

## 📦 File Structure

Below is the complete blueprint of the framework. You map these into your global AI configuration.

```text
.
├── global_rules/               # Global IDE / Assistant instructions
│   ├── GEMINI.md               # The core instruction set and the template for Project Memory
│   └── agent-behavior.md       # Triggers that stop the AI from blindly coding large tasks
├── templates/                  # Standardized documents for your projects
│   ├── project-index.md        # To record architectural boundaries and deployment links
│   └── micro-spec.md           # To document features, Non-Goals, and Acceptance Criteria
└── workflows/                  # Custom multi-step agent routines
    ├── master.md               # The CEO -> Engineer -> Developer -> QA Pipeline
    ├── adversarial.md          # "Devil's Advocate" technical review mode
    └── feature-interview.md    # Requirement gathering mode
```

---

## 🚀 Installation & Setup

To use this framework, you need to link or copy these rules into the brain of your IDE's AI assistant.

### 1. Clone the repository
```bash
git clone https://github.com/helgklaizar/antigravity-ai-framework.git
cd antigravity-ai-framework
```

### 2. Apply to your AI Configuration
If you are using **Antigravity IDE** or a similar assistant that reads global configuration from an isolated dotfolder (e.g., `~/.gemini/`):

```bash
# 1. Ensure your global AI directory exists
mkdir -p ~/.gemini/templates ~/.gemini/workflows

# 2. Copy the behavior rules
cp global_rules/GEMINI.md ~/.gemini/
cp global_rules/agent-behavior.md ~/.gemini/

# 3. Copy the templates and workflows
cp templates/* ~/.gemini/templates/
cp workflows/* ~/.gemini/workflows/
```

*Note: For **Claude Code** or **Cursor**, add the contents of `global_rules/` into your custom Prompt Instructions/Ruleset.*

---

## 🛠 Usage Guide

### Creating a New Project
Whenever you scaffold a new repository, your **very first action** should be creating `GEMINI.md` in the root folder:

```bash
cp ~/.gemini/global_rules/GEMINI.md ./GEMINI.md
```
*Fill in your tech stack, run commands, and architecture. The AI will read this file every time it opens the project.*

### Triggering Workflows
Interact with your AI using specific slash-commands based on the files in `workflows/`:

- **`/master`** — Bootstraps the full Orchestrator pipeline. The AI will act as CEO (Idea), Engineer (Plan), Coder (Implementation), and Judge (QA).
- **`/feature-interview`** — The AI will ask you questions to narrow down a vague idea into concrete requirements.
- **`/adversarial-review`** — Paste your technical plan, and the AI will try to destroy it by finding edge cases, security flaws, and architectural bottlenecks.

---

## 🤝 Contributing

We welcome contributions! If you have optimized prompts or new workflows (such as advanced PR reviews, deep-research workflows, or specialized framework templates), feel free to open a Pull Request.

1. Fork the repo.
2. Create your feature branch (`git checkout -b feature/amazing-workflow`).
3. Commit your changes (`git commit -m 'Add amazing workflow'`).
4. Push to the branch (`git push origin feature/amazing-workflow`).
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
