import SwiftUI

struct OnboardingWizardView: View {
    @State private var userName: String = ""
    @State private var usesWeb: Bool = false
    @State private var usesBackend: Bool = false
    @State private var usesApple: Bool = false
    @State private var usesAI: Bool = false
    @State private var usesMobile: Bool = false
    @State private var usesCloud: Bool = false
    @State private var usesSecurity: Bool = false
    @State private var usesDesign: Bool = false
    @State private var usesProduct: Bool = false
    
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
                    Text("Select Your Focus Areas")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    ScrollView(showsIndicators: true) {
                        VStack(spacing: 12) {
                            StackToggle(title: "Frontend & Web", icon: "globe", description: "React, Next.js, HTML/CSS", isOn: $usesWeb)
                            StackToggle(title: "Backend & APIs", icon: "server.rack", description: "Node.js, Go, Databases", isOn: $usesBackend)
                            StackToggle(title: "Apple Ecosystem", icon: "applelogo", description: "Swift, SwiftUI, macOS/iOS", isOn: $usesApple)
                            StackToggle(title: "AI & Machine Learning", icon: "brain", description: "Python, LLMs, MLX", isOn: $usesAI)
                            StackToggle(title: "Mobile Cross-Platform", icon: "apps.iphone", description: "React Native, Flutter", isOn: $usesMobile)
                            StackToggle(title: "Cloud & DevOps", icon: "cloud", description: "AWS, Docker, CI/CD", isOn: $usesCloud)
                            StackToggle(title: "Security & QA", icon: "lock.shield", description: "Pentest, Audits, Testing", isOn: $usesSecurity)
                            StackToggle(title: "Design & UI/UX", icon: "paintpalette", description: "Figma, User Experience", isOn: $usesDesign)
                            StackToggle(title: "Product & Strategy", icon: "briefcase", description: "PM, Agile, Marketing", isOn: $usesProduct)
                        }
                        .padding(.trailing, 8)
                    }
                    .frame(maxHeight: 280)
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
                    .disabled(isConfiguring || userName.trimmingCharacters(in: .whitespaces).isEmpty || (!usesWeb && !usesBackend && !usesApple && !usesAI && !usesMobile && !usesCloud && !usesSecurity && !usesDesign && !usesProduct))
                    
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
        
        // Write profile and KI
        createKnowledgeItem()
        
        // Slight delay to show configuring state briefly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isConfiguring = false
            onComplete?()
        }
    }
    
    private func createKnowledgeItem() {
        let knowledgeDir = NSHomeDirectory() + "/.gemini/antigravity/knowledge/user_ecosystem_profile"
        let artifactsDir = knowledgeDir + "/artifacts"
        
        let fm = FileManager.default
        try? fm.createDirectory(atPath: artifactsDir, withIntermediateDirectories: true)
        
        // 🔒 BACKUP LEGACY PROFILE
        let oldProfilePath = artifactsDir + "/PROFILE.md"
        if fm.fileExists(atPath: oldProfilePath) {
            let timestamp = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: ":", with: "-")
            let backupPath = artifactsDir + "/PROFILE_legacy_\(timestamp).md"
            try? fm.copyItem(atPath: oldProfilePath, toPath: backupPath)
        }
        
        let metadata = """
        {
          "title": "Global User Ecosystem Profile & Active Stack",
          "summary": "Contains the user's identity and preferred tech stacks. Always read this to understand the user's environment.",
          "timestamp": "\\(ISO8601DateFormatter().string(from: Date()))"
        }
        """
        
        var stackList = ""
        var skillsList = ""
        
        if usesWeb {
            stackList += "- **Frontend:** Next.js, React, HTML/CSS\\n"
            skillsList += "- `skills/frontend/nextjs-app-router.md`\\n- `skills/frontend/react-nextjs-development.md`\\n- `skills/frontend/frontend_best_practices.md`\\n- `skills/frontend/shadcn.md`\\n"
        }
        if usesBackend {
            stackList += "- **Backend:** Node, Go, DBs\\n"
            skillsList += "- `skills/backend/api-design-guidelines.md`\\n- `skills/backend/node-best-practices.md`\\n- `skills/databases/database-design.md`\\n"
        }
        if usesApple {
            stackList += "- **Apple Native:** Swift, SwiftUI\\n"
            skillsList += "- `skills/frontend/swiftui-guidelines.md`\\n- `skills/backend/macos-native-dev.md`\\n- `skills/frontend/hig-components-system.md`\\n"
        }
        if usesAI {
            stackList += "- **AI:** Python, MLX, LLMs\\n"
            skillsList += "- `skills/backend/python-fastapi-development.md`\\n- `skills/ai-ml/prompt-engineering.md`\\n- `skills/ai-ml/llm-integration.md`\\n"
        }
        if usesMobile {
            stackList += "- **Mobile:** React Native, Flutter\\n"
            skillsList += "- `skills/mobile/react-native-best-practices.md`\\n- `skills/mobile/flutter-architecture.md`\\n"
        }
        if usesCloud {
            stackList += "- **Cloud:** Docker, CI/CD\\n"
            skillsList += "- `skills/cloud-devops/docker-expert.md`\\n- `skills/cloud-devops/deployment-pipeline-design.md`\\n"
        }
        if usesSecurity {
            stackList += "- **Security:** Testing, Pentest\\n"
            skillsList += "- `skills/security/OWASP-TOP-10.md`\\n- `skills/security/penetration-testing-guide.md`\\n"
        }
        if usesDesign {
            stackList += "- **Design:** UI/UX, Figma\\n"
            skillsList += "- `skills/design-ui/ui-taste-design.md`\\n- `skills/design-ui/figma-components.md`\\n"
        }
        if usesProduct {
            stackList += "- **Product:** Strategy, Agile\\n"
            skillsList += "- `skills/business-agile/agile-workflows.md`\\n- `skills/business-agile/clean-agile.md`\\n"
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
        - `global_workflows/ci-cd/github-workflow-automation.md`
        - `global_workflows/qa-testing/qa-orchestrator.md`

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
                    .foregroundColor(isOn ? .blue : Color(NSColor.quaternaryLabelColor))
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
