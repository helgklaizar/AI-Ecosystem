# /ecosystem-audit

> **Когда использовать**: Запусти этот воркфлоу чтобы найти и исправить все структурные конфликты в экосистеме Antigravity. Рекомендуется запускать после крупных сессий рефакторинга или при подозрении на фрагментацию.

---

## PHASE 1: Сканирование конфликтов (Silent Audit)

Запусти все проверки молча, собери полный отчёт перед тем как что-то менять.

```bash
echo "╔══════════════════════════════════════════╗"
echo "║     ANTIGRAVITY ECOSYSTEM AUDIT          ║"
echo "╚══════════════════════════════════════════╝"

PROJECTS_ROOT="$HOME/Documents/PROJECTS"
GLOBAL_AGENTS="$HOME/.gemini/antigravity/agents"
REPO="$PROJECTS_ROOT/AI-Ecosystem"

echo ""
echo "── 1. Локальные .gemini/agents/ (нарушение глобальной архитектуры) ──"
LOCAL=$(find "$PROJECTS_ROOT" -path "*/.gemini/agents/*.md" 2>/dev/null | grep -v "AI-Ecosystem")
[ -z "$LOCAL" ] && echo "✅ Чисто" || echo "$LOCAL" | while read f; do echo "❌ $f"; done

echo ""
echo "── 2. Мусор чужих IDE ──"
TRASH=$(find "$PROJECTS_ROOT" \( -name ".cursorignore" -o -name "CLAUDE.md" -o -name ".windsurfrules" -o -name "*.cursorrules" \) 2>/dev/null | grep -v ".git" | grep -v "node_modules")
[ -z "$TRASH" ] && echo "✅ Чисто" || echo "$TRASH" | while read f; do echo "❌ $f"; done

echo ""
echo "── 3. AGENTS.md файлы (должны быть удалены, замена — GEMINI.md) ──"
AGENTS_MD=$(find "$PROJECTS_ROOT" -name "AGENTS.md" 2>/dev/null | grep -v "AI-Ecosystem" | grep -v "node_modules")
[ -z "$AGENTS_MD" ] && echo "✅ Чисто" || echo "$AGENTS_MD" | while read f; do echo "❌ $f"; done

echo ""
echo "── 4. GEMINI.md проектов с UI без ссылки на DESIGN.md ──"
BLIND=0
for f in $(find "$PROJECTS_ROOT/PROD" "$PROJECTS_ROOT/WORK" "$PROJECTS_ROOT/MVP" -name "GEMINI.md" 2>/dev/null | grep -v "node_modules"); do
  dir=$(dirname "$f")
  if [ -f "$dir/DESIGN.md" ] && ! grep -q "DESIGN.md" "$f" 2>/dev/null; then
    echo "❌ $f (DESIGN.md не упомянут)"
    BLIND=$((BLIND+1))
  fi
done
[ $BLIND -eq 0 ] && echo "✅ Чисто"

echo ""
echo "── 5. Проекты с DESIGN.md но без GEMINI.md ──"
NOGEM=0
for f in $(find "$PROJECTS_ROOT/PROD" "$PROJECTS_ROOT/WORK" "$PROJECTS_ROOT/MVP" -name "DESIGN.md" 2>/dev/null | grep -v "node_modules"); do
  dir=$(dirname "$f")
  if [ ! -f "$dir/GEMINI.md" ]; then
    echo "❌ $dir (нет GEMINI.md)"
    NOGEM=$((NOGEM+1))
  fi
done
[ $NOGEM -eq 0 ] && echo "✅ Чисто"

echo ""
echo "── 6. Агенты в репо vs глобальные (рассинхрон) ──"
GLOBAL_LIST=$(ls "$GLOBAL_AGENTS"/*.md 2>/dev/null | xargs -I{} basename {} | sort)
REPO_LIST=$(ls "$REPO/agents"/*.md 2>/dev/null | xargs -I{} basename {} | sort)
ONLY_LOCAL=$(comm -23 <(echo "$GLOBAL_LIST") <(echo "$REPO_LIST"))
ONLY_REPO=$(comm -13 <(echo "$GLOBAL_LIST") <(echo "$REPO_LIST"))
[ -z "$ONLY_LOCAL" ] && echo "✅ Глобальные = Репо" || echo "$ONLY_LOCAL" | while read f; do echo "⚠️ Есть локально, нет в репо: $f"; done
[ -z "$ONLY_REPO" ] && true || echo "$ONLY_REPO" | while read f; do echo "⚠️ Есть в репо, нет локально: $f"; done
```

---

## PHASE 2: Анализ и решение

После скана выведи таблицу:

| # | Тип конфликта | Найдено | Действие |
|---|---|---|---|
| 1 | Локальные агенты | N | Показать содержимое → перенести в global или удалить |
| 2 | Мусор чужих IDE | N | Показать содержимое → удалить если пустые |
| 3 | AGENTS.md | N | Показать содержимое → влить в GEMINI.md или удалить |
| 4 | DESIGN.md не виден | N | Добавить ссылку в GEMINI.md |
| 5 | Нет GEMINI.md | N | Создать по шаблону |
| 6 | Рассинхрон агентов | N | Скопировать недостающее |

**Правило перед любым удалением**: показать содержимое файла пользователю и получить явное ОК.

---

## PHASE 3: Исправление

Исправляй конфликты по одному типу, в том же порядке что в таблице. После каждого типа — подтверди что чисто.

---

## PHASE 4: Финальный отчёт

```
╔══════════════════════════════════════════╗
║     AUDIT COMPLETE                       ║
╚══════════════════════════════════════════╝
✅ Исправлено конфликтов: N
✅ Экосистема консистентна
Дата: [timestamp]
```

Если были изменения — предложи сделать git commit в AI-Ecosystem репозитории.
