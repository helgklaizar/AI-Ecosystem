import Foundation
import Combine
import AppKit

// MARK: - Chat Message

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: Role
    let text: String
    var isTyping: Bool = false

    enum Role {
        case bot, user, log, system
    }
}

// MARK: - Quick Reply

struct QuickReply: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

// MARK: - Chat State

enum ChatState {
    case welcome
    case askName
    case askProfession
    case askStack(profession: Profession)
    case askAITools(profession: Profession, stack: String)
    case askProjectsPath(profession: Profession, stack: String, tools: Set<AITool>)
    case confirm(profile: UserProfile)
    case deploying(profile: UserProfile)
    case ready(profile: UserProfile)
}

// MARK: - ChatEngine

@MainActor
class ChatEngine: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var quickReplies: [QuickReply] = []
    @Published var isTyping: Bool = false
    @Published var inputPlaceholder: String = "Напиши что-нибудь..."
    @Published var state: ChatState = .welcome

    private let analyzer = WorkspaceAnalyzer.shared
    private let updater = UpdateChecker.shared

    init() {
        Task { await start() }
    }

    // MARK: - Start

    func start() async {
        await botSay("⚡ **GravityHub**\n\nЯ настрою твоё AI-окружение под тебя — агенты, воркфлоу, скиллы, структуру папок.\n\nВсё как надо, с первого раза.")
        try? await Task.sleep(nanoseconds: 600_000_000)
        await botSay("Как тебя зовут?")
        state = .askName
        inputPlaceholder = "Твоё имя..."
    }

    // MARK: - Handle User Input

    func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        addMessage(.init(role: .user, text: trimmed))
        quickReplies = []

        Task {
            await handle(input: trimmed)
        }
    }

    func selectQuickReply(_ reply: QuickReply) {
        addMessage(.init(role: .user, text: reply.label))
        quickReplies = []
        Task { await handle(input: reply.value) }
    }

    // MARK: - State Machine

    private func handle(input: String) async {
        switch state {

        case .welcome, .askName:
            let name = input.isEmpty ? "Анон" : input
            await botSay("Привет, **\(name)**! 👋")
            try? await Task.sleep(nanoseconds: 400_000_000)
            await botSay("Кем работаешь?")
            state = .askProfession
            inputPlaceholder = "Выбери или напиши..."
            quickReplies = Profession.allCases.map {
                QuickReply(label: "\($0.icon) \($0.displayName)", value: $0.rawValue)
            }

        case .askProfession:
            guard let profession = Profession.allCases.first(where: {
                $0.rawValue == input || $0.displayName.lowercased() == input.lowercased()
            }) else {
                await botSay("Не понял. Выбери из списка 👆")
                quickReplies = Profession.allCases.map {
                    QuickReply(label: "\($0.icon) \($0.displayName)", value: $0.rawValue)
                }
                return
            }
            await botSay("**\(profession.displayName)** — отлично.")
            try? await Task.sleep(nanoseconds: 400_000_000)
            await botSay("Стек для тебя:\n```\n\(profession.stack)\n```\nПодходит?")
            state = .askStack(profession: profession)
            inputPlaceholder = "Или напиши свой стек..."
            quickReplies = [
                QuickReply(label: "✅ Да, подходит", value: "__default__"),
                QuickReply(label: "✏️ Изменить", value: "__custom__")
            ]

        case .askStack(let profession):
            let stack: String
            if input == "__default__" {
                stack = profession.stack
            } else if input == "__custom__" {
                await botSay("Напиши свой стек (например: Go, PostgreSQL, K8s):")
                inputPlaceholder = "Твой стек..."
                return
            } else {
                stack = input
            }

            await botSay("Стек: `\(stack)` ✓")
            try? await Task.sleep(nanoseconds: 400_000_000)
            await botSay("Какие AI-инструменты используешь?\nМожно несколько — жми и подтверди.")
            state = .askAITools(profession: profession, stack: stack)
            inputPlaceholder = "Или напиши: antigravity, claude, cursor..."
            quickReplies = AITool.allCases.map {
                QuickReply(label: "\($0.icon) \($0.displayName)", value: $0.rawValue)
            } + [QuickReply(label: "✅ Готово", value: "__done__")]
            // Store selected tools temporarily
            selectedTools = []

        case .askAITools(let profession, let stack):
            if input == "__done__" {
                if selectedTools.isEmpty { selectedTools.insert(.antigravity) }
                let toolNames = selectedTools.map { $0.displayName }.joined(separator: ", ")
                await botSay("AI-инструменты: **\(toolNames)** ✓")
                try? await Task.sleep(nanoseconds: 400_000_000)
                await botSay("Где хранишь проекты?\nПо умолчанию: `~/Documents/PROJECTS`")
                state = .askProjectsPath(profession: profession, stack: stack, tools: selectedTools)
                inputPlaceholder = "~/Documents/PROJECTS"
                quickReplies = [
                    QuickReply(label: "📁 ~/Documents/PROJECTS", value: "~/Documents/PROJECTS"),
                    QuickReply(label: "📁 Выбрать папку...", value: "__pick__")
                ]
            } else if let tool = AITool.allCases.first(where: { $0.rawValue == input }) {
                if selectedTools.contains(tool) {
                    selectedTools.remove(tool)
                    await botSay("— \(tool.displayName) убрал")
                } else {
                    selectedTools.insert(tool)
                    await botSay("+ \(tool.displayName) добавил")
                }
                // Re-show tool selector
                quickReplies = AITool.allCases.map {
                    let mark = selectedTools.contains($0) ? "✓ " : ""
                    return QuickReply(label: "\(mark)\($0.icon) \($0.displayName)", value: $0.rawValue)
                } + [QuickReply(label: "✅ Готово", value: "__done__")]
            } else {
                // Parse text input like "antigravity, claude"
                let parsed = input.components(separatedBy: CharacterSet(charactersIn: ",; "))
                    .compactMap { s -> AITool? in
                        AITool.allCases.first { $0.rawValue == s.lowercased().trimmingCharacters(in: .whitespaces) }
                    }
                if !parsed.isEmpty {
                    parsed.forEach { selectedTools.insert($0) }
                    await handle(input: "__done__")
                } else {
                    await botSay("Не понял. Выбери из кнопок ☝️")
                }
            }

        case .askProjectsPath(let profession, let stack, let tools):
            var path = input
            if input == "__pick__" {
                path = await pickFolder() ?? "~/Documents/PROJECTS"
            }
            let profile = UserProfile(
                name: lastUserName(),
                profession: profession,
                aiTools: Array(tools),
                projectsRootPath: path,
                onboardingComplete: true
            )
            await showConfirm(profile: profile)

        case .confirm(let profile):
            let lower = input.lowercased()
            if lower == "старт" || lower == "start" || lower == "поехали" || lower == "да" || lower == "go" {
                state = .deploying(profile: profile)
                await deploy(profile: profile)
            } else if lower == "нет" || lower == "отмена" {
                await botSay("Окей, начнём сначала.")
                messages = []
                quickReplies = []
                selectedTools = []
                state = .welcome
                await start()
            } else {
                await botSay("Напиши **старт** чтобы начать, или **нет** чтобы изменить.")
                quickReplies = [
                    QuickReply(label: "🚀 Старт", value: "старт"),
                    QuickReply(label: "↩️ Заново", value: "нет")
                ]
            }

        case .ready(let profile):
            await handleReadyCommand(input: input, profile: profile)

        case .deploying:
            await botSay("Подожди, идёт настройка... ⏳")
        }
    }

    // MARK: - Confirm Screen

    private func showConfirm(profile: UserProfile) async {
        state = .confirm(profile: profile)
        let summary = """
        **Сводка:**

        👤 Имя: \(profile.name)
        \(profile.profession.icon) Профессия: \(profile.profession.displayName)
        🛠 Стек: \(profile.profession.stack)
        🤖 AI: \(profile.aiTools.map { $0.displayName }.joined(separator: ", "))
        📁 Проекты: `\(profile.projectsRootPath)`

        **Что будет установлено:**
        \(profile.profession.setupManifest.map { "• \($0.destinationRelative)" }.prefix(8).joined(separator: "\n"))
        \(profile.profession.setupManifest.count > 8 ? "  ...и ещё \(profile.profession.setupManifest.count - 8) файлов" : "")

        Напиши **старт** и поехали 🚀
        """
        await botSay(summary)
        quickReplies = [
            QuickReply(label: "🚀 Старт", value: "старт"),
            QuickReply(label: "↩️ Изменить", value: "нет")
        ]
        inputPlaceholder = "старт..."
    }

    // MARK: - Deploy

    private func deploy(profile: UserProfile) async {
        await logSay("🚀 Начинаю настройку окружения...\n")

        // Save profile
        AppStore.shared.saveProfile(profile)

        // Level 1: User level
        await logSay("📁 [1/3] ~/.gemini/antigravity/")
        await analyzer.deployUserLevel(profile: profile) { [weak self] msg in
            Task { @MainActor in
                self?.appendToLastLog(msg)
            }
        }

        // Level 2: Workspace level
        await logSay("📁 [2/3] Workspace .gemini/agents/")
        await analyzer.deployWorkspaceLevel(profile: profile) { [weak self] msg in
            Task { @MainActor in
                self?.appendToLastLog(msg)
            }
        }

        // Level 3: Download from GitHub
        await logSay("📦 [3/3] Скачиваю файлы из GitHub...")
        let manifest = profile.profession.setupManifest
        for (i, file) in manifest.enumerated() {
            let destURL = file.destinationURL(profile: profile)
            let result = await downloadFile(from: file.source.rawURL(for: file.sourcePath), to: destURL)
            switch result {
            case .success:
                await appendToLastLog("   ✅ \(file.destinationRelative)\n")
            case .skipped:
                await appendToLastLog("   ⏭ \(file.destinationRelative) (уже есть)\n")
            case .failed(let err):
                await appendToLastLog("   ❌ \(file.destinationRelative): \(err)\n")
            }
            // Update progress
            let progress = Int(Double(i + 1) / Double(manifest.count) * 100)
            if progress % 20 == 0 {
                await appendToLastLog("   [\(progress)%]\n")
            }
        }

        // Git structure
        await logSay("🔧 Инициализирую структуру git...")
        await analyzer.initGitStructure(profile: profile) { [weak self] msg in
            Task { @MainActor in
                self?.appendToLastLog(msg)
            }
        }

        // Done
        await botSay("✅ **Готово!** Окружение настроено.\n\n**\(profile.name)**, вот что можно делать теперь:\n• `статус` — посмотреть здоровье окружения\n• `обновить` — подтянуть новые агенты/воркфлоу из GitHub\n• `починить` — восстановить отсутствующие файлы")

        // Check ecosystem + app updates
        await checkUpdates(profile: profile)
        await checkAppUpdate()

        state = .ready(profile: profile)
        inputPlaceholder = "статус / обновить / починить..."
    }

    // MARK: - Ready Commands

    private func handleReadyCommand(input: String, profile: UserProfile) async {
        let cmd = input.lowercased().trimmingCharacters(in: .whitespaces)

        switch cmd {
        case "статус", "status", "health":
            await showStatus(profile: profile)

        case "обновить", "update", "sync":
            await runUpdate(profile: profile)

        case "починить", "repair", "fix":
            await repair(profile: profile)

        case "обновить апп", "update app", "новая версия":
            await runAppUpdate()

        case "помощь", "help", "?":
            await botSay("**Команды:**\n• `статус` — здоровье окружения\n• `обновить` — синхронизация агентов/воркфлоу из GitHub\n• `обновить апп` — проверить новую версию GravityHub\n• `починить` — восстановить файлы\n• `помощь` — эта справка")

        default:
            await botSay("Не понял команду. Напиши `помощь` чтобы увидеть список.")
            quickReplies = [
                QuickReply(label: "📊 Статус", value: "статус"),
                QuickReply(label: "🔄 Обновить", value: "обновить"),
                QuickReply(label: "🔧 Починить", value: "починить")
            ]
        }
    }

    // MARK: - Status

    private func showStatus(profile: UserProfile) async {
        await logSay("🔍 Проверяю окружение...")
        let manifest = profile.profession.setupManifest
        var ok = 0
        var missing: [String] = []

        for file in manifest {
            let dest = file.destinationURL(profile: profile)
            if FileManager.default.fileExists(atPath: dest.path) {
                ok += 1
            } else {
                missing.append(file.destinationRelative)
            }
        }

        let emoji = missing.isEmpty ? "🟢" : "🟡"
        var report = "\(emoji) **Статус окружения**\n\n✅ Установлено: \(ok)/\(manifest.count) файлов"

        if !missing.isEmpty {
            report += "\n\n⚠️ Отсутствуют:\n" + missing.prefix(5).map { "• \($0)" }.joined(separator: "\n")
            if missing.count > 5 { report += "\n  ...и ещё \(missing.count - 5)" }
            report += "\n\nНапиши `починить` чтобы восстановить."
        }

        await botSay(report)
        if !missing.isEmpty {
            quickReplies = [QuickReply(label: "🔧 Починить", value: "починить")]
        }
    }

    // MARK: - Update

    private func checkUpdates(profile: UserProfile) async {
        let result = await updater.checkForUpdates()
        if case .updatesAvailable = result {
            await botSay("🔔 Новые агенты/воркфлоу на GitHub. Напиши `обновить` чтобы применить.")
            quickReplies = [QuickReply(label: "🔄 Обновить сейчас", value: "обновить")]
        }
    }

    private func checkAppUpdate() async {
        guard AppUpdater.shared.shouldCheck else { return }
        let result = await AppUpdater.shared.checkForUpdate()
        if case .updateAvailable(let release) = result {
            await botSay("🆙 **Новая версия GravityHub \(release.version)**\n\n\(release.releaseNotes.prefix(200))...\n\nНапиши `обновить апп` чтобы скачать.")
            quickReplies = [QuickReply(label: "⬇️ Обновить приложение", value: "обновить апп")]
        }
    }

    private func runAppUpdate() async {
        await logSay("🔍 Проверяю новую версию GravityHub...")
        let result = await AppUpdater.shared.checkForUpdate()
        switch result {
        case .upToDate(let v):
            await botSay("✅ У тебя актуальная версия **\(v)**")
        case .updateAvailable(let release):
            await logSay("⬇️ Скачиваю v\(release.version)...")
            let msg = await AppUpdater.shared.downloadAndInstall(release: release)
            await botSay(msg)
        case .error(let err):
            await botSay("❌ Ошибка проверки обновления: \(err)")
        }
    }

    private func runUpdate(profile: UserProfile) async {
        await logSay("🔄 Проверяю обновления на GitHub...")
        let result = await updater.checkForUpdates()

        switch result {
        case .upToDate:
            await botSay("✅ Всё актуально, обновлений нет.")

        case .updatesAvailable:
            await logSay("📦 Скачиваю обновлённые файлы...")
            let manifest = profile.profession.setupManifest
            var updated = 0
            for file in manifest {
                let dest = file.destinationURL(profile: profile)
                // Force re-download by removing existing
                try? FileManager.default.removeItem(at: dest)
                let res = await downloadFile(from: file.source.rawURL(for: file.sourcePath), to: dest)
                if case .success = res { updated += 1 }
            }
            await botSay("✅ Обновлено \(updated) файлов.")

        case .error(let msg):
            await botSay("❌ Ошибка при проверке обновлений: \(msg)")
        }
    }

    // MARK: - Repair

    private func repair(profile: UserProfile) async {
        await logSay("🔧 Восстанавливаю отсутствующие файлы...")
        let manifest = profile.profession.setupManifest
        var fixed = 0

        for file in manifest {
            let dest = file.destinationURL(profile: profile)
            if !FileManager.default.fileExists(atPath: dest.path) {
                let res = await downloadFile(from: file.source.rawURL(for: file.sourcePath), to: dest)
                if case .success = res {
                    fixed += 1
                    await appendToLastLog("   ✅ \(file.destinationRelative)\n")
                }
            }
        }

        await botSay(fixed > 0
            ? "✅ Восстановлено \(fixed) файлов."
            : "✅ Всё на месте, ничего не потеряно.")
    }

    // MARK: - File Download

    enum DownloadResult {
        case success, skipped, failed(String)
    }

    private func downloadFile(from url: URL, to destination: URL) async -> DownloadResult {
        if FileManager.default.fileExists(atPath: destination.path) {
            return .skipped
        }

        // Create parent dirs
        let dir = destination.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return .failed("HTTP \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            }
            try data.write(to: destination)
            return .success
        } catch {
            return .failed(error.localizedDescription)
        }
    }

    // MARK: - Helpers

    private var selectedTools: Set<AITool> = []

    private func lastUserName() -> String {
        for msg in messages.reversed() where msg.role == .user {
            return msg.text
        }
        return "User"
    }

    func botSay(_ text: String) async {
        isTyping = true
        try? await Task.sleep(nanoseconds: 300_000_000)
        isTyping = false
        addMessage(.init(role: .bot, text: text))
    }

    func logSay(_ text: String) async {
        addMessage(.init(role: .log, text: text))
    }

    func appendToLastLog(_ text: String) {
        for i in messages.indices.reversed() {
            if messages[i].role == .log {
                messages[i] = ChatMessage(role: .log, text: messages[i].text + text)
                return
            }
        }
        messages.append(.init(role: .log, text: text))
    }

    private func addMessage(_ msg: ChatMessage) {
        messages.append(msg)
    }

    private func pickFolder() async -> String? {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                let panel = NSOpenPanel()
                panel.canChooseFiles = false
                panel.canChooseDirectories = true
                panel.allowsMultipleSelection = false
                panel.prompt = "Выбрать папку проектов"
                if panel.runModal() == .OK {
                    continuation.resume(returning: panel.url?.path)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
