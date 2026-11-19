import Foundation
import SwiftData
import CryptoKit

@MainActor
final class AuthenticationService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func register(username: String, password: String) throws {
        let cleanName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { throw AuthError.emptyUsername }
        guard password.count >= AppConstants.minimumPasswordLength else { throw AuthError.weakPassword }

        let users = try context.fetch(FetchDescriptor<User>())
        guard !users.contains(where: { $0.username.caseInsensitiveCompare(cleanName) == .orderedSame }) else {
            throw AuthError.userAlreadyExists
        }
        context.insert(User(username: cleanName, passwordHash: Self.hash(password)))
        try context.save()
    }

    func login(username: String, password: String) throws {
        let users = try context.fetch(FetchDescriptor<User>())
        guard let user = users.first(where: {
            $0.username.caseInsensitiveCompare(username.trimmingCharacters(in: .whitespacesAndNewlines)) == .orderedSame
        }), user.passwordHash == Self.hash(password) else {
            throw AuthError.invalidCredentials
        }
    }

    private static func hash(_ value: String) -> String {
        SHA256.hash(data: Data(value.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}

enum AuthError: LocalizedError {
    case emptyUsername, weakPassword, userAlreadyExists, invalidCredentials

    var errorDescription: String? {
        switch self {
        case .emptyUsername: return "Enter a username."
        case .weakPassword: return "Password must contain at least \(AppConstants.minimumPasswordLength) characters."
        case .userAlreadyExists: return "That username is already registered."
        case .invalidCredentials: return "Username or password is incorrect."
        }
    }
}
