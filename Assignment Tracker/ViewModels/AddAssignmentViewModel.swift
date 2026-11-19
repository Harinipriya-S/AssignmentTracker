import Foundation
import Combine
import SwiftData

@MainActor
final class AddAssignmentViewModel: ObservableObject {
    @Published var title = ""
    @Published var subject = Subject.other.rawValue
    @Published var faculty = ""
    @Published var dueDate = Date.now
    @Published var marks = 0
    @Published var notes = ""
    @Published var status = AssignmentStatus.pending
    @Published var errorMessage: String?

    func save(context: ModelContext, userID: String) -> Bool {
        guard FormValidator.isValid(title: title, faculty: faculty, marks: marks) else {
            errorMessage = "Enter a title and faculty name. Marks must be between 0 and 100."
            return false
        }

        do {
            let assignment = Assignment(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                subject: subject,
                faculty: faculty.trimmingCharacters(in: .whitespacesAndNewlines),
                dueDate: dueDate,
                marks: marks,
                notes: notes,
                status: status,
                userID: userID
            )
            try AssignmentStorageService(context: context, userID: userID).add(assignment)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
