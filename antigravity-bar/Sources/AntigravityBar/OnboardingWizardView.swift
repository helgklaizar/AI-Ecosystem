import SwiftUI

struct OnboardingWizardView: View {
    @State private var userName: String = ""
    @State private var usesAppleNative: Bool = false
    @State private var usesWeb: Bool = false
    @State private var usesAI: Bool = false
    
    @State private var isConfiguring: Bool = false
    
    var onComplete: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(
                        LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .padding(.bottom, 8)
                
                Text("Welcome to Antigravity")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                
                Text("Let's configure your local AI ecosystem.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .padding(.bottom, 30)
            
            // Form
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Name")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    TextField("Enter your name", text: $userName)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Your Tech Stack")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    StackToggle(title: "Apple Native", icon: "applelogo", description: "Swift, SwiftUI, macOS apps", isOn: $usesAppleNative)
                    StackToggle(title: "Modern Web", icon: "globe", description: "Next.js, React, Node.js", isOn: $usesWeb)
                    StackToggle(title: "AI & Systems", icon: "brain", description: "Python, MLX, Rust", isOn: $usesAI)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Footer
            VStack(spacing: 16) {
                Divider()
                
                HStack {
                    Spacer()
                    
                    Button(action: configureEcosystem) {
                        HStack {
                            if isConfiguring {
                                ProgressView()
                                    .controlSize(.small)
                                    .padding(.trailing, 4)
                            }
                            Text(isConfiguring ? "Configuring..." : "Optimize Ecosystem")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .frame(width: 200, height: 32)
                    }
                    .buttonStyle(.plain)
                    .background(
                        LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .disabled(isConfiguring || userName.trimmingCharacters(in: .whitespaces).isEmpty || (!usesAppleNative && !usesWeb && !usesAI))
                    
                    Spacer()
                }
                .padding(.vertical, 16)
            }
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(width: 450, height: 580)
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow).ignoresSafeArea())
    }
    
    private func configureEcosystem() {
        isConfiguring = true
        
        // Run background task to simulate config and create KI
        DispatchQueue.global().async {
            createKnowledgeItem()
            
            DispatchQueue.main.async {
                isConfiguring = false
                onComplete?()
            }
        }
    }
    
    private func createKnowledgeItem() {
        let knowledgeDir = NSHomeDirectory() + "/.gemini/antigravity/knowledge/user_ecosystem_profile"
        let artifactsDir = knowledgeDir + "/artifacts"
        
        let fm = FileManager.default
        try? fm.createDirectory(atPath: artifactsDir, withIntermediateDirectories: true)
        
        let metadata = """
        {
          "title": "Global User Ecosystem Profile & Active Stack",
          "summary": "Contains the user's identity and preferred tech stacks. Always read this to understand the user's environment.",
          "timestamp": "\\(ISO8601DateFormatter().string(from: Date()))"
        }
        """
        
        var stackList = ""
        var skillsList = ""
        
        if usesAppleNative {
            stackList += "- **Apple Native:** Swift, SwiftUI\\n"
            skillsList += "- `macos-native-dev.md`\\n"
        }
        if usesWeb {
            stackList += "- **Web:** Next.js, React, Node.js\\n"
            skillsList += "- `frontend_best_practices.md`\\n"
        }
        if usesAI {
            stackList += "- **AI:** Python, MLX, Rust\\n"
            skillsList += "- `python-fastapi-development.md`\\n"
        }
        
        let profile = """
        # 👤 Antigravity Ecosystem Profile

        ## Identity
        - **Name:** \\(userName)
        - **Role:** Engineer

        ## Global Technology Stack
        \\(stackList)

        ## Active Ecosystem Status
        *(Note for Agent: This profile is dynamically managed by the Antigravity Status Bar.)*

        **Loaded Workflows:**
        - `github-workflow-automation.md`
        - `qa-orchestrator.md`

        **Loaded Skills:**
        \\(skillsList)
        """
        
        try? metadata.write(toFile: knowledgeDir + "/metadata.json", atomically: true, encoding: .utf8)
        try? profile.write(toFile: artifactsDir + "/PROFILE.md", atomically: true, encoding: .utf8)
    }
}

struct StackToggle: View {
    let title: String
    let icon: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isOn ? .blue : .secondary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isOn ? .primary : .secondary)
                    
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isOn ? .blue : .quaternaryLabel)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isOn ? Color.blue.opacity(0.1) : Color(NSColor.controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isOn ? Color.blue.opacity(0.3) : Color(NSColor.separatorColor), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
