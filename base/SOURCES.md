# 🧭 AI Ecosystem Actionable Index

**AGENT INSTRUCTION:** This is your primary database. If the user requests a new skill, agent, workflow, or capability that you do not currently possess, you MUST consult this list. Follow the extraction rules strictly.

---

## 🟢 Level 0: Native Ecosystem (Always Check First)

Before looking at the internet, pull from our own verified local storage.

### Antigravity Local Skills & Agents
- **Link/Path:** `~/.ai-ecosystem/skills/` and `~/.ai-ecosystem/agents/`
- **What it is:** Native workflows, agents, and skills curated specifically for this machine.
- **What to take:** Read the `*.md` files.
- **Where to put it:** 
  - For Antigravity: Inject directly into the current project's `.gemini/agents/` folder.
  - For other IDEs: Convert the markdown logic and inject into their respective native folders (e.g., `.cursor/rules/`).

---

## 🔵 Level 1: Tool-Specific Framework Rules

If the user wants rules for a specific technology stack (e.g., Next.js, Rust, SwiftUI), pull them from these community directories.

### Cursor Rules
- **Link:** [cursor.directory](https://cursor.directory/) or [PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules)
- **What it is:** The largest database of framework-specific rules.
- **What to take:** Extract the raw Markdown (`.mdc` or `.cursorrules`) text for the requested framework.
- **Where to put it:** Save it locally inside the project as `.cursor/rules/[framework].mdc`. *Do not forget to add YAML `globs` frontmatter if missing.*

### Windsurf Rules
- **Link:** [awesome-windsurf](https://github.com/detailobsessed/awesome-windsurf)
- **What it is:** Curated workflows for the Windsurf IDE.
- **What to take:** The markdown rule definitions.
- **Where to put it:** Save as `.windsurfrules` in the project root.

### Claude Code / Cline
- **Link:** [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) or [awesome-clinerules](https://github.com/JhonMA82/awesome-clinerules)
- **What it is:** CLI-optimized agent rules.
- **What to take:** XML or Markdown system prompt blocks.
- **Where to put it:** Append to the project's `CLAUDE.md`.

---

## 🟠 Level 2: Model Context Protocol (MCP) Servers

If the user needs to connect the IDE to external data (PostgreSQL, GitHub, Slack, Notion, Google Drive), you must install an MCP server.

### Official Anthropic MCP
- **Link:** [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
- **What it is:** Official servers for major platforms (Brave Search, Postgres, Git).
- **What to take:** The `npx` execution command or the Docker run command.
- **Where to put it:** Inject the JSON configuration into the IDE's global MCP settings file (e.g., `claude_desktop_config.json` or Cursor's MCP GUI config).

### Community MCP Registries
- **Link:** [punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers) or [Awesome-Claude-MCP-Servers](https://github.com/win4r/Awesome-Claude-MCP-Servers)
- **What it is:** Hundreds of community-built integrations.
- **What to take:** The installation instructions for the specific server the user requested.
- **Where to put it:** Follow the repository's setup guide (usually adding an entry to the global IDE config).

---

## 🔴 Level 3: Global Repositories (For Complex AI Tasks)

If you need entire new paradigms, sub-agents, or complex API integrations.

### Agent Frameworks & Personas
- **Link:** [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
- **What it is:** Specialized sub-agent personas (e.g., DevOps specialist, QA tester).
- **What to take:** The prompt persona text.
- **Where to put it:** Save as a new `.md` file in `~/.ai-ecosystem/agents/` so all projects can access it later.

### Global AI Developer Tools (Awesome Lists)
- **Links:** 
  - [sourcegraph/awesome-code-ai](https://github.com/sourcegraph/awesome-code-ai)
  - [awesome-ai-coding-tools](https://github.com/ai-for-developers/awesome-ai-coding-tools)
  - [awesome-claude-prompts](https://github.com/langgptai/awesome-claude-prompts)
- **What it is:** Massive indexes of everything related to AI coding.
- **What to take:** If the user asks "Find me a tool that does X", scrape these READMEs, summarize the top 3 tools, and present them in chat. Do NOT inject files blindly.
