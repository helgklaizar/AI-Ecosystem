import SwiftUI

// MARK: - App Navigation

enum AppScreen {
    case welcome
    case onboarding
    case deploying(profile: UserProfile)
    case main(profile: UserProfile)
}

struct AppRootView: View {
    @State private var screen: AppScreen = AppStore.shared.profile != nil ? .main(profile: AppStore.shared.profile!) : .welcome

    var body: some View {
        ZStack {
            Color(hex: "0A0A0F").ignoresSafeArea()

            switch screen {
            case .welcome:
                WelcomeView { screen = .onboarding }

            case .onboarding:
                OnboardingFormView { profile in
                    screen = .deploying(profile: profile)
                }

            case .deploying(let profile):
                DeployView(profile: profile) {
                    screen = .main(profile: profile)
                }

            case .main(let profile):
                MainAppView(profile: profile)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: screenID)
    }

    private var screenID: Int {
        switch screen {
        case .welcome: return 0
        case .onboarding: return 1
        case .deploying: return 2
        case .main: return 3
        }
    }
}

// MARK: - Welcome

struct WelcomeView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                // Logo
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color(hex: "A855F7"), Color(hex: "6366F1")],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 72, height: 72)
                    Text("⚡")
                        .font(.system(size: 32))
                }

                VStack(spacing: 8) {
                    Text("AI Ecosystem")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Text("Set up your AI workspace in 2 minutes.\nOne setup. Everything works.")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                Button(action: onStart) {
                    Text("Get Started")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(LinearGradient(
                            colors: [Color(hex: "A855F7"), Color(hex: "6366F1")],
                            startPoint: .leading, endPoint: .trailing
                        ))
                        .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }

            Spacer()

            Text("v\(AppUpdater.currentVersion) · helgklaizar/AI-Ecosystem")
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.2))
                .padding(.bottom, 20)
        }
    }
}

// MARK: - Onboarding Form

struct OnboardingFormView: View {
    let onDone: (UserProfile) -> Void

    @State private var name: String = ""
    @State private var selectedProfession: Profession? = nil
    @State private var customStack: String = ""
    @State private var selectedTools: Set<AITool> = [.antigravity]
    @State private var projectsPath: String = "~/Documents/PROJECTS"
    @State private var step: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color.white.opacity(0.07)).frame(height: 2)
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [Color(hex: "A855F7"), Color(hex: "6366F1")],
                            startPoint: .leading, endPoint: .trailing
                        ))
                        .frame(width: geo.size.width * CGFloat(step + 1) / 4.0, height: 2)
                        .animation(.easeInOut, value: step)
                }
            }
            .frame(height: 2)

            Spacer()

            // Step content
            Group {
                if step == 0 { stepName }
                else if step == 1 { stepProfession }
                else if step == 2 { stepTools }
                else { stepPath }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))

            Spacer()

            // Navigation
            HStack {
                if step > 0 {
                    Button("← Back") { withAnimation { step -= 1 } }
                        .buttonStyle(.plain)
                        .foregroundColor(.white.opacity(0.4))
                        .font(.system(size: 13))
                }
                Spacer()
                Button(action: nextStep) {
                    Text(step == 3 ? "Install ⚡" : "Next →")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(canProceed
                            ? LinearGradient(colors: [Color(hex: "A855F7"), Color(hex: "6366F1")], startPoint: .leading, endPoint: .trailing)
                            : LinearGradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .disabled(!canProceed)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 28)
        }
    }

    // MARK: Step 0 — Name

    var stepName: some View {
        VStack(spacing: 20) {
            stepLabel("What's your name?", icon: "👤", index: 1)
            TextField("Name", text: $name)
                .textFieldStyle(.plain)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)
        }
        .id("name")
    }

    // MARK: Step 1 — Profession

    var stepProfession: some View {
        VStack(spacing: 20) {
            stepLabel("What do you do?", icon: "💼", index: 2)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 10) {
                ForEach(Profession.allCases, id: \.self) { p in
                    let selected = selectedProfession == p
                    Button { withAnimation { selectedProfession = p } } label: {
                        VStack(spacing: 6) {
                            Text(p.icon).font(.system(size: 22))
                            Text(p.displayName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(selected ? .white : .white.opacity(0.6))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(selected
                            ? LinearGradient(colors: [Color(hex: "A855F7").opacity(0.3), Color(hex: "6366F1").opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Color.white.opacity(0.06), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(selected ? Color(hex: "A855F7") : Color.clear, lineWidth: 1.5))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 32)
        }
        .id("profession")
    }

    // MARK: Step 2 — AI Tools

    var stepTools: some View {
        VStack(spacing: 20) {
            stepLabel("Which AI tools do you use?", icon: "🤖", index: 3)
            VStack(spacing: 8) {
                ForEach(AITool.allCases, id: \.self) { tool in
                    let on = selectedTools.contains(tool)
                    Button {
                        withAnimation {
                            if on { selectedTools.remove(tool) }
                            else { selectedTools.insert(tool) }
                        }
                    } label: {
                        HStack {
                            Text(tool.icon).font(.system(size: 18))
                            Text(tool.displayName)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                            if on {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(hex: "A855F7"))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(on ? Color(hex: "1E1A2E") : Color.white.opacity(0.05))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(on ? Color(hex: "A855F7").opacity(0.5) : Color.clear, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 32)
        }
        .id("tools")
    }

    // MARK: Step 3 — Path

    var stepPath: some View {
        VStack(spacing: 20) {
            stepLabel("Where do you store your projects?", icon: "📁", index: 4)
            VStack(spacing: 10) {
                HStack {
                    TextField("~/Documents/PROJECTS", text: $projectsPath)
                        .textFieldStyle(.plain)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundColor(.white)
                    Button {
                        if let path = pickFolder() { projectsPath = path }
                    } label: {
                        Image(systemName: "folder.badge.plus")
                            .foregroundColor(Color(hex: "A855F7"))
                    }
                    .buttonStyle(.plain)
                }
                .padding(14)
                .background(Color.white.opacity(0.07))
                .cornerRadius(10)

                // Summary
                if let prof = selectedProfession {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("What will be installed:")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.4))
                        HStack(spacing: 16) {
                            pill("\(prof.setupManifest.count) files")
                            pill("\(selectedTools.count) AI tools")
                            pill(prof.displayName)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 32)
        }
        .id("path")
    }

    // MARK: - Helpers

    func stepLabel(_ title: String, icon: String, index: Int) -> some View {
        VStack(spacing: 8) {
            Text(icon).font(.system(size: 28))
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    func pill(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(Color(hex: "A855F7"))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color(hex: "A855F7").opacity(0.1))
            .cornerRadius(6)
    }

    var canProceed: Bool {
        switch step {
        case 0: return !name.trimmingCharacters(in: .whitespaces).isEmpty
        case 1: return selectedProfession != nil
        case 2: return !selectedTools.isEmpty
        case 3: return !projectsPath.trimmingCharacters(in: .whitespaces).isEmpty
        default: return false
        }
    }

    func nextStep() {
        if step < 3 { withAnimation { step += 1 }; return }

        let profile = UserProfile(
            name: name.trimmingCharacters(in: .whitespaces),
            profession: selectedProfession!,
            aiTools: Array(selectedTools),
            projectsRootPath: projectsPath,
            onboardingComplete: true
        )
        AppStore.shared.saveProfile(profile)
        onDone(profile)
    }

    func pickFolder() -> String? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "Choose"
        return panel.runModal() == .OK ? panel.url?.path : nil
    }
}

// MARK: - Deploy View

struct DeployView: View {
    let profile: UserProfile
    let onDone: () -> Void

    @State private var logs: [String] = []
    @State private var progress: Double = 0
    @State private var isRunning = true

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                if isRunning {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(Color(hex: "A855F7"))
                } else {
                    Text("✅").font(.system(size: 40))
                }

                Text(isRunning ? "Setting up your environment..." : "Готово!")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4).fill(Color.white.opacity(0.08)).frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(
                                colors: [Color(hex: "A855F7"), Color(hex: "6366F1")],
                                startPoint: .leading, endPoint: .trailing
                            ))
                            .frame(width: geo.size.width * progress, height: 6)
                            .animation(.easeInOut, value: progress)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 40)

                // Log scroll
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(logs.indices, id: \.self) { i in
                                Text(logs[i])
                                    .font(.system(size: 11, design: .monospaced))
                                    .foregroundColor(Color(hex: "A8FF78"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .id(i)
                            }
                        }
                        .padding(12)
                    }
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .frame(height: 150)
                    .padding(.horizontal, 40)
                    .onChange(of: logs.count) { _ in
                        proxy.scrollTo(logs.count - 1, anchor: .bottom)
                    }
                }
            }

            Spacer()
        }
        .onAppear { Task { await runDeploy() } }
    }

    func log(_ msg: String) {
        DispatchQueue.main.async { logs.append(msg) }
    }

    func runDeploy() async {
        let analyzer = WorkspaceAnalyzer.shared
        let manifest = profile.profession.setupManifest
        let total = Double(manifest.count + 3)
        var done = 0.0

        log("▶ Starting setup")
        log("📁 ~/.gemini/antigravity/")

        await analyzer.deployUserLevel(profile: profile) { msg in log(msg) }
        done += 1; DispatchQueue.main.async { progress = done / total }

        await analyzer.deployWorkspaceLevel(profile: profile) { msg in log(msg) }
        done += 1; DispatchQueue.main.async { progress = done / total }

        log("📦 Downloading files from GitHub...")
        for file in manifest {
            let dest = file.destinationURL(profile: profile)
            let url = file.source.rawURL(for: file.sourcePath)
            if !FileManager.default.fileExists(atPath: dest.path) {
                let dir = dest.deletingLastPathComponent()
                try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
                if let data = try? await URLSession.shared.data(from: url).0 {
                    try? data.write(to: dest)
                    log("  ✅ \(file.destinationRelative)")
                }
            } else {
                log("  ⏭ \(file.destinationRelative)")
            }
            done += 1
            let p = done / total
            DispatchQueue.main.async { progress = p }
        }

        await analyzer.initGitStructure(profile: profile) { msg in log(msg) }
        done += 1; DispatchQueue.main.async { progress = 1.0 }

        log("✅ Environment ready")
        log("ℹ️  Rules at ~/.gemini/antigravity/STRUCTURE.md")

        try? await Task.sleep(nanoseconds: 800_000_000)
        DispatchQueue.main.async {
            isRunning = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { onDone() }
        }
    }
}

// MARK: - Done View

struct DoneView: View {
    let profile: UserProfile

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Text("⚡").font(.system(size: 48))

                VStack(spacing: 8) {
                    Text("All done, \(profile.name)!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    Text("You can close this window.")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.4))
                }

                // What was installed
                VStack(alignment: .leading, spacing: 8) {
                    infoRow("👤", "Profession", profile.profession.displayName)
                    infoRow("🤖", "AI Tools", profile.aiTools.map { $0.displayName }.joined(separator: ", "))
                    infoRow("📁", "Projects", profile.projectsRootPath)
                    infoRow("📄", "Rules", "~/.gemini/antigravity/STRUCTURE.md")
                }
                .padding(16)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal, 40)

                Text("Your AI agent now knows the structure\nand will maintain it automatically.")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.35))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                Button("Close") { NSApp.terminate(nil) }
                    .buttonStyle(.plain)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(hex: "A855F7"))
            }

            Spacer()
        }
    }

    func infoRow(_ icon: String, _ label: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(icon).font(.system(size: 13))
            Text(label + ":")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.4))
                .frame(width: 100, alignment: .leading)
            Text(value)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
