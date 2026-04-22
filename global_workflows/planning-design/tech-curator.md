# Tech Curator Workflow

This workflow is designed to analyze external technical articles, documentation, or repositories and determine how they can be applied both to our specific tech stack and global AI orchestration.

## 1. Source Ingestion
- Use `read_url_content` or `read_browser_page` to ingest the source material.
- Summarize the key "Transferable Patterns" (e.g., config structures, new CLI tools, architectural paradigms).

## 2. Workspace Mapping
- Identify the active project(s) and their technology stacks (e.g., Apple Metal, MLX, Next.js, TDLib).
- Check existing `DESIGN.md`, `GEMINI.md`, or `SKILL.md` files for current standards.

## 3. Global AI & Strategic Fit
- **Tech Stack Alignment**: Does it leverage or improve our Metal/MLX ecosystem?
- **Global AI Trends**: Does it introduce SOTA paradigms (e.g., Small/Reasoning Models, Dynamic Agents, better RAG)?
- **Agentic Meta-Efficiency**: Can it improve how our agents work, remember, and coordinate?

## 4. Constraint Audit
- Check if the source suggests rules that are too rigid.
- Ensure any recommendation follows the **"Principle of Informed Deviation"**: prefer guidelines over hard restrictions.

## 5. Implementation Plan
- **Quick Wins**: Immediate changes to `settings.json`, `GEMINI.md`, or `.gitignore`.
- **Structural Changes**: Proposals for new tools, refactoring, or workflow updates.
- **Documentation**: Updates to Knowledge Items (KI) if the pattern is worth preserving globally.
