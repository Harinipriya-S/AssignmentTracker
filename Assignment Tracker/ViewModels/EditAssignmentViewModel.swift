import Foundation
import Combine
import SwiftData

@MainActor
final class EditAssignmentViewModel: ObservableObject {
    @Published var title: String
    @Published var subject: String
    @Published var faculty: String
    @Published var dueDate: Date
    @Published var marks: Int
    @Published var notes: String
    @Published var status: AssignmentStatus
    @Published var errorMessage: String?

    init(assignment: Assignment) {
        title = assignment.title
        subject = assignment.subject
        faculty = assignment.faculty
        dueDate = assignment.dueDate
        marks = assignment.marks
        notes = assignment.notes
        status = assignment.status
    }

    func save(assignment: Assignment, context: ModelContext, userID: String) -> Bool {
        guard assignment.userID == userID else {
            errorMessage = "You cannot edit another user's assignment."
            return false
        }
        guard FormValidator.isValid(title: title, faculty: faculty, marks: marks) else {
            errorMessage = "Enter a title and faculty name. Marks must be between 0 and 100."
            return false
        }

        assignment.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        assignment.subject = subject
        assignment.faculty = faculty.trimmingCharacters(in: .whitespacesAndNewlines)
        assignment.dueDate = dueDate
        assignment.marks = marks
        assignment.notes = notes
        assignment.status = status

        do {
            try AssignmentStorageService(context: context, userID: userID).save(assignment)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
