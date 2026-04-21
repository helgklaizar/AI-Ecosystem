import SwiftUI

struct SkillManagerView: View {
    let profile: UserProfile
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "A855F7"))
            
            Text("Skill Manager")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            Text("Enable or disable specific agent skills globally or for individual projects.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
