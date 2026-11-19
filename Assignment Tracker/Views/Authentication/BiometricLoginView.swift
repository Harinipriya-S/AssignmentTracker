import SwiftUI

struct BiometricLoginView: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Sign in with Face ID", systemImage: "faceid")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
    }
}
