# 🧭 AI Ecosystem Actionable Index

**AGENT INSTRUCTION:** This is your primary database. If the user requests a new skill, agent, workflow, or capability that you do not currently possess, you MUST consult this list. Search the categories below, extract the necessary files, and inject them into the user's project.

---

## 🛠 1. Скиллы и MCP-Серверы (Где брать Skills)
*Если юзеру нужно подключить базу данных, GitHub, Slack, интернет-поиск или специфичные CLI утилиты.*

### MCP Servers (Model Context Protocol)
- **🔗 [punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)** (85k+ Stars)
- **🔗 [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)** (Официальные серверы Anthropic)
- **🔗 [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills)** (55k+ Stars)
- **🎯 Что брать:** Команды установки `npx` или Docker.
- **📥 Куда класть:** Прописать в глобальный `claude_desktop_config.json` или в настройки Cursor MCP.

### Antigravity & Local Skills
- **🔗 [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills)** (34k+ Stars)
- **🎯 Что брать:** Markdown-файлы (`*.md`) из папки `/skills/`.
- **📥 Куда класть:** Сохранить локально в `~/.ai-ecosystem/skills/`.

---

## 🤖 2. Агенты (Где брать Agents)
*Если юзер просит добавить QA-тестировщика, DevOps-инженера или другого специализированного ИИ-коллегу.*

### Sub-Agents & Personas
- **🔗 [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)** (17k+ Stars)
- **🔗 [huggingface/smolagents](https://github.com/huggingface/smolagents)**
- **🎯 Что брать:** Текст системного промпта (персону агента).
- **📥 Куда класть:** Создать новый `.md` файл в `~/.ai-ecosystem/agents/` (или `.gemini/agents/`).

---

## 🔄 3. Воркфлоу и Правила (Где брать Workflows & Rules)
*Если юзеру нужны стандарты кодирования для React, Rust, Python, Next.js или общие пайплайны.*

### Cursor & Windsurf Rules
- **🔗 [cursor.directory](https://cursor.directory/)**
- **🔗 [PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules)** (39k+ Stars)
- **🔗 [detailobsessed/awesome-windsurf](https://github.com/detailobsessed/awesome-windsurf)**
- **🎯 Что брать:** Сырой текст Markdown (`.mdc` или `.cursorrules`).
- **📥 Куда класть:** Сохранить в `.cursor/rules/[имя].mdc` (не забыть YAML-заголовок `globs`) или в `.windsurfrules`.

### Claude & Cline Rules
- **🔗 [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code)** (40k+ Stars)
- **🔗 [JhonMA82/awesome-clinerules](https://github.com/JhonMA82/awesome-clinerules)**
- **🎯 Что брать:** XML-блоки или Markdown правила.
- **📥 Куда класть:** Дописать в файл `CLAUDE.md` в корне проекта.

---

## 📝 4. Промпты (Где брать Prompts)
*Если юзер просит сложный ролевой промпт или специфичный запрос для LLM.*

### Global Prompt Libraries
- **🔗 [f/prompts.chat](https://github.com/f/prompts.chat)** (160k+ Stars)
- **🔗 [langgptai/awesome-claude-prompts](https://github.com/langgptai/awesome-claude-prompts)**
- **🎯 Что брать:** Текст ролевой модели (например, "Act as a Linux Terminal").
- **📥 Куда класть:** Использовать напрямую в чате или сохранить в `~/.ai-ecosystem/workflows/`.
