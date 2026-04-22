# Telegram → Antigravity IDE Bridge

## Концепция

Ты пишешь в Telegram боту:
```
/task Открой проект borsch-shop и добавь валидацию email в форму заказа
```

Статус бар на твоём Mac получает это сообщение и **автоматически**:
1. Открывает новое окно Antigravity IDE
2. Переключается на нужный проект
3. Вставляет задачу в чат

---

## Техническая Архитектура

```
Telegram Bot API
      ↓ (Long Polling / Webhook)
Status Bar App (Swift, локально)
      ↓ (AppleScript / Accessibility API)
Antigravity IDE
      ↓
Новый чат с задачей
```

### Компонент 1: Telegram Bot Listener (Swift)
Статус бар уже запущен постоянно. Добавляем фоновый `URLSession` поллер:

```swift
// TelegramPoller.swift
class TelegramPoller {
    let token = ProcessInfo.processInfo.environment["TG_BOT_TOKEN"]!
    var lastUpdateId: Int = 0
    
    func startPolling() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.fetchUpdates()
        }
    }
    
    func fetchUpdates() {
        let url = URL(string: "https://api.telegram.org/bot\(token)/getUpdates?offset=\(lastUpdateId + 1)")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let updates = json["result"] as? [[String: Any]] else { return }
            
            for update in updates {
                if let id = update["update_id"] as? Int {
                    self.lastUpdateId = id
                }
                if let message = update["message"] as? [String: Any],
                   let text = message["text"] as? String,
                   let from = message["from"] as? [String: Any],
                   let userId = from["id"] as? Int,
                   userId == ALLOWED_USER_ID { // Только ты
                    self.handleCommand(text)
                }
            }
        }.resume()
    }
}
```

### Компонент 2: Команды и Парсинг

```swift
func handleCommand(_ text: String) {
    if text.hasPrefix("/task ") {
        let task = String(text.dropFirst(6))
        injectTaskToIDE(task)
    } else if text.hasPrefix("/open ") {
        let project = String(text.dropFirst(6))
        openProject(project)
    } else if text == "/status" {
        sendTelegramReply("✅ Antigravity активен. Проект: \(activeProject)")
    }
}
```

### Компонент 3: Инжекция в IDE (AppleScript)

```swift
func injectTaskToIDE(_ task: String) {
    let script = """
    tell application "Antigravity"
        activate
        -- Открываем новое окно чата
        tell application "System Events"
            tell process "Antigravity"
                -- Cmd+N для нового чата
                keystroke "n" using command down
                delay 0.5
                -- Вставляем текст задачи
                keystroke "\(task)"
                -- Отправляем (Enter)
                key code 36
            end tell
        end tell
    end tell
    """
    
    var error: NSDictionary?
    NSAppleScript(source: script)?.executeAndReturnError(&error)
}
```

---

## Команды бота

| Команда | Действие |
|---|---|
| `/task [текст]` | Открыть новый чат и вставить задачу |
| `/open [проект]` | Переключить активный проект в IDE |
| `/status` | Ответить текущим состоянием |
| `/audit` | Запустить `/ecosystem-audit` воркфлоу |
| `/sync` | Запустить `/project-sync` |

---

## Security

- Хранить `TG_BOT_TOKEN` в macOS Keychain, не в коде
- `ALLOWED_USER_ID` — hardcode твоего Telegram ID (можно получить у @userinfobot)
- Бот работает только когда статус бар запущен (не сервер, чисто локально)

---

## Что нужно для реализации

1. Создать бота через @BotFather → получить токен
2. Добавить `TelegramPoller.swift` в таргет `status-bar/`
3. Добавить `Privacy - Accessibility Usage Description` в `Info.plist`
4. Запросить разрешение Accessibility при первом запуске

**Это MVP — ~200 строк Swift.** Можно реализовать в рамках `status-bar/` без внешних зависимостей.
