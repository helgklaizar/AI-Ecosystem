---
description: "Master Orchestrator: Automatically route a new feature request through the entire pipeline (CEO -> Eng -> Implement -> Judge)."
---

# /master (Master Orchestrator)

**Role:** Chief Orchestrator / Project Manager
**Goal:** Take any abstract or concrete user goal and route it through the correct development pipeline.

## Routes (Tracks):
Depending on the user's request, choose one of two scenarios (default to the Fast Track for minor fixes):

- **FULL TRACK (`/feature`)** — For new features, complete products from scratch, or major architectural shifts. (Stages 1 -> 2 -> 3 -> 4 -> 5 -> 6).
- **FAST TRACK (`/fix`)** — For minor tweaks, bug fixes, or refactoring. (Skip to Stages 3 -> 4 -> 5 -> 6 directly).

Always use the `view_file` tool before running each stage to read the specific workflow instructions.

### Stage 1: Business Idea (CEO Mode) — *Full Track Only*
1. Read the workflow file: `.gemini/antigravity/workflows/plan-ceo.md`
2. Follow the instructions to turn the user's idea into a business product plan.
3. **Wait:** Ask the user: "Is the product idea approved? Shall we move to the Architecture stage?"

### Stage 2: Technical Plan (Engineering Mode) — *Full Track Only*
1. Read the workflow file: `.gemini/antigravity/workflows/plan-eng.md`
2. Follow the architectural design instructions.
3. Save the plan in `docs/plans/[name]-plan.md`.
4. **Wait:** Ask the user: "Plan saved. Shall we start coding (Stage 3)?"

### Stage 3: Development (Implementation Mode) — *Both Tracks*
1. Read the workflow file: `.gemini/antigravity/workflows/implement.md`
2. Begin development (Confidence check -> Tests -> Code). Wait for completion.

### Stage 4: Adaptive QA (Smoke Test) — *Both Tracks*
1. **If Web UI/Frontend:** Read `.gemini/antigravity/workflows/qa-smoke.md` and launch the browser subagent.
2. **If API/Backend/CLI:** Run terminal scripts, unit tests, or `curl` commands. DO NOT call the browser subagent for non-web tasks.
3. Ensure no bugs remain.

### Stage 5: Quality Control (Audit Judge Mode) — *Both Tracks*
1. Read the workflow file `.gemini/antigravity/workflows/audit-judge.md`
2. Evaluate feature quality, check for fatal flaws (SQLi / Race Conditions) and log a trace in `.gemini/antigravity/brain/session_traces.md`.

### Stage 6: Context Compress / Memory Reset — *Both Tracks*
1. Read the workflow file `.gemini/antigravity/workflows/context-compress.md`
2. Update the codebase status in the root `GEMINI.md`.
3. Ask the user: "Shall we clear the context map (start a new chat) or save the state and keep working here?"
