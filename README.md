<div align="center">
  <h1>🚀 Google Antigravity IDE: Spec-Driven AI Framework</h1>
  
  <p>
    <strong>An autonomous AI ecosystem designed specifically for Technical Product/Project Managers and Founders to automate end-to-end product creation.</strong>
  </p>

  <p>
    <a href="https://github.com/helgklaizar/antigravity-ai-framework/blob/main/LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-blue.svg"></a>
    <a href="#"><img alt="Status: Active" src="https://img.shields.io/badge/Status-Active-success.svg"></a>
    <a href="#"><img alt="Platform: Google Antigravity" src="https://img.shields.io/badge/Platform-Antigravity%20%7C%20Claude%20Code-orange"></a>
  </p>
</div>

---

## 📖 Project Vision & Target Audience

This framework was built with a clear purpose: **empowering Technical Product Managers (PMs) and Founders to build entire digital products autonomously**.

AI coding assistants (like Google Antigravity, Claude Code, or Cursor) often suffer from context bloat and unpredictable code generation. Left unchecked, agents act like hyperactive junior developers—eagerly writing 500 lines of broken code for features they barely understand, ignoring existing constraints or architecture.

This framework solves that by enforcing **Spec-Driven Development**. It forces the IDE to behave like a strict **Tech Lead / Automated Engineering Team**. The system will literally refuse to write large chunks of code without a proper `micro-spec.md` and rigorously enforces project memory. 

### Key Philosophy
1. **Architecture first, code second**: The agent halts abstract requests and forces a structured `/feature-interview` to gather business requirements before touching the codebase.
2. **Project Memory (`GEMINI.md`)**: The AI reads a single source of truth in your project root to understand the stack, boundaries, and technical debt, saving context window resources.
3. **No Bullshit Rule**: The AI is instructed to give ultra-short "yes/no" responses by default, act as your technical co-founder, and acknowledge errors instantly without hallucinating excuses.

---

## 📦 File Structure

Below is the complete blueprint of the framework. You map these into your global AI configuration directory.

```text
.
├── global_rules/               # Global IDE / Assistant instructions
│   ├── GEMINI.md               # Core rules and the template for Project Memory
│   └── agent-behavior.md       # Triggers that stop the AI from blindly coding
├── templates/                  # Standardized markdown documents
│   ├── project-index.md        # To record architectural boundaries and deployment links
│   └── micro-spec.md           # To document features, Non-Goals, and Acceptance Criteria
├── workflows/                  # Custom multi-step agent routines
│   ├── master.md               # The full CEO -> Engineer -> Developer -> QA Pipeline
│   ├── adversarial-review.md   # "Devil's Advocate" technical code review mode
│   ├── feature-interview.md    # Product requirement gathering mode
│   ├── deep-market-research.md # Deep social listening & competitor analysis
│   ├── ui-prototyping.md       # Programmable UI/Tailwind generation rules
│   ├── setup-pare.md           # Instructions to set up MCP structured output & openapi-to-cli
│   └── context-compress.md     # Memory cleanup to prevent hallucinations
└── skills/                     # 14+ specialized Google-ecosystem AI capabilities
    ├── browser-agent/          # Automated UI verification Subagent
    ├── deep-research/          # External documentation & context research
    └── ... (and many more)
```

---

## 🚀 Installation & Setup

To use this framework, you need to link or copy these rules into your IDE's global AI assistant brain.

### 1. Clone the repository
```bash
git clone https://github.com/helgklaizar/antigravity-ai-framework.git
cd antigravity-ai-framework
```

### 2. Apply to Google Antigravity (or similar standard helpers)
If you are using **Google Antigravity IDE** or an assistant that reads global configuration from an isolated dotfolder (e.g., `~/.gemini/`):

```bash
# 1. Ensure your global AI directory exists
mkdir -p ~/.gemini/

# 2. Copy the entire structure into your root config
cp -R global_rules/* ~/.gemini/
cp -R templates ~/.gemini/
cp -R workflows ~/.gemini/
cp -R skills ~/.gemini/antigravity/
```

*Note: For **Claude Code** or **Cursor**, add the contents of `global_rules/` into your IDE's custom Prompt Ruleset window.*

---

## 🛠 Usage Guide

### Creating a New Project
Whenever you scaffold a new repository, your **very first action** should be initiating the `GEMINI.md` file in your root folder:

```bash
cp ~/.gemini/templates/project-index.md ./GEMINI.md
```
*Fill in your tech stack, run commands, and architecture. The AI will read this file every time it opens the project.*

### Triggering Workflows
Interact with your AI using specific slash-commands mapped to the files in `workflows/`:

- **`/master`** — Bootstraps the full Orchestrator pipeline. The AI acts as your CEO (Idea validation), Engineer (Planning), Coder (Implementation), and QA Judge.
- **`/feature-interview`** — The AI will ask you precise product-management questions to narrow down a vague idea into concrete requirements.
- **`/deep-market-research`** — Triggers a parallel social-listening extraction across Reddit/Twitter/HN to validate PM hypotheses.
- **`/ui-prototyping`** — Forces the AI to bypass raw HTML and generate production-ready Tailwind/React code with proper icons and structured data.
- **`/adversarial-review`** — Paste your technical/product plan, and the AI will try to destroy it by finding edge cases, security flaws, and architectural bottlenecks before you waste time building it.

---

## 🤝 Contributing

We welcome contributions! If you have optimized prompts or new workflows (such as advanced PR reviews, deep-research flows, or specialized framework templates), feel free to open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
