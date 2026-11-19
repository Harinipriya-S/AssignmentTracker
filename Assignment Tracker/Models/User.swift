import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var id: String
    @Attribute(.unique) var username: String
    var passwordHash: String
    var createdAt: Date

    init(id: String = UUID().uuidString,
         username: String,
         passwordHash: String,
         createdAt: Date = .now) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
        self.createdAt = createdAt
    }
}
