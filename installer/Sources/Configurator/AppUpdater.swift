import Foundation
import AppKit

// MARK: - App Updater
// Checks GitHub Releases for new versions of the Configurator installer app itself.

struct AppRelease {
    let version: String        // e.g. "1.2.0"
    let releaseNotes: String
    let downloadURL: URL
    let publishedAt: String
}

enum AppUpdateResult {
    case upToDate(current: String)
    case updateAvailable(release: AppRelease)
    case error(String)
}

class AppUpdater {
    static let shared = AppUpdater()

    // Current version — bump this on each release
    static let currentVersion = "1.0.0"

    // GitHub repo where releases are published
    private let releasesAPIURL = URL(string: "https://api.github.com/repos/helgklaizar/AI-Ecosystem/releases/latest")!

    private let lastCheckedKey = "appUpdater_lastChecked"
    private let checkIntervalSeconds: TimeInterval = 60 * 60 * 6 // every 6 hours

    var shouldCheck: Bool {
        guard let last = UserDefaults.standard.object(forKey: lastCheckedKey) as? Date else { return true }
        return Date().timeIntervalSince(last) > checkIntervalSeconds
    }

    // MARK: - Check for App Update

    func checkForUpdate() async -> AppUpdateResult {
        UserDefaults.standard.set(Date(), forKey: lastCheckedKey)

        var request = URLRequest(url: releasesAPIURL)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("Configurator/\(AppUpdater.currentVersion)", forHTTPHeaderField: "User-Agent")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return .error("GitHub API returned \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            }

            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return .error("Failed to parse release JSON")
            }

            guard let tagName = json["tag_name"] as? String else {
                return .upToDate(current: AppUpdater.currentVersion)
            }

            // Strip leading 'v' from tag if present
            let latestVersion = tagName.hasPrefix("v") ? String(tagName.dropFirst()) : tagName

            if isNewerVersion(latestVersion, than: AppUpdater.currentVersion) {
                let notes = (json["body"] as? String) ?? "No release notes."
                let publishedAt = (json["published_at"] as? String) ?? ""

                // Find macOS .dmg or .zip asset
                let assets = (json["assets"] as? [[String: Any]]) ?? []
                let downloadURL: URL

                if let asset = assets.first(where: {
                    let name = ($0["name"] as? String) ?? ""
                    return name.hasSuffix(".dmg") || name.hasSuffix(".zip")
                }), let urlStr = asset["browser_download_url"] as? String, let url = URL(string: urlStr) {
                    downloadURL = url
                } else if let htmlURL = json["html_url"] as? String, let url = URL(string: htmlURL) {
                    downloadURL = url
                } else {
                    return .upToDate(current: AppUpdater.currentVersion)
                }

                return .updateAvailable(release: AppRelease(
                    version: latestVersion,
                    releaseNotes: notes,
                    downloadURL: downloadURL,
                    publishedAt: publishedAt
                ))
            } else {
                return .upToDate(current: AppUpdater.currentVersion)
            }

        } catch {
            return .error(error.localizedDescription)
        }
    }

    // MARK: - Download & Open

    func downloadAndInstall(release: AppRelease) async -> String {
        let url = release.downloadURL

        // If it's a GitHub releases page (not direct download), just open in browser
        if url.pathExtension != "dmg" && url.pathExtension != "zip" {
            await MainActor.run {
                NSWorkspace.shared.open(url)
            }
            return "🌐 Открываю страницу релиза в браузере..."
        }

        // Download the file
        let fileName = url.lastPathComponent
        let destURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)

        do {
            let (tempURL, _) = try await URLSession.shared.download(from: url)
            try? FileManager.default.removeItem(at: destURL)
            try FileManager.default.moveItem(at: tempURL, to: destURL)

            // Open the downloaded file
            await MainActor.run {
                NSWorkspace.shared.open(destURL)
            }

            return "✅ Скачано: \(fileName)\nФайл открыт в Finder. Установи и перезапусти приложение."
        } catch {
            return "❌ Ошибка загрузки: \(error.localizedDescription)"
        }
    }

    // MARK: - Version Comparison

    private func isNewerVersion(_ latest: String, than current: String) -> Bool {
        let latestParts = latest.split(separator: ".").compactMap { Int($0) }
        let currentParts = current.split(separator: ".").compactMap { Int($0) }

        let maxLen = max(latestParts.count, currentParts.count)
        for i in 0..<maxLen {
            let l = i < latestParts.count ? latestParts[i] : 0
            let c = i < currentParts.count ? currentParts[i] : 0
            if l > c { return true }
            if l < c { return false }
        }
        return false
    }
}
