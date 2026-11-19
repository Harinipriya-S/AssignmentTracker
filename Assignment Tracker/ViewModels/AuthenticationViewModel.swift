import Foundation
import Combine
import SwiftData

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var currentUser: User?
    @Published var isRegistering = false
    @Published var errorMessage: String?
    @Published var isWorking = false

    private var service: AuthenticationService?
    private let biometricService = BiometricService()

    var isAuthenticated: Bool { currentUser != nil }

    func configure(context: ModelContext) {
        service = AuthenticationService(context: context)
    }

    func submit() {
        guard let service else {
            errorMessage = "Storage is not ready."
            return
        }

        do {
            let user: User
            if isRegistering {
                user = try service.register(username: username, password: password)
            } else {
                user = try service.login(username: username, password: password)
            }
            currentUser = user
            password = ""
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signInWithBiometrics() {
        guard let service else {
            errorMessage = "Storage is not ready."
            return
        }

        isWorking = true
        Task {
            let result = await biometricService.authenticate()
            switch result {
            case .success:
                do {
                    guard let user = try service.lastBiometricUser() else {
                        errorMessage = "Sign in with your username and password once before using Face ID."
                        isWorking = false
                        return
                    }
                    currentUser = user
                    errorMessage = nil
                } catch {
                    errorMessage = error.localizedDescription
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            isWorking = false
        }
    }

    func signOut() {
        currentUser = nil
        username = ""
        password = ""
        isRegistering = false
        errorMessage = nil
    }
}
