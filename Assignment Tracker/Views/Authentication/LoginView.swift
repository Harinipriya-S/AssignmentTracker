import SwiftUI
import SwiftData

struct LoginView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)
                Text(AppConstants.appName).font(.largeTitle.bold())
                Text(viewModel.isRegistering ? "Create your local account" : "Welcome back")
                    .foregroundStyle(.secondary)

                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)
                SecureField("Password (minimum 8 characters)", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)

                if let error = viewModel.errorMessage {
                    Text(error).foregroundStyle(.red).font(.footnote)
                }

                Button(viewModel.isRegistering ? "Create account" : "Sign in") {
                    viewModel.configure(context: context)
                    viewModel.submit()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)

                Button(viewModel.isRegistering ? "I already have an account" : "Create an account") {
                    viewModel.isRegistering.toggle()
                    viewModel.errorMessage = nil
                }

                BiometricLoginView {
                    viewModel.signInWithBiometrics()
                }
                .disabled(viewModel.isWorking)
            }
            .padding(28)
        }
    }
}
