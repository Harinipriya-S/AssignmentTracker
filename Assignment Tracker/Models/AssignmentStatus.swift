import Foundation

enum AssignmentStatus: String, CaseIterable, Identifiable, Codable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case submitted = "Submitted"

    var id: String { rawValue }

    var displayName: String { rawValue }
}
