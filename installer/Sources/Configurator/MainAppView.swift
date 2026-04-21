import SwiftUI

enum MainTab: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case bootstrapper = "New Project"
    case skills = "Skill Manager"
    case timeMachine = "Time Machine"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .bootstrapper: return "wand.and.stars"
        case .skills: return "slider.horizontal.3"
        case .timeMachine: return "clock.arrow.circlepath"
        }
    }
}

struct MainAppView: View {
    let profile: UserProfile
    @State private var selectedTab: MainTab? = .dashboard
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                Section("Ecosystem") {
                    ForEach(MainTab.allCases) { tab in
                        NavigationLink(value: tab) {
                            Label(tab.rawValue, systemImage: tab.icon)
                        }
                    }
                }
            }
            .navigationTitle("Configurator")
            .listStyle(.sidebar)
            .frame(minWidth: 200)
        } detail: {
            ZStack {
                Color(hex: "0A0A0F").ignoresSafeArea()
                
                if let selectedTab {
                    switch selectedTab {
                    case .dashboard:
                        DashboardView(profile: profile)
                    case .bootstrapper:
                        ProjectBootstrapperView(profile: profile)
                    case .skills:
                        SkillManagerView(profile: profile)
                    case .timeMachine:
                        TimeMachineView(profile: profile)
                    }
                } else {
                    Text("Select a section from the sidebar")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
