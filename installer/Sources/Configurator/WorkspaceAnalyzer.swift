import Foundation

// MARK: - WorkspaceAnalyzer
// Deploys the full AI ecosystem in 3 levels:
// Level 1: ~/.gemini/antigravity/ (user-level, one time)
// Level 2: <projectsRoot>/.gemini/agents/ (workspace-level)
// Level 3: <projectsRoot>/<project>/ (per-project)

class WorkspaceAnalyzer {
    static let shared = WorkspaceAnalyzer()
    private let fm = FileManager.default

    // MARK: - Level 1: User-level (~/.gemini/)

    func deployUserLevel(profile: UserProfile, log: @escaping (String) -> Void) async {
        guard profile.aiTools.contains(.antigravity) else {
            log("ℹ️ Antigravity not selected — skipping ~/.gemini/ setup\n")
            return
        }

        log("📁 [Level 1] Setting up ~/.gemini/antigravity/...\n")

        let home = fm.homeDirectoryForCurrentUser.path
        let antigravityBase = "\(home)/.gemini/antigravity"

        let dirs = [
            "\(antigravityBase)/global_workflows",
            "\(antigravityBase)/skills",
            "\(antigravityBase)/templates",
            "\(antigravityBase)/knowledge",
            "\(antigravityBase)/brain",
            "\(home)/.gemini",
        ]

        for dir in dirs {
            createDir(dir, log: log)
        }

        // Write settings.json
        let settingsPath = "\(antigravityBase)/settings.json"
        if !fm.fileExists(atPath: settingsPath) {
            let settings: [String: Any] = [
                "profile": [
                    "name": profile.name,
                    "profession": profile.profession.rawValue,
                    "stack": profile.profession.stack
                ],
                "aiTools": profile.aiTools.map { $0.rawValue },
                "version": "1.0.0",
                "createdBy": "Configurator"
            ]
            if let data = try? JSONSerialization.data(withJSONObject: settings, options: .prettyPrinted) {
                fm.createFile(atPath: settingsPath, contents: data)
                log("   ✅ settings.json created\n")
            }
        } else {
            log("   ⏭ settings.json already exists, skipping\n")
        }

        // Write GEMINI.md template
        writeTemplate(
            content: geminiTemplate(for: profile),
            to: "\(antigravityBase)/templates/GEMINI.md",
            name: "templates/GEMINI.md",
            log: log
        )

        // Write AGENTS.md template
        writeTemplate(
            content: agentsTemplate(),
            to: "\(antigravityBase)/templates/AGENTS.md",
            name: "templates/AGENTS.md",
            log: log
        )

        log("✅ [Level 1] User-level setup complete\n\n")
    }

    // MARK: - Level 2: Workspace-level

    func deployWorkspaceLevel(profile: UserProfile, log: @escaping (String) -> Void) async {
        let root = (profile.projectsRootPath as NSString).expandingTildeInPath
        log("📁 [Level 2] Setting up workspace agents at \(root)/.gemini/agents/...\n")

        let agentsDir = "\(root)/.gemini/agents"
        createDir(agentsDir, log: log)

        // Deploy workspace-level agents for this profession
        for agent in profile.profession.workspaceAgents {
            let path = "\(agentsDir)/\(agent.filename)"
            if !fm.fileExists(atPath: path) {
                let content = agent.content(for: profile.profession)
                fm.createFile(atPath: path, contents: content.data(using: .utf8))
                log("   ✅ Agent: \(agent.filename)\n")
            } else {
                log("   ⏭ Agent \(agent.filename) already exists\n")
            }
        }

        // Cursor workspace config if selected
        if profile.aiTools.contains(.cursor) {
            let cursorignorePath = "\(root)/.cursorignore"
            if !fm.fileExists(atPath: cursorignorePath) {
                fm.createFile(atPath: cursorignorePath, contents: cursorignoreContent().data(using: .utf8))
                log("   ✅ .cursorignore created\n")
            }
        }

        log("✅ [Level 2] Workspace-level setup complete\n\n")
    }

    // MARK: - Level 3: New Project

    func initGitStructure(profile: UserProfile, log: @escaping (String) -> Void) async {
        let root = (profile.projectsRootPath as NSString).expandingTildeInPath
        let home = fm.homeDirectoryForCurrentUser.path
        // Ensure all top-level dirs exist
        let dirsToEnsure = [
            "\(home)/.gemini/antigravity/global_workflows",
            "\(home)/.gemini/antigravity/skills",
            "\(home)/.gemini/antigravity/knowledge",
            "\(home)/.gemini/antigravity/brain",
            "\(root)/.gemini/agents",
        ]
        for dir in dirsToEnsure { createDir(dir, log: log) }
        log("   ✅ Directory structure verified\n")
    }

    func deployProjectLevel(
        projectName: String,
        profile: UserProfile,
        log: @escaping (String) -> Void
    ) {
        let root = (profile.projectsRootPath as NSString).expandingTildeInPath
        let projectPath = "\(root)/\(projectName)"

        log("📁 [Level 3] Creating project '\(projectName)' at \(projectPath)...\n")

        // Create project directory
        createDir(projectPath, log: log)

        // Files per selected AI tools
        for tool in profile.aiTools {
            switch tool {
            case .antigravity:
                writeTemplate(
                    content: geminiMd(projectName: projectName, profile: profile),
                    to: "\(projectPath)/GEMINI.md",
                    name: "GEMINI.md",
                    log: log
                )
                writeTemplate(
                    content: agentsMd(profile: profile),
                    to: "\(projectPath)/AGENTS.md",
                    name: "AGENTS.md",
                    log: log
                )
                // Create .gemini/brain/ local memory
                let brainDir = "\(projectPath)/.gemini/brain/.system_generated/logs"
                createDir(brainDir, log: log)
                log("   ✅ Local memory (.gemini/brain/) initialized\n")

                // Create .gemini/agents/ for project-specific agents
                let localAgentsDir = "\(projectPath)/.gemini/agents"
                createDir(localAgentsDir, log: log)
                log("   ✅ Local agents dir (.gemini/agents/) created\n")

            case .claude:
                writeTemplate(
                    content: claudeMd(projectName: projectName, profile: profile),
                    to: "\(projectPath)/CLAUDE.md",
                    name: "CLAUDE.md",
                    log: log
                )
                writeTemplate(
                    content: agentsMd(profile: profile),
                    to: "\(projectPath)/AGENTS.md",
                    name: "AGENTS.md",
                    log: log
                )

            case .cursor:
                writeTemplate(
                    content: cursorRules(profile: profile),
                    to: "\(projectPath)/.cursorrules",
                    name: ".cursorrules",
                    log: log
                )
            }
        }

        // Always: DESIGN.md + .gitignore + git init
        writeTemplate(
            content: designMd(projectName: projectName, profile: profile),
            to: "\(projectPath)/DESIGN.md",
            name: "DESIGN.md",
            log: log
        )

        writeTemplate(
            content: profile.profession.gitignoreContent,
            to: "\(projectPath)/.gitignore",
            name: ".gitignore",
            log: log
        )

        // Git init
        gitInit(in: projectPath, projectName: projectName, log: log)

        log("✅ [Level 3] Project '\(projectName)' ready!\n\n")
    }

    // MARK: - Git

    private func gitInit(in path: String, projectName: String, log: @escaping (String) -> Void) {
        log("   🔧 Running git init...\n")
        runShell("/usr/bin/git", args: ["init", path])

        // Initial commit
        runShell("/usr/bin/git", args: ["-C", path, "add", "."])
        runShell("/usr/bin/git", args: [
            "-C", path,
            "commit", "-m",
            "🚀 Initial setup by Configurator"
        ])
        log("   ✅ Git repository initialized with initial commit\n")
    }

    // MARK: - Helpers

    private func createDir(_ path: String, log: @escaping (String) -> Void) {
        if !fm.fileExists(atPath: path) {
            try? fm.createDirectory(atPath: path, withIntermediateDirectories: true)
            log("   📂 Created: \(URL(fileURLWithPath: path).lastPathComponent)/\n")
        }
    }

    private func writeTemplate(content: String, to path: String, name: String, log: @escaping (String) -> Void) {
        if !fm.fileExists(atPath: path) {
            fm.createFile(atPath: path, contents: content.data(using: .utf8))
            log("   ✅ \(name)\n")
        } else {
            log("   ⏭ \(name) already exists\n")
        }
    }

    @discardableResult
    private func runShell(_ executable: String, args: [String]) -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = args
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        try? process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }

    // MARK: - File Content Generators

    private func geminiTemplate(for profile: UserProfile) -> String {
        """
        # GEMINI.md: Project Context & Strategic Guidelines

        ## Project: [Project Name]
        - **Core Stack**: \(profile.profession.stack)
        - **Strategic Goal**: [Describe the goal]

        ## 🧠 Strategic Memory (Keep During Compact)
        - [Key architectural decisions and benchmark targets]
        - [Global AI tools/models currently in use for this project]

        ## 🧭 Operational Principles
        **1. Think Before Coding** — State plan in 1-2 sentences before editing.
        **2. Simplicity First** — Minimum code that solves the stated problem.
        **3. Surgical Changes** — Touch only what the request requires.
        **4. Goal-Driven** — Define success as something verifiable, then loop until verified.

        ## 🏛 Layout & Structure
        - [High-level overview]
        """
    }

    private func agentsTemplate() -> String {
        """
        Drop-in operating instructions for coding agents. Read this file before every task.

        **Working code only. Finish the job. Plausibility is not correctness.**

        ---

        ## 0. Non-negotiables
        1. **No flattery, no filler.** Start with the answer or the action.
        2. **Disagree when you disagree.** Say so before doing the work.
        3. **Never fabricate.** Not file paths, not API names, not test results.
        4. **Stop when confused.** Ask, don't guess silently.
        5. **Touch only what you must.** Every changed line traces to the user's request.

        ---

        ## 10. Project context
        ### Stack
        - Language and version: `TODO`
        - Framework(s): `TODO`
        - Package manager: `TODO`

        ### Commands
        - Install: `TODO`
        - Build: `TODO`
        - Run locally: `TODO`

        ## 11. Project Learnings
        - (empty)
        """
    }

    func geminiMd(projectName: String, profile: UserProfile) -> String {
        """
        # 🤖 GEMINI.md — \(projectName)

        ## 🌟 Project Overview
        **\(projectName)** — [Description]

        ## 🛠 Tech Stack
        \(profile.profession.stack)

        ## 🚀 Workflow
        - [How this project is built and run]

        ## 📂 Key Directories
        - [List key dirs]

        ---

        ## 🧠 Critical Memory (Keep During Compact)
        - **Profession**: \(profile.profession.displayName)
        - **AI Tools**: \(profile.aiTools.map { $0.displayName }.joined(separator: ", "))

        ## 🛡 Operational Rules
        - Formatting: always run formatter after editing
        - Testing: tests MUST pass before commit
        - Security: never expose `.env` files

        ---
        *Generated by Configurator*
        """
    }

    func agentsMd(profile: UserProfile) -> String {
        """
        Drop-in operating instructions for coding agents. Read before every task.

        **Working code only. Finish the job.**

        ---

        ## 0. Non-negotiables
        1. No flattery, no filler. Start with the answer.
        2. Disagree when you disagree. Say so before starting.
        3. Never fabricate. Read the file or run the command.
        4. Stop when confused. Ask, don't guess.
        5. Touch only what you must.

        ---

        ## 10. Project context
        ### Stack
        - \(profile.profession.stack)

        ### Commands
        - Install: `TODO`
        - Build: `TODO`
        - Run: `TODO`

        ## 11. Project Learnings
        - (empty)
        """
    }

    func claudeMd(projectName: String, profile: UserProfile) -> String {
        """
        # CLAUDE.md — \(projectName)

        ## Project
        **\(projectName)** — [Description]

        ## Stack
        \(profile.profession.stack)

        ## Key rules for Claude
        - No flattery or filler. Start with the answer.
        - Surgical changes only — touch what's needed.
        - Never fabricate file paths or API names.
        - Ask when confused, don't guess.

        ## Commands
        - Install: `TODO`
        - Build: `TODO`
        - Run: `TODO`

        ---
        *Generated by Configurator*
        """
    }

    func designMd(projectName: String, profile: UserProfile) -> String {
        switch profile.profession {
        case .frontendDev, .fullstackDev, .designer:
            return """
            # 🎨 DESIGN.md — \(projectName)

            ## Colors
            - **Background**: `#0A0A0A`
            - **Surface**: `#141414`
            - **Accent**: `#6366F1` (Indigo)
            - **Success**: `#34C759`
            - **Error**: `#FF3B30`
            - **Text Primary**: `#FFFFFF`
            - **Text Secondary**: `#8E8E93`

            ## Typography
            - **Display**: Inter 700
            - **Body**: Inter 400
            - **Mono**: JetBrains Mono

            ## Spacing
            - Base unit: `4px`
            - Scale: 4, 8, 12, 16, 24, 32, 48, 64

            ## Border Radius
            - Small: `6px`, Medium: `12px`, Large: `20px`

            ## Do's
            - Dark mode first
            - Smooth transitions (200ms ease)
            - High contrast ratios (AA minimum)

            ## Don'ts
            - No generic colors
            - No layout shifts
            ---
            *Generated by Configurator*
            """

        case .mlEngineer:
            return """
            # 🎨 DESIGN.md — \(projectName)

            ## Overview
            Technical, raw, Apple-Silicon-optimized aesthetic.

            ## Colors
            - **Background**: `#000000`
            - **Accent**: `#FF9500` (Apple Silicon Orange)
            - **Success/Pass**: `#34C759`
            - **Experimental**: `#AF52DE`
            - **SOTA**: `#007AFF`

            ## Typography
            - **Mono**: SF Mono, JetBrains Mono (all metrics)
            - **Sans**: SF Pro Display, Inter

            ## Layout
            - High-density data grids
            - Terminal-friendly output style
            - Rich table formatting with borders

            ## Don'ts
            - No decorative fluff
            - No soft colors
            ---
            *Generated by Configurator*
            """

        default:
            return """
            # 🎨 DESIGN.md — \(projectName)

            ## Colors
            - **Background**: `#0F0F0F`
            - **Accent**: `#007AFF`
            - **Text**: `#FFFFFF`

            ## Typography
            - **Primary**: Inter
            - **Mono**: JetBrains Mono

            ## Spacing
            - Base: `4px`

            ---
            *Generated by Configurator*
            """
        }
    }

    func cursorRules(profile: UserProfile) -> String {
        """
        # .cursorrules — AI coding rules for Cursor

        ## Stack
        \(profile.profession.stack)

        ## Rules
        - No flattery, no filler. Start with the answer.
        - Surgical changes only. Touch only what's needed.
        - Never fabricate. Read the file or run the command.
        - Ask when the task has two plausible interpretations.
        - Match existing patterns in the codebase exactly.

        ## Style
        - Follow existing indentation and naming conventions.
        - No drive-by refactors or reformatting.
        - Keep DESIGN.md as single source of truth for tokens.
        """
    }

    func cursorignoreContent() -> String {
        """
        node_modules/
        .next/
        dist/
        build/
        .turbo/
        **/*.db
        **/*.sqlite
        **/*.log
        **/.DS_Store
        **/.env
        **/.env.*
        .venv/
        __pycache__/
        **/*.metallib
        **/*.bin
        **/*.dylib
        .build/
        .swiftpm/
        """
    }
}
