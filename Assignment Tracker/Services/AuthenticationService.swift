import Foundation
import SwiftData
import CryptoKit

@MainActor
final class AuthenticationService {
    private let context: ModelContext
    private let lastUserDefaultsKey = "AssignmentTracker.lastBiometricUserID"

    init(context: ModelContext) {
        self.context = context
    }

    func register(username: String, password: String) throws -> User {
        let cleanName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { throw AuthError.emptyUsername }
        guard password.count >= AppConstants.minimumPasswordLength else {
            throw AuthError.weakPassword
        }

        let users = try context.fetch(FetchDescriptor<User>())
        guard !users.contains(where: {
            $0.username.caseInsensitiveCompare(cleanName) == .orderedSame
        }) else {
            throw AuthError.userAlreadyExists
        }

        let user = User(username: cleanName, passwordHash: Self.hash(password))
        context.insert(user)
        try context.save()
        UserDefaults.standard.set(user.id, forKey: lastUserDefaultsKey)
        return user
    }

    func login(username: String, password: String) throws -> User {
        let cleanName = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let users = try context.fetch(FetchDescriptor<User>())
        guard let user = users.first(where: {
            $0.username.caseInsensitiveCompare(cleanName) == .orderedSame
        }), user.passwordHash == Self.hash(password) else {
            throw AuthError.invalidCredentials
        }

        UserDefaults.standard.set(user.id, forKey: lastUserDefaultsKey)
        return user
    }

    func lastBiometricUser() throws -> User? {
        guard let savedID = UserDefaults.standard.string(forKey: lastUserDefaultsKey) else {
            return nil
        }
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.id == savedID }
        )
        return try context.fetch(descriptor).first
    }

    private static func hash(_ value: String) -> String {
        SHA256.hash(data: Data(value.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
    }
}

enum AuthError: LocalizedError {
    case emptyUsername
    case weakPassword
    case userAlreadyExists
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Enter a username."
        case .weakPassword:
            return "Password must contain at least \(AppConstants.minimumPasswordLength) characters."
        case .userAlreadyExists:
            return "That username is already registered."
        case .invalidCredentials:
            return "Username or password is incorrect."
        }
    }
}
