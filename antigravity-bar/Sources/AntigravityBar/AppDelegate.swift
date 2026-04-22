import AppKit
import Foundation
import ServiceManagement

@_silgen_name("CGSMainConnectionID") func CGSMainConnectionID() -> CInt
@_silgen_name("CGSSetWindowLevel") func CGSSetWindowLevel(_ connection: CInt, _ window: CInt, _ level: CInt) -> CInt

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private var pollTimer: Timer?
    private var lastQuota: QuotaData?
    private var daemonOnline = false
    private let api = AntigravityAPI.shared
    private var isMenuOpen = false

    // Paths
    private let geminiDir = NSHomeDirectory() + "/.gemini"
    private let antigravityDir = NSHomeDirectory() + "/.gemini/antigravity"
    private let ecosystemDir = NSHomeDirectory() + "/Documents/PROJECTS/WORK/AI-Ecosystem"

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.attributedTitle = makeBarTitle(models: [])
            button.action = #selector(statusBarClicked(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        startPolling()
    }

    // MARK: - Polling

    private let backgroundInterval: TimeInterval = 60
    private let activeInterval: TimeInterval = 5
    private let retryInterval: TimeInterval = 5

    private func startPolling() {
        fetchAndUpdate()
        scheduleNextPoll()
    }

    private func scheduleNextPoll() {
        pollTimer?.invalidate()
        let interval: TimeInterval
        if !daemonOnline {
            interval = retryInterval
        } else if isMenuOpen {
            interval = activeInterval
        } else {
            interval = backgroundInterval
        }
        pollTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.fetchAndUpdate()
                self?.scheduleNextPoll()
            }
        }
    }

    // MARK: - NSMenuDelegate

    func menuWillOpen(_ menu: NSMenu) {
        isMenuOpen = true
        fetchAndUpdate()
        scheduleNextPoll()
    }

    func menuDidClose(_ menu: NSMenu) {
        isMenuOpen = false
        scheduleNextPoll()
    }

    private func fetchAndUpdate() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let daemon = self.api.findActiveDaemon() else {
                DispatchQueue.main.async {
                    self.daemonOnline = false
                    self.lastQuota = nil
                    self.statusItem.button?.attributedTitle = self.makeBarTitle(models: [])
                }
                return
            }
            self.api.fetchQuota(daemon: daemon) { quota in
                DispatchQueue.main.async {
                    let wasOffline = !self.daemonOnline
                    self.daemonOnline = true
                    self.lastQuota = quota
                    self.statusItem.button?.attributedTitle = self.makeBarTitle(models: quota?.models ?? [])
                    // Switch to normal interval now that we're online
                    if wasOffline { self.scheduleNextPoll() }
                }
            }
        }
    }

    // MARK: - Launch at Login

    private var isLaunchAtLoginEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    private func toggleLaunchAtLogin() {
        do {
            if isLaunchAtLoginEnabled {
                try SMAppService.mainApp.unregister()
            } else {
                try SMAppService.mainApp.register()
            }
        } catch {
            let alert = NSAlert()
            alert.messageText = "Launch at Login Error"
            alert.informativeText = error.localizedDescription
            alert.runModal()
        }
    }



    /// Groups models into 3 categories for bar display, taking min quota per group
    private func groupModels(_ models: [ModelQuota]) -> [(name: String, pct: Int, secsLeft: Double)] {
        struct Group {
            let name: String
            let keywords: [String]
        }
        let groups = [
            Group(name: "Flash", keywords: ["flash"]),
            Group(name: "Pro", keywords: ["pro"]),
            Group(name: "Claude", keywords: ["claude", "sonnet", "opus"]),
            Group(name: "O1", keywords: ["o1", "o3"]),
            Group(name: "Gemma", keywords: ["gemma"])
        ]

        var result: [(name: String, pct: Int, secsLeft: Double)] = []
        for group in groups {
            let matching = models.filter { m in
                let l = m.label.lowercased()
                return group.keywords.contains(where: { l.contains($0) })
            }
            if !matching.isEmpty {
                let minPct = Int(matching.map(\.remainingPercentage).min() ?? 0)
                let minSecs = matching.map(\.secondsUntilReset).min() ?? 0
                result.append((name: group.name, pct: minPct, secsLeft: minSecs))
            }
        }
        return result
    }

    /// Draw a small circular timer: filled pie sector showing elapsed time, white
    private func makeTimerCircle(secondsLeft: Double, size: CGFloat = 14) -> NSImage {
        let maxCycle: Double = 5400 // 90 min cycle
        let elapsed = max(0, min(1, 1.0 - secondsLeft / maxCycle))

        let img = NSImage(size: NSSize(width: size, height: size), flipped: false) { rect in
            let center = NSPoint(x: rect.midX, y: rect.midY)
            let radius = (size - 2) / 2

            // Background circle
            let bgPath = NSBezierPath(ovalIn: rect.insetBy(dx: 1, dy: 1))
            NSColor.white.withAlphaComponent(0.35).setFill()
            bgPath.fill()
            NSColor.white.withAlphaComponent(0.6).setStroke()
            bgPath.lineWidth = 0.75
            bgPath.stroke()

            // Filled pie sector (white) — elapsed portion
            if elapsed > 0.01 {
                let startAngle: CGFloat = 90 // 12 o'clock
                let endAngle = startAngle - CGFloat(elapsed * 360)

                let piePath = NSBezierPath()
                piePath.move(to: center)
                piePath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                piePath.close()
                NSColor.white.withAlphaComponent(0.85).setFill()
                piePath.fill()
            }
            return true
        }
        img.isTemplate = false
        return img
    }

    private func makeBarTitle(models: [ModelQuota]) -> NSAttributedString {
        let result = NSMutableAttributedString()
        let pctFont = NSFont.monospacedSystemFont(ofSize: 13, weight: .bold)
        let sepFont = NSFont.systemFont(ofSize: 11, weight: .regular)

        // Cache size first
        let cache = api.cacheSize()
        let cacheColor = colorForCacheMB(cache.megabytes)
        let cacheStr = NSAttributedString(string: cache.formatted, attributes: [
            .font: pctFont, .foregroundColor: cacheColor
        ])
        result.append(cacheStr)

        if models.isEmpty {
            if !daemonOnline {
                let offStr = NSAttributedString(string: "  |  OFF", attributes: [
                    .font: pctFont, .foregroundColor: NSColor.tertiaryLabelColor
                ])
                result.append(offStr)
            }
        } else {
            let grouped = groupModels(models)
            for g in grouped {
                let color = colorForPercentage(g.pct)

                // Separator before each indicator
                let sep = NSAttributedString(string: "  |  ", attributes: [
                    .font: sepFont, .foregroundColor: NSColor.tertiaryLabelColor
                ])
                result.append(sep)

                // Circle timer
                let circleImg = makeTimerCircle(secondsLeft: g.secsLeft)
                let attachment = NSTextAttachment()
                attachment.image = circleImg
                attachment.bounds = CGRect(x: 0, y: -1, width: 14, height: 14)
                result.append(NSAttributedString(attachment: attachment))
                result.append(NSAttributedString(string: " ", attributes: [.font: sepFont]))

                // Percentage
                let pctStr = NSAttributedString(string: "\(g.pct)%", attributes: [
                    .font: pctFont, .foregroundColor: color
                ])
                result.append(pctStr)
            }
        }

        return result
    }

    private func colorForPercentage(_ pct: Int) -> NSColor {
        if pct > 70 { return NSColor.systemGreen }
        if pct > 40 { return NSColor.systemYellow }
        if pct > 15 { return NSColor.systemOrange }
        return NSColor.systemRed
    }

    private func colorForCacheMB(_ mb: Double) -> NSColor {
        if mb < 100 { return NSColor.systemGreen }
        if mb < 300 { return NSColor.systemYellow }
        if mb < 500 { return NSColor.systemOrange }
        return NSColor.systemRed
    }

    // MARK: - Click Handling

    @objc private func statusBarClicked(_ sender: NSStatusBarButton) {
        showContextMenu()
    }

    // MARK: - Context Menu (Right Click)

    private func showContextMenu() {
        let menu = NSMenu()
        menu.autoenablesItems = false
        menu.delegate = self

        // Header with quota details
        if let quota = lastQuota {
            for model in quota.models {
                let pct = Int(model.remainingPercentage)
                let icon = model.isExhausted ? "🔴" : (pct > 50 ? "🟢" : (pct > 20 ? "🟡" : "🟠"))
                let item = NSMenuItem(title: "\(icon) \(model.label): \(pct)%  (\(model.timeUntilReset))", action: nil, keyEquivalent: "")
                item.isEnabled = false
                menu.addItem(item)
            }
        } else {
            let item = NSMenuItem(title: "⏳ No quota data", action: nil, keyEquivalent: "")
            item.isEnabled = false
            menu.addItem(item)
        }

        menu.addItem(.separator())

        // Chat actions
        menu.addItem(makeItem("🤖 Agent Chat", action: #selector(openNewChatAgent)))
        menu.addItem(makeItem("💬 IDE Chat", action: #selector(openNewChat)))

        menu.addItem(.separator())

        // Ecosystem Actions
        menu.addItem(makeItem("🧬 Agents", action: #selector(openAgents)))
        menu.addItem(makeItem("🛠️ Skills", action: #selector(openSkills)))
        menu.addItem(makeItem("🔀 Workflows", action: #selector(openWorkflows)))
        menu.addItem(makeItem("📖 Ecosystem Guide", action: #selector(openEcosystemGuide)))
        menu.addItem(makeItem("🔄 Sync AI Ecosystem", action: #selector(syncEcosystem)))

        menu.addItem(.separator())

        menu.addItem(makeItem("🔄 Restart LS", action: #selector(restartLS)))
        menu.addItem(makeItem("♻️ Reset Updater", action: #selector(resetUpdater)))
        menu.addItem(makeItem("🔃 Reload", action: #selector(reloadWindow)))

        menu.addItem(.separator())

        // Cleanup
        let brainSizeStr = api.brainSize()
        let cacheSizeStr = api.cacheSize().formatted
        let recSizeStr = api.recordingsSize()

        menu.addItem(makeItem("💾 Clear Cache (\(cacheSizeStr))", action: #selector(clearCache)))
        menu.addItem(makeItem("🧹 Clear Brain (\(brainSizeStr))", action: #selector(clearBrain)))
        menu.addItem(makeItem("🎥 Clear Recordings (\(recSizeStr))", action: #selector(clearRecordings)))

        menu.addItem(.separator())

        // Utility
        menu.addItem(makeItem("📂 Open Brain", action: #selector(openBrain)))
        menu.addItem(makeItem("🔄 Refresh", action: #selector(refreshNow)))
        menu.addItem(makeItem("📌 Toggle IDE on Top", action: #selector(toggleIDEWindowTop)))

        menu.addItem(.separator())

        // Launch at login
        let launchItem = NSMenuItem(title: "🚀 Launch at Login", action: #selector(toggleLaunchAtLoginAction), keyEquivalent: "")
        launchItem.target = self
        launchItem.state = isLaunchAtLoginEnabled ? .on : .off
        menu.addItem(launchItem)

        menu.addItem(.separator())
        menu.addItem(makeItem("⏻ Quit", action: #selector(quitApp)))

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        // Reset menu so left click works again
        DispatchQueue.main.async { [weak self] in
            self?.statusItem.menu = nil
        }
    }

    private func makeItem(_ title: String, action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        return item
    }

    // MARK: - Ecosystem Actions

    @objc private func openAgents() {
        openInAntigravity(antigravityDir + "/agents")
    }
    
    @objc private func openSkills() {
        openInAntigravity(antigravityDir + "/skills")
    }
    
    @objc private func openWorkflows() {
        openInAntigravity(antigravityDir + "/global_workflows")
    }

    @objc private func openEcosystemGuide() {
        openInAntigravity(ecosystemDir + "/ECOSYSTEM_GUIDE.md")
    }

    @objc private func syncEcosystem() {
        let script = "cd '\(ecosystemDir)' && git pull"
        let appleScript = """
            tell application "Terminal"
                activate
                do script "\(script)"
            end tell
        """
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", appleScript]
        task.standardOutput = FileHandle.nullDevice
        task.standardError = FileHandle.nullDevice
        try? task.run()
    }



    @objc private func restartLS() {
        sendAntigravityCommand("antigravity.restartLanguageServer")
    }

    @objc private func toggleLaunchAtLoginAction() {
        toggleLaunchAtLogin()
    }

    @objc private func resetUpdater() {
        sendAntigravityCommand("antigravity.restartUserStatusUpdater")
    }

    @objc private func reloadWindow() {
        sendAntigravityCommand("workbench.action.reloadWindow")
    }

    // MARK: - Actions: New 2

    @objc private func clearBrain() {
        let alert = NSAlert()
        alert.messageText = "Clear Brain?"
        alert.informativeText = "All conversation artifacts will be deleted. This is irreversible."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Clear")
        alert.addButton(withTitle: "Cancel")
        if alert.runModal() == .alertFirstButtonReturn {
            api.clearBrain()
            fetchAndUpdate()
        }
    }

    @objc private func clearCache() {
        let alert = NSAlert()
        alert.messageText = "Clear Cache?"
        alert.informativeText = "All cached conversations and artifacts will be deleted. This is irreversible."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Clear")
        alert.addButton(withTitle: "Cancel")
        if alert.runModal() == .alertFirstButtonReturn {
            api.clearCache()
            fetchAndUpdate()
        }
    }

    @objc private func clearRecordings() {
        let alert = NSAlert()
        alert.messageText = "Clear Browser Recordings?"
        alert.informativeText = "All recorded browser session videos will be deleted."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Clear")
        alert.addButton(withTitle: "Cancel")
        if alert.runModal() == .alertFirstButtonReturn {
            api.clearRecordings()
            fetchAndUpdate()
        }
    }

    private let antigravityCLI = "/Applications/Antigravity.app/Contents/Resources/app/bin/antigravity"

    @objc private func openNewChat() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.message = "Choose folder for new chat"
        panel.prompt = "Open"
        panel.directoryURL = URL(fileURLWithPath: NSHomeDirectory())

        if panel.runModal() == .OK, let folderURL = panel.url {
            let fm = FileManager.default
            if fm.fileExists(atPath: antigravityCLI) {
                let task = Process()
                task.launchPath = antigravityCLI
                task.arguments = ["chat"]
                task.currentDirectoryURL = folderURL
                task.standardOutput = FileHandle.nullDevice
                task.standardError = FileHandle.nullDevice
                try? task.run()
            } else {
                if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.google.antigravity") {
                    NSWorkspace.shared.openApplication(at: url, configuration: .init())
                }
            }
        }
    }

    @objc private func openNewChatAgent() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.message = "Choose folder for agent"
        panel.prompt = "Open"
        panel.directoryURL = URL(fileURLWithPath: NSHomeDirectory())

        if panel.runModal() == .OK, let folderURL = panel.url {
            // Launch antigravity chat in Terminal.app
            let script = "cd '\(folderURL.path)' && '\(antigravityCLI)' chat"
            let appleScript = """
                tell application "Terminal"
                    activate
                    do script "\(script)"
                end tell
            """
            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = ["-e", appleScript]
            task.standardOutput = FileHandle.nullDevice
            task.standardError = FileHandle.nullDevice
            try? task.run()
        }
    }



    // MARK: - Utility

    @objc private func toggleIDEWindowTop() {
        let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        guard let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else { return }

        for windowInfo in windowList {
            if let name = windowInfo[kCGWindowOwnerName as String] as? String, name.lowercased().contains("antigravity"),
               let bounds = windowInfo[kCGWindowBounds as String] as? [String: CGFloat],
               let height = bounds["Height"], height > 100 {
                
                if let windowID = windowInfo[kCGWindowNumber as String] as? CInt,
                   let layer = windowInfo[kCGWindowLayer as String] as? CInt {
                    let newLevel: CInt = (layer > 0) ? 0 : 3
                    _ = CGSSetWindowLevel(CGSMainConnectionID(), windowID, newLevel)
                }
            }
        }
    }

    @objc private func openBrain() {
        api.openBrain()
    }

    @objc private func refreshNow() {
        fetchAndUpdate()
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    private func openInAntigravity(_ path: String) {
        // Try to open in Antigravity IDE first, fallback to default
        let url = URL(fileURLWithPath: path)
        let config = NSWorkspace.OpenConfiguration()
        // Try common Antigravity bundle IDs
        let bundleIDs = [
            "com.google.antigravity",
            "com.google.android.studio.antigravity",
            "com.todesktop.241115phmt2hfaz"
        ]
        for bid in bundleIDs {
            if let appUrl = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bid) {
                NSWorkspace.shared.open([url], withApplicationAt: appUrl, configuration: config)
                return
            }
        }
        NSWorkspace.shared.open(url)
    }

    private func sendAntigravityCommand(_ command: String) {
        let cliPaths = [
            antigravityCLI,
            "/usr/local/bin/antigravity",
            NSHomeDirectory() + "/.local/bin/antigravity"
        ]
        for cli in cliPaths {
            if FileManager.default.fileExists(atPath: cli) {
                let task = Process()
                task.launchPath = cli
                task.arguments = ["--command", command]
                task.standardOutput = FileHandle.nullDevice
                task.standardError = FileHandle.nullDevice
                try? task.run()
                return
            }
        }
    }
}
