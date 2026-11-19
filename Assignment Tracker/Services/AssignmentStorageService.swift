import Foundation
import SwiftData

@MainActor
final class AssignmentStorageService {
    private let repository: AssignmentRepository

    init(context: ModelContext) {
        repository = AssignmentRepository(context: context)
    }

    func assignments() -> [Assignment] {
        (try? repository.allAssignments()) ?? []
    }

    func add(_ assignment: Assignment) throws { try repository.add(assignment) }
    func delete(_ assignment: Assignment) throws { try repository.delete(assignment) }
    func save() throws { try repository.saveChanges() }
}
