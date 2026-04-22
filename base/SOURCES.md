

> [!IMPORTANT]
> **Universal Skills Integration:** Most rules and MCPs from external sources have been downloaded and universalized in our `skills/` directory. Check local skills before fetching from the internet.
# 🧭 AI Ecosystem Actionable Index

**AGENT INSTRUCTION:** This is your primary database. If the user requests a new skill, agent, workflow, or capability that you do not currently possess, you MUST consult this list. Search the categories below, extract the necessary files, and inject them into the user's project.

---

## 🛠 1. Skills and MCP Servers (Where to get Skills)
*If the user needs to connect a database, GitHub, Slack, web search, or specific CLI utilities.*

### MCP Servers (Model Context Protocol)
- **🔗 [punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)** (85k+ Stars)
- **🔗 [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)** (Official Anthropic servers)
- **🔗 [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)** (55k+ Stars)
- **🎯 What to take:** `npx` or Docker installation commands.
- **📥 Where to put it:** Add to the global `claude_desktop_config.json` or Cursor MCP settings.

### Antigravity & Local Skills
- **🔗 [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)** (34k+ Stars)
- **🔗 [anthropics/skills](https://github.com/anthropics/skills)** — Official Anthropic repository for Agent Skills. High-signal, official prompts.
- **🔗 [mgechev/skills-best-practices](https://github.com/mgechev/skills-best-practices)** — Best practices for writing professional-grade skills and maintaining lean contexts.
- **🎯 What to take:** Markdown files (`*.md`) from the `/skills/` folder.
- **📥 Where to put it:** Save locally in `~/.gemini/antigravity/skills/`.

---

## 🤖 2. Agents (Where to get Agents)
*If the user asks to add a QA tester, DevOps engineer, or other specialized AI colleague.*

### Sub-Agents & Personas
- **🔗 [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)** (17k+ Stars)
- **🔗 [huggingface/smolagents](https://github.com/huggingface/smolagents)**
- **🎯 What to take:** System prompt text (agent persona).
- **📥 Where to put it:** Create a new `.md` file in `~/.gemini/antigravity/agents/`.

---

## 🔄 3. Workflows and Rules (Where to get Workflows & Rules)
*If the user needs coding standards for React, Rust, Python, Next.js, or general pipelines.*

### Cursor & Windsurf Rules
- **🔗 [cursor.directory](https://cursor.directory/)**
- **🔗 [PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules)** (39k+ Stars)
- **🔗 [detailobsessed/awesome-windsurf](https://github.com/detailobsessed/awesome-windsurf)**
- **🎯 What to take:** Raw Markdown text (`.mdc` or `.cursorrules`).
- **📥 Where to put it:** Save to `.cursor/rules/[name].mdc` (do not forget the YAML `globs` header) or to `.windsurfrules`.

### Claude & Cline Rules
- **🔗 [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)** (40k+ Stars)
- **🔗 [JhonMA82/awesome-clinerules](https://github.com/JhonMA82/awesome-clinerules)**
- **🎯 What to take:** XML blocks or Markdown rules.
- **📥 Where to put it:** Append to the `CLAUDE.md` file in the project root.

---

## 📝 4. Prompts (Where to get Prompts)
*If the user asks for a complex roleplay prompt or a specific LLM request.*

### Global Prompt Libraries
- **🔗 [f/prompts.chat](https://github.com/f/prompts.chat)** (160k+ Stars)
- **🔗 [langgptai/awesome-claude-prompts](https://github.com/langgptai/awesome-claude-prompts)**
- **🎯 What to take:** Role model text (e.g., "Act as a Linux Terminal").
- **📥 Where to put it:** Use directly in chat or save to `~/.gemini/antigravity/workflows/`.

---

## 🏛️ 5. Emerging AI Standards & "Illuminati" Workflows
*Industry standards for AI context mapping and workflows inspired by top researchers (e.g., Andrej Karpathy).*

### "README for AI" Standards
- **🔗 AGENT.md / AGENTS.md Standard:** The movement to unify AI context. `AGENTS.md` is becoming the standard for GitHub Copilot. (e.g., `github.com/agent-md`).
- **🔗 DESIGN.md Pattern:** Introduced by tools like Google Stitch. It provides a structured Markdown file containing design tokens and visual do's/don'ts specifically for LLMs.
- **🎯 What to take:** The Markdown structure and YAML frontmatter conventions for AI.
- **📥 Where to put it:** Into our `~/.gemini/antigravity/templates/` folder as base patterns.

### The "Karpathy" Approach (Software 2.0 / Flat Context)
Andrej Karpathy (former Tesla AI / OpenAI) advocates for ultra-clean, flat C-style code and high-signal, low-noise context for LLMs.
- **🔗 [karpathy/llm.c](https://github.com/karpathy/llm.c)** — A masterclass in writing minimal, dependency-free code that LLMs can digest entirely in one shot.
- **🔗 [karpathy/minGPT](https://github.com/karpathy/minbpe)** — Clean, instructional implementations.
- **🎯 What to take:** The principle of "Dry Context" (no OOP bloat, flat topologies, pure C/Python patterns). This perfectly aligns with our `Flat Global Architecture Rule`.
- **📥 Where to put it:** Embed these principles directly into our `GEMINI.md` architectural rules.
