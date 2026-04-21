import SwiftUI

struct TimeMachineView: View {
    let profile: UserProfile
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 40))
                .foregroundColor(Color(hex: "A855F7"))
            
            Text("Time Machine")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            Text("Browse and rollback to previous snapshots of your agent configurations.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
