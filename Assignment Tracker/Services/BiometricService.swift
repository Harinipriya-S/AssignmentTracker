import Foundation
import LocalAuthentication

final class BiometricService {
    func authenticate(reason: String = "Sign in to Assignment Tracker") async -> Result<Void, Error> {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .failure(error ?? BiometricError.unavailable)
        }

        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            return success ? .success(()) : .failure(BiometricError.failed)
        } catch {
            return .failure(error)
        }
    }
}

enum BiometricError: LocalizedError {
    case unavailable
    case failed

    var errorDescription: String? {
        switch self {
        case .unavailable: return "Biometric authentication is not available on this device."
        case .failed: return "Biometric authentication failed."
        }
    }
}

