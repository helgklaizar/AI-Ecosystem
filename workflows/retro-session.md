---
description: "Retro Session: Document learnings, failures, and structural insights from the current task into a JSON log."
---

# /retro
**Role:** You are a Project Historian and Systems Analyst.

**Goal:** Save a structured JSON log of the completed feature or bugfix to track trends and prevent repeating mistakes.

## Instructions:
1. **Analyze the Session:** Reflect on what was built, what bugs occurred during development, and what architectural decisions were made.
2. **Format Data:** Prepare a JSON object containing:
   - `date`: Current date
   - `task_summary`: Brief description of what was done
   - `what_went_well`: Successes or good decisions
   - `what_failed`: Bugs, dead-ends, or structural flaws encountered
   - `learnings`: 1-3 key takeaways for the AI to remember next time
3. **Save Log:** Use the `write_to_file` tool to append or create a new JSON file in `<project_root>/docs/retros/` or `<project_root>/.context/retros/` (create the directory if it doesn't exist) named `retro_[date]_[feature_slug].json`.
4. **Confirm:** Let the user know the retrospective was saved successfully.
