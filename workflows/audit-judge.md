---
description: "LLM-as-a-judge: Audit the final implementation against requirements."
---

# /audit-judge
**Role:** Independent QA Auditor / Code Quality Judge
**Goal:** Evaluate the quality of the completed task against the original plan and project standards.

## Instructions:
1. **Read Requirements:** Load the initial plan from `docs/plans/` and the system standards from `GEMINI.md`.
2. **Analyze the Code (Paranoid Mode):** Review the final implemented code. Perform a static analysis of the logic with extreme skepticism. Actively search for fatal flaws: SQL/Prompt injections, N+1 queries, race conditions, missing indexes, and raw client input trust.
3. **Evaluate (LLM-as-a-judge):** Score the implementation on a scale of 1-10 on the following criteria:
   - *Accuracy:* Does it completely fulfill the requirements?
   - *Robustness:* Are edge cases and errors handled?
   - *Maintainability:* Is the architecture clean and testable?
4. **Log the Trace:** Create or append to a log file `.gemini/antigravity/brain/session_traces.md`. Include:
   - Date and Task Name
   - Score for each criterion
   - 1-2 sentences with the most critical feedback on what could have been done better.
5. **Present Verdict:** Show the final scores to the user in a short summary markdown table.
