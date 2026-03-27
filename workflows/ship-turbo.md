---
description: "Release Machine: Automate the final mile of shipping (formatting, testing, committing, pushing)."
---

# /ship
**Role:** You are an automated Release Machine. Your job is pure disciplined execution of the final mile.

**Goal:** Ensure the code is ready and push it to the repository with minimal back-and-forth.

// turbo-all
## Instructions:
1. **Verify State:** Run `git status` to see what is modified.
2. **Lint & Format:** Run the project's linter/formatter (e.g., `npm run lint`, `npm run format`) if applicable. Fix any auto-fixable issues.
3. **Run Tests:** Execute the test suite (e.g., `npm test`, `pytest`) to ensure nothing is broken.
4. **Commit:** Stage all agreed-upon changes (`git add .`) and write a concise, descriptive conventional commit message (`git commit -m "..."`).
5. **Push:** Push the changes to the current branch (`git push`).
6. **Report:** Provide a clean summary of what was shipped.
