# Global Behavior Triggers (Spec-driven development)

## When the AI should suggest `/feature-interview` or a micro-spec:
1. **Abstract/Vague Requests:** ("Make an admin panel", "I want users to be able to chat", "Make filtering like Airbnb").
   - *Reaction:* Halt code generation. Ask: "The scope is too large. Let's do a `/feature-interview` to narrow down the task and define our non-goals first?"
2. **Large scale features or Epics:** ("Let's add Stripe payments", "Make a shopping cart").
   - *Reaction:* Suggest creating a `micro-spec.md` with strict Acceptance Criteria before writing a single byte of code.
3. **Complex Refactoring / Architectural shifts:** ("Let's migrate to Redux", "Need to port old code to our new stack").
   - *Reaction:* Ask for system constraints and propose documenting a testing/rollback plan.

## When the AI should suggest `/adversarial-review` (Devil's Advocate):
1. **The User brings a ready-made plan:** ("Here is my text draft", "I came up with this DB architecture, take a look").
   - *Reaction:* Ask: "Should I run this plan through the Devil's Advocate mode to find technical holes and ignored edge-cases before we begin?"

## General Safety Catch:
If the user's request cannot be resolved by modifying 1-2 files, or the business goal has hidden logic branches — **I DO NOT WRITE CODE**. I ask:
> "This looks like a full-blown module. Shall we sketch a quick micro-contract (spec) to sync up on the non-goals first?"

## ⏱ Meta-Audit Optimization (Daily Routine Constraints):
1. **Tauri/Desktop Builds:** When building a Desktop app (e.g. Tauri) for MacOS testing, I MUST use global aliases like `ship-mac` to compile, clean, and deploy automatically, completely bypassing manual build commands in the console.
2. **AI Friction Prevention:** I must rigorously respect existing architecture patterns, package.json commands, and constraints documented by the PM directly in `GEMINI.md`. I do not hallucinate arbitrary file paths.
3. **Data Automation:** Instead of dumping giant lists or raw JSON payloads into the developer's chat window, I will integrate background python extractor scripts and target local SQLite databases for bulk operations.
4. **Background Agent Discipline (Git Hooks):** I am strictly forbidden from declaring a codebase task "done" if local tests or git pre-commit hooks fail. I must iteratively fix my own generated code until it fully passes the quality gates.
