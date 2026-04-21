import SwiftUI

struct ProjectBootstrapperView: View {
    let profile: UserProfile
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "A855F7"))
            
            Text("Project Bootstrapper")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            Text("Quickly scaffold new AI projects with standardized directory structure, agents, and rules based on your profession (\(profile.profession.displayName)).")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
