import Foundation
import AppKit
import Darwin

// MARK: - Daemon Discovery

struct DaemonInfo: Codable {
    let pid: Int
    let httpsPort: Int
    let httpPort: Int
    let csrfToken: String
}

struct ModelQuota {
    let label: String
    let remainingPercentage: Double  // 0..100
    let isExhausted: Bool
    let timeUntilReset: String
    let secondsUntilReset: Double
}

struct QuotaData {
    let models: [ModelQuota]
    let timestamp: Date
}

struct CascadeUserStatus: Decodable {
    let userStatus: UserStatusContainer
}

struct UserStatusContainer: Decodable {
    let cascadeModelConfigData: CascadeModelConfigData
}

struct CascadeModelConfigData: Decodable {
    let clientModelConfigs: [ClientModelConfig]
}

struct ClientModelConfig: Decodable {
    let label: String?
    let quotaInfo: QuotaInfo?
}

struct QuotaInfo: Decodable {
    let remainingFraction: Double?
    let resetTime: String?
}

// MARK: - API

class AntigravityAPI: @unchecked Sendable {
    @MainActor static let shared = AntigravityAPI()
    
    let env: SystemEnvironment
    
    init(env: SystemEnvironment = DefaultSystemEnvironment()) {
        self.env = env
    }

    private let brainDir = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(".gemini/antigravity/brain")
    private let conversationsDir = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(".gemini/antigravity/conversations")
    private let browserRecDir = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(".gemini/antigravity/browser_recordings")
    private let htmlArtsDir = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(".gemini/antigravity/html_artifacts")
    private let knowledgeDir = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(".gemini/antigravity/knowledge")
    private let skillsDir = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(".gemini/antigravity/skills")
    private let workflowsDir = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(".gemini/antigravity/global_workflows")

    // MARK: - Daemon Discovery (process-based + JSON fallback)

    func findActiveDaemon() -> DaemonInfo? {
        // Primary: find running language_server process and extract info
        if let info = findDaemonFromProcess() {
            return info
        }
        return nil
    }

    private struct LSProcessInfo {
        let pid: Int
        let csrfToken: String
        let extPort: Int?
    }

    /// Parse running language_server process args natively to get csrf_token and extension_server_port,
    /// then validate HTTP on (extPort+0, extPort+1, extPort+2)
    private func findDaemonFromProcess() -> DaemonInfo? {
        let psInfo = findLanguageServerProcesses()
        guard !psInfo.isEmpty else { return nil }

        for info in psInfo {
            // We expect the HTTP port to be either the extension port itself, or +1, or +2
            let basePorts: [Int]
            if let ePort = info.extPort {
                basePorts = [ePort + 2, ePort + 1, ePort]
            } else {
                continue
            }

            for port in basePorts {
                if isHTTPReachable(port: port, csrfToken: info.csrfToken) {
                    return DaemonInfo(
                        pid: info.pid,
                        httpsPort: 0,
                        httpPort: port,
                        csrfToken: info.csrfToken
                    )
                }
            }
        }
        return nil
    }

    /// Find all language_server_macos processes and extract PID + csrf_token natively
    private func findLanguageServerProcesses() -> [LSProcessInfo] {
        var results: [LSProcessInfo] = []
        let maxPids = 2048
        var pids = [pid_t](repeating: 0, count: maxPids)
        let returnedBytes = proc_listpids(UInt32(PROC_ALL_PIDS), 0, &pids, Int32(maxPids * MemoryLayout<pid_t>.stride))
        let numPids = Int(returnedBytes) / MemoryLayout<pid_t>.stride
        
        for i in 0..<numPids {
            let pid = pids[i]
            if pid <= 0 { continue }
            
            var pathBuffer = [CChar](repeating: 0, count: Int(MAXPATHLEN))
            let pathLen = proc_pidpath(pid, &pathBuffer, UInt32(pathBuffer.count))
            if pathLen > 0 {
                let path = String(cString: pathBuffer)
                if path.contains("language_server_macos") {
                    var mib: [Int32] = [CTL_KERN, KERN_PROCARGS2, pid]
                    var size: Int = 0
                    sysctl(&mib, UInt32(mib.count), nil, &size, nil, 0)
                    if size > 0 {
                        var buffer = [CChar](repeating: 0, count: size)
                        if sysctl(&mib, UInt32(mib.count), &buffer, &size, nil, 0) == 0 {
                            let argc = buffer.withUnsafeBufferPointer { ptr -> Int32 in
                                ptr.baseAddress!.withMemoryRebound(to: Int32.self, capacity: 1) { $0.pointee }
                            }
                            var offset = MemoryLayout<Int32>.size
                            while offset < buffer.count && buffer[offset] != 0 { offset += 1 }
                            while offset < buffer.count && buffer[offset] == 0 { offset += 1 }
                            
                            var args = [String]()
                            for _ in 0..<argc {
                                let argStart = offset
                                while offset < buffer.count && buffer[offset] != 0 { offset += 1 }
                                args.append(String(cString: Array(buffer[argStart...offset])))
                                offset += 1
                            }
                            
                            var port: Int? = nil
                            if let tokenIdx = args.firstIndex(of: "--csrf_token"), tokenIdx + 1 < args.count {
                                if let extIdx = args.firstIndex(of: "--extension_server_port"), extIdx + 1 < args.count {
                                    port = Int(args[extIdx + 1])
                                }
                                results.append(LSProcessInfo(pid: Int(pid), csrfToken: args[tokenIdx + 1], extPort: port))
                            }
                        }
                    }
                }
            }
        }
        return results
    }



    /// Lightweight HTTP check — send minimal request, expect any response
    private func isHTTPReachable(port: Int, csrfToken: String) -> Bool {
        let url = URL(string: "http://127.0.0.1:\(port)/exa.language_server_pb.LanguageServerService/GetUserStatus")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("1", forHTTPHeaderField: "Connect-Protocol-Version")
        request.setValue(csrfToken, forHTTPHeaderField: "X-Codeium-Csrf-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 2
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["metadata": ["ideName": "antigravity"]])

        let semaphore = DispatchSemaphore(value: 0)
        final class ReachableStatus: @unchecked Sendable { var ok = false }
        let status = ReachableStatus()
        
        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                status.ok = true
            }
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return status.ok
    }    // Fetch quota using Connect/Protobuf JSON over HTTP
    func fetchQuota(daemon: DaemonInfo, completion: @Sendable @escaping (QuotaData?) -> Void) {
        let url = URL(string: "http://127.0.0.1:\(daemon.httpPort)/exa.language_server_pb.LanguageServerService/GetUserStatus")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("1", forHTTPHeaderField: "Connect-Protocol-Version")
        request.setValue(daemon.csrfToken, forHTTPHeaderField: "X-Codeium-Csrf-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 5

        let body = ["metadata": ["ideName": "antigravity", "extensionName": "antigravity", "locale": "en"]]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let parsed = try? JSONDecoder().decode(CascadeUserStatus.self, from: data)
            else {
                completion(nil)
                return
            }
            completion(self.parseQuota(parsed))
        }.resume()
    }

    func parseQuota(_ parsed: CascadeUserStatus) -> QuotaData? {
        let configs = parsed.userStatus.cascadeModelConfigData.clientModelConfigs

        let models: [ModelQuota] = configs.compactMap { config in
            guard let quotaInfo = config.quotaInfo,
                  let label = config.label
            else { return nil }

            let remainingFraction = quotaInfo.remainingFraction ?? 0.0
            let resetTimeStr = quotaInfo.resetTime ?? ""
            let resetDate = ISO8601DateFormatter().date(from: resetTimeStr) ?? Date()
            let secsLeft = max(0, resetDate.timeIntervalSinceNow)
            let timeStr = formatTime(Int(secsLeft * 1000))

            return ModelQuota(
                label: label,
                remainingPercentage: remainingFraction * 100,
                isExhausted: remainingFraction == 0,
                timeUntilReset: timeStr,
                secondsUntilReset: secsLeft
            )
        }

        return QuotaData(models: models, timestamp: Date())
    }

    func formatTime(_ ms: Int) -> String {
        if ms <= 0 { return "Ready" }
        let minutes = Int(ceil(Double(ms) / 60000))
        if minutes < 60 { return "\(minutes)m" }
        let hours = minutes / 60
        if hours >= 24 {
            let days = hours / 24
            let rem = hours % 24
            return "\(days)d \(rem)h"
        }
        return "\(hours)h \(minutes % 60)m"
    }

    // MARK: - Actions

    func clearCache() {
        let dirsToClear = [brainDir, conversationsDir, htmlArtsDir]
        for dir in dirsToClear {
            guard let contents = try? env.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: []) else { continue }
            for item in contents {
                let name = item.lastPathComponent
                if name == ".DS_Store" { continue }
                try? env.removeItem(at: item)
            }
        }
    }

    func clearBrain() {
        guard let contents = try? env.contentsOfDirectory(at: brainDir, includingPropertiesForKeys: nil, options: []) else { return }
        for item in contents {
            let name = item.lastPathComponent
            if name == ".DS_Store" { continue }
            try? env.removeItem(at: item)
        }
    }

    func clearRecordings() {
        let dirsToClear = [browserRecDir]
        for dir in dirsToClear {
            guard let contents = try? env.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: []) else { continue }
            for item in contents {
                let name = item.lastPathComponent
                if name == ".DS_Store" { continue }
                try? env.removeItem(at: item)
            }
        }
    }

    func openBrain() {
        NSWorkspace.shared.open(brainDir)
    }

    func openDirectory(_ url: URL) {
        NSWorkspace.shared.open(url)
    }

    func openKnowledge() { openDirectory(knowledgeDir) }
    func openSkills() { openDirectory(skillsDir) }
    func openWorkflows() { openDirectory(workflowsDir) }

    // MARK: - Brain size

    func brainSize() -> String {
        return formatDirSize(dirSize(brainDir))
    }

    func cacheSize() -> (formatted: String, megabytes: Double) {
        let total = dirSize(brainDir) + dirSize(conversationsDir) + dirSize(htmlArtsDir)
        return (formatDirSize(total), Double(total) / (1024 * 1024))
    }

    func recordingsSize() -> String {
        return formatDirSize(dirSize(browserRecDir))
    }

    private func dirSize(_ dir: URL) -> Int64 {
        guard let enumerator = env.enumerator(at: dir, includingPropertiesForKeys: [.fileSizeKey], options: [.skipsHiddenFiles]) else { return 0 }
        var total: Int64 = 0
        for case let fileURL as URL in enumerator {
            if let vals = try? fileURL.resourceValues(forKeys: [.fileSizeKey]) {
                total += Int64(vals.fileSize ?? 0)
            }
        }
        return total
    }

    private func formatDirSize(_ total: Int64) -> String {
        if total < 1024 { return "\(total) B" }
        if total < 1024*1024 { return String(format: "%.1f KB", Double(total)/1024) }
        return String(format: "%.1f MB", Double(total)/(1024*1024))
    }
}
