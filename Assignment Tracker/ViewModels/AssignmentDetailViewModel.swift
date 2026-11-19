
import Foundation
import Combine
import SwiftData

@MainActor
final class AssignmentDetailViewModel: ObservableObject {

    @Published var assignment: Assignment?
    @Published var errorMessage: String?

    private var storage: AssignmentStorageService?

    func load(
        assignment: Assignment,
        context: ModelContext,
        userID: String
    ) {
        guard assignment.userID == userID else {
            errorMessage = "You cannot access this assignment."
            self.assignment = nil
            return
        }

        storage = AssignmentStorageService(
            context: context,
            userID: userID
        )

        self.assignment = assignment
        errorMessage = nil
    }

    func saveChanges() {
        guard let assignment else {
            return
        }

        do {
            try storage?.save(assignment)
            errorMessage = nil
        } catch {
            errorMessage = "Unable to save assignment: \(error.localizedDescription)"
        }
    }

    func deleteAssignment() {
        guard let assignment else {
            return
        }

        do {
            try storage?.delete(assignment)
            self.assignment = nil
            errorMessage = nil
        } catch {
            errorMessage = "Unable to delete assignment: \(error.localizedDescription)"
        }
    }
}
