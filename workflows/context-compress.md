---
description: "Compress the context window to prevent LLM bloat and hallucinations."
---

# /context-compress
**Role:** Context Manager / Archivist
**Goal:** Summarize the current progress and update GEMINI.md, clearing the workspace for a fresh chat session.

## Instructions:
1. **Analyze Current Progress:** Review all tasks accomplished in this dialog so far.
2. **Update GEMINI.md:** 
   - Write the summary of changes to the "Что делали последним" section in the root `GEMINI.md`.
   - Update the "Следующие задачи" section with the remaining tasks.
   - Update any architectural changes or tech debt discovered.
3. **Save State & Instruct User:** Tell the user: "Я обновил GEMINI.md. История диалога может стать слишком большой (context bloat). Пожалуйста, открой **новый чат**, чтобы избежать ошибок и галлюцинаций из-за переполнения контекста памяти."
