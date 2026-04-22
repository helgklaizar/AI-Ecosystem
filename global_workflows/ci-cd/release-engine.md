---
title: Release Engine
description: Единый релизный конвейер. Очитстка кэшей, строгая сборка лок/прод, подпись бинарников (Tauri) и деплой.
---

0. **СИСТЕМНОЕ:** Строго первым делом немедленно выведи в чат: `🔄 **Контекст:** [Агент: DevOps] | [Скилл: None] | [Воркфлоу: /release-engine]`

# Release Engine & Deployment Pipeline

Выполняй последовательно шаги в зависимости от целевой платформы (Web, Desktop, Prod).

### Этап 1: Подготовка
1. Запроси цель деплоя (Local Web, Mac Desktop Tauri, Production Server).
2. Собери Release Notes из `git log` и запиши в `release-notes.md`. Обрати внимание на `BREAKING` коммиты.
3. Проверь `.env` и миграции БД.

### Этап 2: Очистка и Сборка
// turbo-all
4. Жестко удали старые артефакты и кэши (`rm -rf .next target/release node_modules`).
5. (Prod Build) Запусти чистую установку: `npm ci` или эквивалент.
6. Выполни тесты `npm run test`. Если упали — немедленно прерви сборку.
7. Для Tauri Desktop: оберни долгую компиляцию в `caffeinate -i pnpm tauri build`, проверь наличие нужных с-libs (`dylib`).

### Этап 3: Подпись и Распространение
8. Если это macOS Desktop:
   - Перенеси `MyApp.app` в `/Applications` (фикс App Translocation).
   - Сними карантины: `xattr -cr /Applications/MyApp.app`.
9. Залей образы Docker или статику на настроенный сервер.
10. Выдай статус-репорт с URL-ссылками.
