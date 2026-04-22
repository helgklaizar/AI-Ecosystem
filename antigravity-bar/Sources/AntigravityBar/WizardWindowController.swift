import AppKit
import SwiftUI

class WizardWindowController: NSWindowController {
    static let shared = WizardWindowController()
    
    private init() {
        // Create a custom window that looks like a native macOS utility window
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 450, height: 580),
            styleMask: [.titled, .fullSizeContentView, .closable],
            backing: .buffered,
            defer: false
        )
        
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.isMovableByWindowBackground = true
        window.backgroundColor = .clear
        window.hasShadow = true
        window.level = .floating // Float above IDE
        
        super.init(window: window)
        
        let view = OnboardingWizardView { [weak self] in
            // Handle completion (close window, maybe show a notification)
            self?.close()
        }
        
        let hostingController = NSHostingController(rootView: view)
        window.contentViewController = hostingController
        window.center()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWindow() {
        window?.center()
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
