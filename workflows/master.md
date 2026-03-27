---
description: "Master Orchestrator: Automatically route a new feature request through the entire pipeline (CEO -> Eng -> Implement -> Judge)."
---

# /master (Мастер-Оркестратор)

**Role:** Chief Orchestrator / Project Manager
**Goal:** Взять любую абстрактную или конкретную задачу от пользователя и провести её по правильному маршруту разработки.

## Маршруты (Треки):
В зависимости от запроса пользователя, выбери один из двух сценариев (по умолчанию предлагай Fast Track для мелких фиксов):

- **FULL TRACK (`/feature`)** — для новых фичей, продуктов с нуля или объемных архитектурных изменений. (Stages 1 -> 2 -> 3 -> 4 -> 5 -> 6).
- **FAST TRACK (`/fix`)** — для минорных правок, багфиксов или рефакторинга. (Сразу переходи к Stages 3 -> 4 -> 5 -> 6).

Обязательно используй `view_file` перед запуском каждого этапа для чтения деталей.

### Stage 1: Бизнес-идея (CEO Mode) — *Только Full Track*
1. Прочитай файл: `.gemini/antigravity/workflows/plan-ceo.md`
2. Выполни инструкции (преврати идею пользователя в продукт).
3. **Ожидание:** Спроси пользователя: "Утверждаем бизнес-идею? Переходим к архитектуре?"

### Stage 2: Технический план (Engineering Mode) — *Только Full Track*
1. Прочитай файл `.gemini/antigravity/workflows/plan-eng.md`
2. Выполни инструкции по проектированию архитектуры.
3. Сохрани план в `docs/plans/[название]-plan.md`.
4. **Ожидание:** Спроси пользователя: "План сохранен. Начинаем кодить (Stage 3)?"

### Stage 3: Разработка (Implementation Mode) — *Оба трека*
1. Прочитай файл `.gemini/antigravity/workflows/implement.md`
2. Начни процесс разработки (Confidence check -> тесты -> код). Дожидайся завершения.

### Stage 4: Адаптивное QA (Smoke Test) — *Оба трека*
1. **Если это Web UI / Frontend:** Прочитай файл `.gemini/antigravity/workflows/qa-smoke.md` и запусти браузер для проверки.
2. **Если это API / Backend / CLI:** Прогони консольные скрипты, юнит-тесты или `curl` запросы. НЕ вызывай браузерный субагент для не-веб задач.
3. Убедись, что багов не осталось.

### Stage 5: Контроль качества (Audit Judge Mode) — *Оба трека*
1. Прочитай файл `.gemini/antigravity/workflows/audit-judge.md`
2. Оцени качество фичи, проверь на фатальные уязвимости (SQLi/Race Conditions) и запиши трейс в `.gemini/antigravity/brain/session_traces.md`.

### Stage 6: Сброс памяти / Сохранение стейта
1. Прочитай файл `.gemini/antigravity/workflows/context-compress.md`
2. Обнови кодовые статусы в корневом `GEMINI.md`.
3. Спроси пользователя: "Обнуляем контекст (новый чат), или сохраняем стейт в памяти и продолжаем работу тут же?"
