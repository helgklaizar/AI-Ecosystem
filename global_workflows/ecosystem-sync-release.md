# /ecosystem-sync-release

**Цель:** Автоматическая синхронизация локальных обновлений базы знаний и воркфлоу с GitHub-репозиторием `Antigravity-AI-Ecosystem` с последующим выпуском нового релиза.
Вызывается каждый раз, когда мы добавляем новые глобальные воркфлоу, скиллы или обновляем инженерные паттерны.

// turbo-all

## Фаза 1: Клонирование (или обновление) репозитория
Если репозиторий еще не склонирован в проектах, скачиваем его. В противном случае делаем `git pull`.

```bash
# Ищем директорию или клонируем
REPO_PATH="$HOME/Documents/PROJECTS/Antigravity-AI-Ecosystem"

if [ ! -d "$REPO_PATH" ]; then
  cd "$HOME/Documents/PROJECTS"
  gh repo clone helgklaizar/Antigravity-AI-Ecosystem
else
  cd "$REPO_PATH"
  git pull origin main
fi
```

## Фаза 2: Синхронизация файлов из локального хранилища `~/.gemini/antigravity/`
Переносим все новые `global_workflows` и специфичные паттерны из локальной машины в репозиторий.

```bash
REPO_PATH="$HOME/Documents/PROJECTS/Antigravity-AI-Ecosystem"
# 1. Синхронизируем глобальные воркфлоу
cp -R ~/.gemini/antigravity/global_workflows/* "$REPO_PATH/global_workflows/"

# 2. Синхронизируем знания и паттерны (кладем их в skills/ai-engineering)
mkdir -p "$REPO_PATH/skills/ai-engineering"
if [ -d "$HOME/.gemini/antigravity/knowledge/ai-engineering-patterns/artifacts" ]; then
    cp -R ~/.gemini/antigravity/knowledge/ai-engineering-patterns/artifacts/*.md "$REPO_PATH/skills/ai-engineering/"
fi
if [ -d "$HOME/.gemini/antigravity/knowledge/agent-system-guide/artifacts" ]; then
    cp -R ~/.gemini/antigravity/knowledge/agent-system-guide/artifacts/*.md "$REPO_PATH/skills/ai-engineering/"
fi
```

## Фаза 3: Валидация и Коммит
Проверяем статус и коммитим изменения. 

```bash
cd "$HOME/Documents/PROJECTS/Antigravity-AI-Ecosystem"
git add .

# Если есть изменения, делаем коммит
if ! git diff-index --quiet HEAD; then
    NEW_VERSION="$(date +'%Y.%m.%d')"
    git commit -m "sync: Auto-sync local Antigravity configs and update skills registry ($NEW_VERSION)"
    git push origin main
else
    echo "No changes found. Exiting."
    exit 0
fi
```

## Фаза 4: Генерация GitHub Релиза
Создаем официальный релиз (SemVer по дате) на основе текущего коммита в ветке `main`.

```bash
cd "$HOME/Documents/PROJECTS/Antigravity-AI-Ecosystem"
NEW_VERSION="$(date +'%Y.%m.%d')"

# Для создания динамического описания релиза 
# ИИ должен сгенерировать понятный список изменений, переданный в --notes
gh release create "$NEW_VERSION" \
   --title "Ecosystem Registry Update ($NEW_VERSION)" \
   --notes "Automated synchronization of local workflows, AI skills, and Agent-Native CLI structures. All environment updates have been pushed to this release." \
   --target main
```

**Инструкция агенту:**
Если этот воркфлоу вызван через `/ecosystem-sync-release`, ты обязан выполнить все Bash-команды в указанном порядке. Благодаря флагу `// turbo-all`, ты можешь ставить `SafeToAutoRun=true` для всех команд.
В Фазе 4, если ты знаешь конкретные воркфлоу или паттерны, которые только что были добавлены, отредактируй строку `--notes`, чтобы явно указать эти новинки.
