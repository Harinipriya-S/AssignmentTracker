import Foundation
import Combine
import SwiftData

@MainActor
final class AssignmentListViewModel: ObservableObject {
    @Published private(set) var assignments: [Assignment] = []
    @Published var selectedStatus: AssignmentStatus?

    private var storage: AssignmentStorageService?

    var visibleAssignments: [Assignment] {
        guard let selectedStatus else { return assignments }
        return assignments.filter { $0.status == selectedStatus }
    }

    func load(context: ModelContext) {
        storage = AssignmentStorageService(context: context)
        refresh()
    }

    func refresh() { assignments = storage?.assignments() ?? [] }

    func delete(_ assignment: Assignment) {
        do { try storage?.delete(assignment); refresh() }
        catch { print("Delete failed: \(error)") }
    }
}
