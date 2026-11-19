import Foundation
import Combine
import SwiftData

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var isRegistering = false
    @Published var errorMessage: String?
    @Published var isWorking = false

    private var service: AuthenticationService?
    private let biometricService = BiometricService()

    func configure(context: ModelContext) {
        service = AuthenticationService(context: context)
    }

    func submit() {
        guard let service else { errorMessage = "Storage is not ready."; return }
        do {
            if isRegistering {
                try service.register(username: username, password: password)
            } else {
                try service.login(username: username, password: password)
            }
            isAuthenticated = true
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signInWithBiometrics() {
        isWorking = true
        Task {
            let result = await biometricService.authenticate()
            switch result {
            case .success:
                // Face ID is offered only after a local account has been registered.
                isAuthenticated = true
                errorMessage = nil
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            isWorking = false
        }
    }

    func signOut() {
        isAuthenticated = false
        password = ""
    }
}
