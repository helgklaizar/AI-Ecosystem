import Foundation

// MARK: - Ecosystem Source (GitHub repo)

struct EcosystemSource {
    let owner: String
    let repo: String
    let branch: String

    var baseRawURL: String {
        "https://raw.githubusercontent.com/\(owner)/\(repo)/\(branch)"
    }

    var apiCommitURL: URL {
        URL(string: "https://api.github.com/repos/\(owner)/\(repo)/commits/\(branch)")!
    }

    func rawURL(for path: String) -> URL {
        URL(string: "\(baseRawURL)/\(path)")!
    }
}

// MARK: - Known Sources

enum KnownSources {
    static let aiEcosystem = EcosystemSource(
        owner: "helgklaizar",
        repo: "AI-Ecosystem",
        branch: "main"
    )
    // Future sources can be added here:
    // static let awesomeAgents = EcosystemSource(owner: "...", repo: "...", branch: "main")
}

// MARK: - Deploy Level

enum DeployLevel {
    case user          // ~/.gemini/antigravity/
    case workspace     // <projectsRoot>/.gemini/
    case project       // <projectsRoot>/<projectName>/
}

// MARK: - Ecosystem File (what to download and where)

struct EcosystemFile: Identifiable {
    let id = UUID()
    let sourcePath: String        // path in GitHub repo
    let destinationRelative: String  // relative destination path
    let level: DeployLevel
    let source: EcosystemSource

    func destinationURL(profile: UserProfile, projectName: String? = nil) -> URL {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        let projectsRoot = (profile.projectsRootPath as NSString).expandingTildeInPath

        let base: String
        switch level {
        case .user:
            base = "\(home)/.gemini/antigravity"
        case .workspace:
            base = "\(projectsRoot)/.gemini"
        case .project:
            let name = projectName ?? "default"
            base = "\(projectsRoot)/\(name)"
        }

        return URL(fileURLWithPath: "\(base)/\(destinationRelative)")
    }
}

// MARK: - Manifest per Profession

extension Profession {
    // Files to download during initial setup (levels 1 & 2)
    var setupManifest: [EcosystemFile] {
        let src = KnownSources.aiEcosystem

        // Common for everyone
        var files: [EcosystemFile] = [
            // Templates → ~/.gemini/antigravity/templates/
            EcosystemFile(sourcePath: "templates/GEMINI.md",
                          destinationRelative: "templates/GEMINI.md",
                          level: .user, source: src),

            // Universal workspace agents
            EcosystemFile(sourcePath: "agents/architect.md",
                          destinationRelative: "agents/architect.md",
                          level: .workspace, source: src),
            EcosystemFile(sourcePath: "agents/developer.md",
                          destinationRelative: "agents/developer.md",
                          level: .workspace, source: src),
            EcosystemFile(sourcePath: "agents/tester.md",
                          destinationRelative: "agents/tester.md",
                          level: .workspace, source: src),
            EcosystemFile(sourcePath: "agents/huxley-coder.md",
                          destinationRelative: "agents/huxley-coder.md",
                          level: .workspace, source: src),
            EcosystemFile(sourcePath: "agents/swarm-orchestrator.md",
                          destinationRelative: "agents/swarm-orchestrator.md",
                          level: .workspace, source: src),

            // Universal workflows
            EcosystemFile(sourcePath: "global_workflows/new-project.md",
                          destinationRelative: "global_workflows/new-project.md",
                          level: .user, source: src),
            EcosystemFile(sourcePath: "global_workflows/crash-detect.md",
                          destinationRelative: "global_workflows/crash-detect.md",
                          level: .user, source: src),
            EcosystemFile(sourcePath: "global_workflows/github-publish.md",
                          destinationRelative: "global_workflows/github-publish.md",
                          level: .user, source: src),

            // Universal skills
            EcosystemFile(sourcePath: "skills/qa/debugger/SKILL.md",
                          destinationRelative: "skills/qa/debugger/SKILL.md",
                          level: .user, source: src),
            EcosystemFile(sourcePath: "skills/qa/code-reviewer/SKILL.md",
                          destinationRelative: "skills/qa/code-reviewer/SKILL.md",
                          level: .user, source: src),
        ]

        // Profession-specific
        files += professionSpecificFiles(source: src)
        return files
    }

    private func professionSpecificFiles(source: EcosystemSource) -> [EcosystemFile] {
        switch self {
        case .mlEngineer:
            return [
                EcosystemFile(sourcePath: "agents/quant-analyst.md",
                              destinationRelative: "agents/quant-analyst.md",
                              level: .workspace, source: source),
                EcosystemFile(sourcePath: "global_workflows/mac-port-factory.md",
                              destinationRelative: "global_workflows/mac-port-factory.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "global_workflows/quant-scout.md",
                              destinationRelative: "global_workflows/quant-scout.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "global_workflows/quant-backtest.md",
                              destinationRelative: "global_workflows/quant-backtest.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "skills/backend/python-async/SKILL.md",
                              destinationRelative: "skills/backend/python-async/SKILL.md",
                              level: .user, source: source),
            ]

        case .frontendDev, .designer:
            return [
                EcosystemFile(sourcePath: "skills/frontend/ui-ux-animator/SKILL.md",
                              destinationRelative: "skills/frontend/ui-ux-animator/SKILL.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "skills/frontend/react-components/SKILL.md",
                              destinationRelative: "skills/frontend/react-components/SKILL.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "skills/frontend/tauri-integrator/SKILL.md",
                              destinationRelative: "skills/frontend/tauri-integrator/SKILL.md",
                              level: .user, source: source),
            ]

        case .iosDevs:
            return [
                EcosystemFile(sourcePath: "skills/frontend/macos-native-dev/SKILL.md",
                              destinationRelative: "skills/frontend/macos-native-dev/SKILL.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "global_workflows/build-local.md",
                              destinationRelative: "global_workflows/build-local.md",
                              level: .user, source: source),
            ]

        case .backendDev, .fullstackDev:
            return [
                EcosystemFile(sourcePath: "agents/devops.md",
                              destinationRelative: "agents/devops.md",
                              level: .workspace, source: source),
                EcosystemFile(sourcePath: "skills/backend/python-async/SKILL.md",
                              destinationRelative: "skills/backend/python-async/SKILL.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "skills/backend/sandbox-orchestrator/SKILL.md",
                              destinationRelative: "skills/backend/sandbox-orchestrator/SKILL.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "global_workflows/safe-prod-sync.md",
                              destinationRelative: "global_workflows/safe-prod-sync.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "global_workflows/pentest-qa.md",
                              destinationRelative: "global_workflows/pentest-qa.md",
                              level: .user, source: source),
            ]

        case .devops:
            return [
                EcosystemFile(sourcePath: "agents/devops.md",
                              destinationRelative: "agents/devops.md",
                              level: .workspace, source: source),
                EcosystemFile(sourcePath: "global_workflows/safe-prod-sync.md",
                              destinationRelative: "global_workflows/safe-prod-sync.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "global_workflows/deploy-prod.md",
                              destinationRelative: "global_workflows/deploy-prod.md",
                              level: .user, source: source),
                EcosystemFile(sourcePath: "skills/backend/sandbox-orchestrator/SKILL.md",
                              destinationRelative: "skills/backend/sandbox-orchestrator/SKILL.md",
                              level: .user, source: source),
            ]
        }
    }
}

// MARK: - Update Checker

class UpdateChecker {
    static let shared = UpdateChecker()

    private let lastSHAKey = "lastKnownSHA_antigravity"

    var storedSHA: String? {
        get { UserDefaults.standard.string(forKey: lastSHAKey) }
        set { UserDefaults.standard.set(newValue, forKey: lastSHAKey) }
    }

    func checkForUpdates() async -> UpdateResult {
        let url = KnownSources.aiEcosystem.apiCommitURL
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let sha = json["sha"] as? String {
                let currentSHA = storedSHA
                if currentSHA == nil {
                    storedSHA = sha
                    return .upToDate
                } else if sha != currentSHA {
                    storedSHA = sha
                    return .updatesAvailable(newSHA: sha)
                } else {
                    return .upToDate
                }
            }
        } catch {
            return .error(error.localizedDescription)
        }
        return .upToDate
    }
}

enum UpdateResult {
    case upToDate
    case updatesAvailable(newSHA: String)
    case error(String)
}
