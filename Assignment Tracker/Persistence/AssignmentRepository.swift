import Foundation
import SwiftData

@MainActor
final class AssignmentRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func add(_ assignment: Assignment) throws {
        context.insert(assignment)
        try context.save()
    }

    func delete(_ assignment: Assignment) throws {
        context.delete(assignment)
        try context.save()
    }

    func saveChanges() throws {
        try context.save()
    }

    func allAssignments() throws -> [Assignment] {
        try context.fetch(FetchDescriptor<Assignment>(
            sortBy: [SortDescriptor(\.dueDate, order: .forward)]
        ))
    }
}
