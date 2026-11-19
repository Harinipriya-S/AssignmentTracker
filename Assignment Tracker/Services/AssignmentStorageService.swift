
import Foundation
import SwiftData

enum AssignmentStorageError: Error {
    case notOwner
}

@MainActor
final class AssignmentStorageService {

    private let repository: AssignmentRepository
    let userID: String

    init(context: ModelContext, userID: String) {
        self.userID = userID
        repository = AssignmentRepository(context: context)
    }

    func assignments() -> [Assignment] {
        let allAssignments = (try? repository.allAssignments()) ?? []

        return allAssignments.filter {
            $0.userID == userID
        }
    }

    func add(_ assignment: Assignment) throws {
        guard assignment.userID == userID else {
            throw AssignmentStorageError.notOwner
        }

        try repository.add(assignment)
    }

    func delete(_ assignment: Assignment) throws {
        guard assignment.userID == userID else {
            throw AssignmentStorageError.notOwner
        }

        try repository.delete(assignment)
    }

    func save(_ assignment: Assignment) throws {
        guard assignment.userID == userID else {
            throw AssignmentStorageError.notOwner
        }

        try repository.saveChanges()
    }
}
