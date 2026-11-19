import Foundation
import SwiftData

@Model
final class Assignment {
    var title: String
    var subject: String
    var faculty: String
    var dueDate: Date
    var marks: Int
    var notes: String
    var statusRawValue: String
    var createdAt: Date

    init(title: String, subject: String, faculty: String, dueDate: Date,
         marks: Int = 0, notes: String = "",
         status: AssignmentStatus = .pending, createdAt: Date = .now) {
        self.title = title
        self.subject = subject
        self.faculty = faculty
        self.dueDate = dueDate
        self.marks = marks
        self.notes = notes
        self.statusRawValue = status.rawValue
        self.createdAt = createdAt
    }

    var status: AssignmentStatus {
        get { AssignmentStatus(rawValue: statusRawValue) ?? .pending }
        set { statusRawValue = newValue.rawValue }
    }

    var isOverdue: Bool {
        status != .submitted && dueDate < .now
    }
}
