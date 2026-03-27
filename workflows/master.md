---
description: "Master Orchestrator: Automatically route a new feature request through the entire pipeline (CEO -> Eng -> Implement -> Judge)."
---

# /master (Master Orchestrator)

**Role:** Chief Orchestrator / Project Manager
**Goal:** Take any abstract or concrete user request and route it through the correct development track.

## Routes (Tracks):
Depending on the user's request, choose one of two scenarios (default to Fast Track for minor fixes):

- **FULL TRACK (`/feature`)** — For new features, zero-to-one products, or major architectural shifts. (Stages 1 -> 2 -> 3 -> 4 -> 5 -> 6).
- **FAST TRACK (`/fix`)** — For minor tweaks, bug fixes, or refactoring. (Skip to Stages 3 -> 4 -> 5 -> 6 directly).

Always use the `view_file` tool before running each stage to read the specific instructions.

### Stage 1: Business Idea (CEO Mode) — *Full Track Only*
1. Read the file: `.gemini/workflows/plan-ceo.md`
2. Follow the instructions to turn the user's idea into a product vision.
3. **Wait:** Ask the user: "Do we approve the business idea? Shall we move to the architecture stage?"

### Stage 2: Technical Plan (Engineering Mode) — *Full Track Only*
1. Read the file: `.gemini/workflows/plan-eng.md`
2. Follow the architecture design instructions.
3. Save the plan to `docs/plans/[name]-plan.md`.
4. **Wait:** Ask the user: "Plan saved. Shall we start coding (Stage 3)?"

### Stage 3: Development (Implementation Mode) — *Both Tracks*
1. Read the file: `.gemini/workflows/implement.md`
2. Start the development process (Confidence check -> tests -> code). Wait for completion.

### Stage 4: Adaptive QA (Smoke Test) — *Both Tracks*
1. **If Web UI / Frontend:** Read `.gemini/workflows/qa-smoke.md` and launch the browser subagent to verify.
2. **If API / Backend / CLI:** Run terminal scripts, unit tests, or `curl` requests. DO NOT call the browser subagent for non-web tasks.
3. Make sure no bugs remain.

### Stage 5: Quality Control (Audit Judge Mode) — *Both Tracks*
1. Read the file: `.gemini/workflows/audit-judge.md`
2. Evaluate feature quality, check for fatal vulnerabilities (SQLi/Race Conditions), and write a trace in `.gemini/brain/session_traces.md`.

### Stage 6: Quality Gate & Git Hooks (Agent Delegation)
1. **Never commit broken code.** If multiple specialized agents are collaborating (e.g., Frontend Agent and Backend Agent), ensure coordination via Git Hooks.
2. Run standard pre-commit hooks (linting, testing) automatically. If the hook fails, the Agent must fix the issue before passing the code to the next agent or finalizing the task.

### Stage 7: Memory Reset / State Save
1. Read the file: `.gemini/workflows/context-compress.md`
2. Update the codebase status in the root `GEMINI.md`.
3. Ask the user: "Shall we clear the context (start a new chat) or save the state in memory and continue working here?"
