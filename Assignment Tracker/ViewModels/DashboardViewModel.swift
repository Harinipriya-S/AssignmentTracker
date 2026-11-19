import Foundation
import Combine
import SwiftData

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published private(set) var assignments: [Assignment] = []
    private var storage: AssignmentStorageService?

    var summary: AssignmentSummary {
        AssignmentSummary.make(from: assignments)
    }

    func load(context: ModelContext) {
        storage = AssignmentStorageService(context: context)
        assignments = storage?.assignments() ?? []
    }

    func refresh() {
        assignments = storage?.assignments() ?? []
    }
}
