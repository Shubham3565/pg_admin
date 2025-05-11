import SwiftUI

struct OnboardingSuccessView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)

            Text("Setup Complete")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Your company and PG setup are now complete.\nCheck your email to set your password and log in to your dashboard.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)

            Spacer()

            NavigationLink(destination: WelcomeView()) {
                Text("Back to Home")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer().frame(height: 30)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        OnboardingSuccessView()
    }
}
