---
description: Install and configure Pare MCP to optimize CLI calls
---

# Pare MCP Setup (Structured CLI output)

The workflow for setting up Pare MCP in the current project/environment. Pare allows agents to receive clean JSON instead of incompatible CLI text, saving context tokens and significantly improving parsing.

1. Initializing Pare servers:
// turbo
```bash
npx -y @paretools/init --client gemini --preset web
```
*(Available presets: `web`, `python`, `rust`, `go`, `jvm`, `dotnet`, `ruby`, `swift`, `mobile`, `devops`, `full`)*

2. Verification that servers are correctly setup (this should run a diagnostic):
```bash
npx -y @paretools/doctor
```

3. Ensure the agent is reset/restarted to pick up the new MCP tools if the server configurations were modified.

## 🔗 Alternative: External REST APIs (openapi-to-cli)

If the product requires integration with a 3rd-party REST API (e.g., Stripe, Supabase, internal backend), **do not write a custom MCP server**. Use `openapi-to-cli` instead, which is 15x more token-efficient than traditional MCP wrappers.

```bash
# Example: Generate native CLI commands from an OpenAPI JSON/YAML spec
npx openapi-to-cli@latest my-service spec.json
my-service list-users --limit 10
```
*(Instruct the AI Engineer to build shell aliases via `openapi-to-cli` instead of heavy MCP integration during the Implementation stage).*
