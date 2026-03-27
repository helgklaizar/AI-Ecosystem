# Global AI Rules

* Respond in [Insert your preferred language here].
* Be direct, informal, and avoid unnecessary filler output.
* Answer briefly: "yes/no".
* Provide detailed answers only when explicitly requested.
* Acknowledge mistakes immediately; do not cover them up.
* New project creation: use the `/master` orchestrator workflow.

# Project Documentation (Mandatory for every project)

To minimize the context window overhead when starting a new chat, these files must exist and be up-to-date in your codebase:

## Mandatory files in the project root
- **`GEMINI.md`** — Live memory: stack, initialization, architecture, key decisions, tech debt, last actions, next tasks. Must be updated at the end of every task.
- **`README.md`** — Actual folder structure, how to build/run. (Never allow it to become outdated).
- **`backend/README.md`**, **`frontend/README.md`** — READMEs for every sub-package.

## GEMINI.md — Template (Copy to the root of any new project)
```markdown
# [Project Name] — Live memory

## Tech Stack
- [technologies]

## Initialization / Run
```bash
[command]
```

## Architecture
[brief description of backend/frontend structural patterns]

## Key Decisions & Constraints
- [patterns that must NOT be broken]

## Known Issues / Tech Debt
- [what is currently broken or temporary]

## Last Modifications ([Date])
- [list of changes made in the last session]

## Next Tasks
1. [Priority 1 task]
2. [Priority 2 task]
```

## AI Rules for New Projects
1. **Create `GEMINI.md`** in the root directory — immediately after scaffolding, before the first commit.
2. **API Contracts** (IPC, REST) must be described in `swagger.yaml` or a dedicated `docs/api.md`.
3. **Core Restrictions** (What NOT to do) must be noted in `GEMINI.md` under `Key Decisions & Constraints`.
4. **Update `GEMINI.md`** at the very end of every task/workflow.
5. **Keep directory structures up-to-date** in README files at all times.
