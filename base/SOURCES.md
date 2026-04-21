# AI Ecosystem Sources & Registries

This repository acts as the central hub (Ecosystem) for your AI development. When you need to expand your AI's capabilities, do not invent things from scratch. Use this directory to pull from the best open-source community standards.

## 1. 🤖 Agents & Roles
When generating new agent personas (e.g., QA, DevOps, Quant), consult these sources for inspiration:
- **[VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)**: Huge database of specialized agents for terminal/CLI execution.
- **[smolagents](https://github.com/huggingface/smolagents)**: HuggingFace's library for building minimalist, powerful agents.

## 2. 📜 System Prompts & Rules (.mdc / .cursorrules)
If you need rules for a specific framework (e.g., Next.js, SwiftUI, Rust), pull community-tested templates from here:
- **[cursor.directory](https://cursor.directory/)**: The largest web directory of framework-specific `.cursorrules` and `.mdc` files.
- **[PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules)**: Massive GitHub collection of curated rules.
- **[JhonMA82/awesome-clinerules](https://github.com/JhonMA82/awesome-clinerules)**: Rules optimized for the Cline / RooCode AI agents.
- **[tugkanboz/awesome-cursorrules](https://github.com/tugkanboz/awesome-cursorrules)**: High-quality, context-aware rule templates.

## 3. 🛠 Skills & CLI Tools
To give your AI specific capabilities (like Vercel deployments or Stripe integrations):
- **[angular/skills](https://github.com/angular/skills)**: Official Angular team skills.
- **[stripe/agent-toolkit](https://github.com/stripe/agent-toolkit)**: Official Stripe integration tools.
- **[vercel/vercel](https://github.com/vercel/vercel)**: Official Vercel CLI deployments.
- **[trycourier/courier-skills](https://github.com/trycourier/courier-skills)**: Notifications integration.

## 4. 🔌 Model Context Protocol (MCP) Servers
MCP allows your AI IDE (Cursor, Windsurf, Claude) to directly connect to external databases, APIs, and tools. If you need a new capability (like querying PostgreSQL or searching Google), install an MCP server from these lists:
- **[modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)**: The official Anthropic/MCP repository (Postgres, Google Drive, Slack, GitHub).
- **[punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)**: Community-curated list of MCP servers.
- **[wong2/awesome-mcp-servers](https://github.com/wong2/awesome-mcp-servers)**: Database and search bridges.

---
**Agent Instruction:** If the user asks for a capability you lack, use your terminal to clone or read from the repositories listed above to dynamically learn the skill.
