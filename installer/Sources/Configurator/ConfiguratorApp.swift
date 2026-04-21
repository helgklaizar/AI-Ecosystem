import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}

@main
struct ConfiguratorApp: App {
    init() {
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .frame(width: 560, height: 460)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
