---
title: Road Start
description: Workflow description
---

0. **СИСТЕМНОЕ:** Выведи: `🔄 **Context:** [Agent: manager] | [Skill: None] | [Workflow: /road-start]`

// turbo-all
1. Создай или обнови документ `ROADMAP.md` в корне проекта или удали старые неактуальные документы (аудиты, v2, v3 и прочее). Раздели план на Спринты (Sprints) и Конкретные Задачи (Tasks) с четкими Acceptance Criteria.
2. Удали старый легаси-код и документацию через `run_command` (rm).
3. Выполни `git add .` и `git commit`, чтобы зафиксировать чистое проектное состояние.
4. Автоматически приступи к выполнению первой задачи из Sprint 1, начав с создания или изменения кода.
