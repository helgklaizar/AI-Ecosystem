---
name: pare-mcp
description: Использование Pare MCP вместо стандартных CLI утилит (git, npm, docker и т.д.) для обмена структурированным JSON и экономии токенов
---

# Инструкции по Pare MCP Tools

Pare — это набор MCP серверов, которые оборачивают CLI инструменты и возвращают структурированный JSON. Это экономит токены и повышает надежность парсинга вывода агентом.

## Главное правило

ВСЕГДА отдавай предпочтение инструментам Pare MCP перед сырыми CLI командами. Любой вызов в shell поддерживаемого инструмента должен заменяться на эквивалентный вызов Pare MCP, если сервер установлен и доступен.

## Полная таблица маппинга инструментов

### pare-git (замена `git`)
Используй `pare-git <subcommand>` вместо `git <subcommand>` для:
status, log, diff, branch, show, add, commit, push, pull, checkout, tag, stash, remote, blame, restore, reset, cherry-pick, merge, rebase, reflog, bisect, worktree, submodule, archive, clean, config

### pare-github (замена `gh`)
Используй `pare-github <tool>` вместо `gh`:
- PR: pr-view, pr-list, pr-create, pr-merge, pr-comment, pr-review, pr-update, pr-checks, pr-diff
- Issues: issue-view, issue-list, issue-create, issue-close, issue-comment, issue-update
- CI: run-view, run-list, run-rerun
- Releases: release-create, release-list
- Other: label-list, label-create, repo-view, repo-clone, discussion-list, gist-create, api

### pare-npm (замена `npm`, `pnpm`, `yarn`)
install, audit, outdated, list, run, test, init, info, search, nvm

### pare-search (замена утилит поиска и фильтрации)
- `grep` / `rg` -> `pare-search search`
- `find` / `fd` -> `pare-search find`
- `wc` -> `pare-search count`
- `jq` -> `pare-search jq`
- `yq` -> `pare-search yq`

### pare-lint (замена линтеров и форматтеров)
- `eslint` -> `pare-lint lint`
- `prettier --check` -> `pare-lint format-check`
- `prettier --write` -> `pare-lint prettier-format`
- `biome check` -> `pare-lint biome-check`
- `biome format` -> `pare-lint biome-format`
- `stylelint` -> `pare-lint stylelint`
- `oxlint` -> `pare-lint oxlint`
- `shellcheck` -> `pare-lint shellcheck`
- `hadolint` -> `pare-lint hadolint`

### pare-build (замена систем сборки)
- `tsc` -> `pare-build tsc`
- `npm run build` -> `pare-build build`
- `esbuild` -> `pare-build esbuild`
- `vite build` -> `pare-build vite-build`
- `webpack` -> `pare-build webpack`
- `turbo` -> `pare-build turbo`
- `nx` -> `pare-build nx`
- `lerna` -> `pare-build lerna`
- `rollup` -> `pare-build rollup`

### pare-test (замена тест-раннеров)
- `vitest`/`jest`/`mocha`/`pytest` -> `pare-test run`
- `vitest --coverage` -> `pare-test coverage`
- `playwright test` -> `pare-test playwright`

### pare-docker (замена `docker` и `docker compose`)
- Container: ps, build, logs, images, run, exec, pull, inspect, stats
- Compose: compose-up, compose-down, compose-ps, compose-logs, compose-build
- Network/Volume: network-ls, volume-ls

### pare-cargo (замена `cargo`)
build, test, clippy, run, add, remove, fmt, doc, check, update, tree, audit

### pare-go (замена `go`, `golangci-lint`)
build, test, vet, run, mod-tidy, fmt, generate, env, list, get, golangci-lint

### pare-python (замена утилит Python)
- `pip install/list/show` -> `pare-python pip-install/pip-list/pip-show`
- `pip-audit` -> `pare-python pip-audit`
- `mypy` -> `pare-python mypy`
- `ruff check/format` -> `pare-python ruff-check/ruff-format`
- `black` -> `pare-python black`
- `pytest` -> `pare-python pytest`
- `uv install/run` -> `pare-python uv-install/uv-run`
- `conda/pyenv/poetry` -> `pare-python conda/pyenv/poetry`

### pare-k8s (замена `kubectl`, `helm`)
get, describe, logs, apply, helm

### pare-http (замена `curl`, `wget`)
request, get, post, head

### pare-make (замена `make`, `just`)
run, list

### pare-security (сканеры безопасности)
trivy, semgrep, gitleaks

### pare-process (универсальный фолбэк)
Любая команда, не покрытая выше -> `pare-process run`

## Обработка ошибок

- Если инструмент MCP вернул ошибку, прочитай поле `error` в ответе JSON и исправь аргументы.
- Не откатывайся на выполнение через `run_command` (сырой shell). Попробуй повторить с правильными параметрами.
- Если сервер недоступен или падает, попроси пользователя проверить конфигурацию MCP (например `npx @paretools/doctor`).
- Все ответы Pare – это структурированный JSON, парси поля напрямую, никогда не оборачивай вызовы MCP в shell команды.
