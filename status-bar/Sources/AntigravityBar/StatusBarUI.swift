import AppKit

struct StatusBarUI {
    
    static func makeTimerCircle(secondsLeft: Double, size: CGFloat = 14) -> NSImage {
        let maxCycle: Double = 5400 // 90 min cycle
        let elapsed = max(0, min(1, 1.0 - secondsLeft / maxCycle))

        let img = NSImage(size: NSSize(width: size, height: size), flipped: false) { rect in
            let center = NSPoint(x: rect.midX, y: rect.midY)
            let radius = (size - 2) / 2

            let bgPath = NSBezierPath(ovalIn: rect.insetBy(dx: 1, dy: 1))
            NSColor.white.withAlphaComponent(0.35).setFill()
            bgPath.fill()
            NSColor.white.withAlphaComponent(0.6).setStroke()
            bgPath.lineWidth = 0.75
            bgPath.stroke()

            if elapsed > 0.01 {
                let startAngle: CGFloat = 90
                let endAngle = startAngle - CGFloat(elapsed * 360)

                let piePath = NSBezierPath()
                piePath.move(to: center)
                piePath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                piePath.close()
                NSColor.white.withAlphaComponent(0.85).setFill()
                piePath.fill()
            }
            return true
        }
        img.isTemplate = false
        return img
    }

    static func makeBarTitle(models: [ModelQuota], daemonOnline: Bool, cacheFormatted: String, cacheMB: Double) -> NSAttributedString {
        let result = NSMutableAttributedString()
        let pctFont = NSFont.monospacedSystemFont(ofSize: 13, weight: .bold)
        let sepFont = NSFont.systemFont(ofSize: 11, weight: .regular)

        let cacheColor = colorForCacheMB(cacheMB)
        let cacheStr = NSAttributedString(string: cacheFormatted, attributes: [
            .font: pctFont, .foregroundColor: cacheColor
        ])
        result.append(cacheStr)

        if models.isEmpty {
            if !daemonOnline {
                let offStr = NSAttributedString(string: "  |  OFF", attributes: [
                    .font: pctFont, .foregroundColor: NSColor.tertiaryLabelColor
                ])
                result.append(offStr)
            }
        } else {
            let grouped = groupModels(models)
            for g in grouped {
                let color = colorForPercentage(g.pct)

                let sep = NSAttributedString(string: "  |  ", attributes: [
                    .font: sepFont, .foregroundColor: NSColor.tertiaryLabelColor
                ])
                result.append(sep)

                let circleImg = makeTimerCircle(secondsLeft: g.secsLeft)
                let attachment = NSTextAttachment()
                attachment.image = circleImg
                attachment.bounds = CGRect(x: 0, y: -1, width: 14, height: 14)
                result.append(NSAttributedString(attachment: attachment))
                result.append(NSAttributedString(string: " ", attributes: [.font: sepFont]))

                let pctStr = NSAttributedString(string: "\(g.pct)%", attributes: [
                    .font: pctFont, .foregroundColor: color
                ])
                result.append(pctStr)
            }
        }

        return result
    }

    static func groupModels(_ models: [ModelQuota]) -> [(name: String, pct: Int, secsLeft: Double)] {
        struct Group {
            let name: String
            let keywords: [String]
        }
        let groups = [
            Group(name: "Flash", keywords: ["flash"]),
            Group(name: "Pro", keywords: ["pro"]),
            Group(name: "Claude", keywords: ["claude", "sonnet", "opus"]),
            Group(name: "O1", keywords: ["o1", "o3"]),
            Group(name: "Gemma", keywords: ["gemma"])
        ]

        var result: [(name: String, pct: Int, secsLeft: Double)] = []
        for group in groups {
            let matching = models.filter { m in
                let l = m.label.lowercased()
                return group.keywords.contains(where: { l.contains($0) })
            }
            if !matching.isEmpty {
                let minPct = Int(matching.map(\.remainingPercentage).min() ?? 0)
                let minSecs = matching.map(\.secondsUntilReset).min() ?? 0
                result.append((name: group.name, pct: minPct, secsLeft: minSecs))
            }
        }
        return result
    }

    static func colorForPercentage(_ pct: Int) -> NSColor {
        if pct > 70 { return NSColor.systemGreen }
        if pct > 40 { return NSColor.systemYellow }
        if pct > 15 { return NSColor.systemOrange }
        return NSColor.systemRed
    }

    static func colorForCacheMB(_ mb: Double) -> NSColor {
        if mb < 100 { return NSColor.systemGreen }
        if mb < 300 { return NSColor.systemYellow }
        if mb < 500 { return NSColor.systemOrange }
        return NSColor.systemRed
    }
}
