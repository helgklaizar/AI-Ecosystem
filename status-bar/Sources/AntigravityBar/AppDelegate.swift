import AppKit
import Foundation
import ServiceManagement

@_silgen_name("CGSMainConnectionID") func CGSMainConnectionID() -> CInt
@_silgen_name("CGSSetWindowLevel") func CGSSetWindowLevel(_ connection: CInt, _ window: CInt, _ level: CInt) -> CInt

struct EnvPaths {
    static let geminiDir = NSHomeDirectory() + "/.gemini"
    static let antigravityDir = NSHomeDirectory() + "/.gemini/antigravity"
    static let ecosystemDir = NSHomeDirectory() + "/Documents/PROJECTS/WORK/AI-Ecosystem"
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private var pollTimer: Timer?
    private var lastQuota: QuotaData?
    private var daemonOnline = false
    private let api = AntigravityAPI.shared
    private var isMenuOpen = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            updateBarTitle(models: [])
            button.action = #selector(statusBarClicked(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        startPolling()
        checkAndShowSetupWizard()
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
                    self.updateBarTitle(models: [])
                }
                return
            }
            self.api.fetchQuota(daemon: daemon) { quota in
                DispatchQueue.main.async {
                    let wasOffline = !self.daemonOnline
                    self.daemonOnline = true
                    self.lastQuota = quota
                    self.updateBarTitle(models: quota?.models ?? [])
                    if wasOffline { self.scheduleNextPoll() }
                }
            }
        }
    }

    private func updateBarTitle(models: [ModelQuota]) {
        let cache = api.cacheSize()
        statusItem.button?.attributedTitle = StatusBarUI.makeBarTitle(
            models: models, 
            daemonOnline: daemonOnline, 
            cacheFormatted: cache.formatted, 
            cacheMB: cache.megabytes
        )
    }

    // MARK: - Click Handling
    @objc private func statusBarClicked(_ sender: NSStatusBarButton) {
        showContextMenu()
    }

    // MARK: - Context Menu
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

        // BLOCK 1: Core System
        menu.addItem(makeItem("📄 Main GEMINI", action: #selector(openMainGemini)))
        menu.addItem(makeItem("👤 Knowledge Profile", action: #selector(openProfile)))
        menu.addItem(makeItem("🛠️ Skills", action: #selector(openSkills)))
        menu.addItem(makeItem("🔀 Workflows", action: #selector(openWorkflows)))
        
        menu.addItem(.separator())

        // BLOCK 2: Setup & Audit
        menu.addItem(makeItem("🖥️ Setup & Audit Wizard", action: #selector(handleSetupWizard)))

        menu.addItem(.separator())

        // BLOCK 3: Unified Utilities (No nesting)
        menu.addItem(makeItem("🔄 Restart & Reload", action: #selector(restartAndReload)))
        menu.addItem(makeItem("🧹 Full Cleanup", action: #selector(fullCleanup)))

        menu.addItem(.separator())
        menu.addItem(makeItem("⏻ Quit", action: #selector(quitApp)))

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        DispatchQueue.main.async { [weak self] in
            self?.statusItem.menu = nil
        }
    }

    private func makeItem(_ title: String, action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        return item
    }

    // MARK: - Actions

    @objc private func openMainGemini() { openInAntigravity(EnvPaths.geminiDir + "/GEMINI.md") }
    @objc private func openProfile() { openInAntigravity(EnvPaths.antigravityDir + "/knowledge/user_ecosystem_profile/artifacts/PROFILE.md") }
    @objc private func openSkills() { openInAntigravity(EnvPaths.antigravityDir + "/skills") }
    @objc private func openWorkflows() { openInAntigravity(EnvPaths.antigravityDir + "/global_workflows") }

    @objc private func handleSetupWizard() {
        let profilePath = EnvPaths.antigravityDir + "/knowledge/user_ecosystem_profile/metadata.json"
        if FileManager.default.fileExists(atPath: profilePath) {
            TerminalHelper.autoConfigureEcosystem()
        } else {
            WizardWindowController.shared.showWindow()
        }
    }

    private func checkAndShowSetupWizard() {
        let profilePath = EnvPaths.antigravityDir + "/knowledge/user_ecosystem_profile/metadata.json"
        if !FileManager.default.fileExists(atPath: profilePath) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                WizardWindowController.shared.showWindow()
            }
        }
    }

    // MARK: - Unified Utilities

    @objc private func restartAndReload() {
        TerminalHelper.sendAntigravityCommand("antigravity.restartLanguageServer")
        TerminalHelper.sendAntigravityCommand("antigravity.restartUserStatusUpdater")
        TerminalHelper.sendAntigravityCommand("workbench.action.reloadWindow")
    }

    @objc private func fullCleanup() {
        let alert = NSAlert()
        alert.messageText = "Full Cleanup?"
        alert.informativeText = "Cache, Brain, and Recordings will be cleared. (Knowledge is preserved)."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Clear All")
        alert.addButton(withTitle: "Cancel")
        if alert.runModal() == .alertFirstButtonReturn {
            api.clearCache()
            api.clearBrain()
            api.clearRecordings()
            fetchAndUpdate()
        }
    }

    @objc private func quitApp() { NSApp.terminate(nil) }

    private func openInAntigravity(_ path: String) {
        let url = URL(fileURLWithPath: path)
        let config = NSWorkspace.OpenConfiguration()
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
}
