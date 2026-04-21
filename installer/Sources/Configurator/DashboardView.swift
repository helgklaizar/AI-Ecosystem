import SwiftUI

struct DashboardView: View {
    let profile: UserProfile
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ecosystem Health")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Text("Welcome back, \(profile.name). Your \(profile.profession.displayName) environment is active.")
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(title: "Active Tools", value: "\(profile.aiTools.count)", icon: "cpu", color: Color(hex: "A855F7"))
                    StatCard(title: "Projects", value: "3", icon: "folder", color: Color(hex: "6366F1"))
                    StatCard(title: "Skills", value: "12", icon: "bolt.fill", color: Color(hex: "10B981"))
                }
                
                // Health Check Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Health Checks")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        HealthRow(title: "Global Directory (.gemini)", status: .ok, detail: "All core files intact")
                        HealthRow(title: "Workspace Rules", status: .ok, detail: "STRUCTURE.md is up to date")
                        HealthRow(title: "Project: TeleFeed", status: .warning, detail: "Missing DESIGN.md")
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 32)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                Spacer()
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.3), lineWidth: 1))
    }
}

enum HealthStatus {
    case ok, warning, error
    
    var color: Color {
        switch self {
        case .ok: return .green
        case .warning: return .yellow
        case .error: return .red
        }
    }
    
    var icon: String {
        switch self {
        case .ok: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}

struct HealthRow: View {
    let title: String
    let status: HealthStatus
    let detail: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: status.icon)
                .foregroundColor(status.color)
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                Text(detail)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
