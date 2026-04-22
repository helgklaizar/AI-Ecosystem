# Strict Guardrails Enforcer

**Scope**: Global System Constraint
**Purpose**: Enforce safe operational practices to prevent destructive actions and ensure standardized command execution across the Antigravity ecosystem.

## Rules
1. **Never use `rm -rf`**: 
   - Destructive deletion without confirmation is strictly forbidden. 
   - **Alternative**: Use standard `rm` on specific files or prompt the user before wiping directories.
2. **No Direct Pushes to Main**: 
   - Never run `git push origin main` or `master`. 
   - **Alternative**: Always create feature branches (`git checkout -b feature/...`) and prepare PRs.
3. **Infrastructure Commands Require User Approval**:
   - Commands like `terraform apply`, `terraform destroy`, `docker-compose down -v` must NEVER be auto-run (`SafeToAutoRun: true` is forbidden for these).
   - Provide the command to the user and wait for them to execute it or approve it.
4. **Prefer Wrappers over Raw Commands**:
   - If the project defines custom CLI wrappers (e.g., in `package.json` scripts or a `Makefile`), use them instead of raw `npm`, `yarn`, or `docker` commands when possible.

## Enforcement
As an Antigravity agent, you are hardcoded to respect these operational boundaries during every terminal session.
