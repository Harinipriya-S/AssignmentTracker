import Foundation

struct AssignmentSummary {
    let total: Int
    let pending: Int
    let submitted: Int
    let nextDue: Assignment?

    static func make(from assignments: [Assignment]) -> AssignmentSummary {
        AssignmentSummary(
            total: assignments.count,
            pending: assignments.filter { $0.status != .submitted }.count,
            submitted: assignments.filter { $0.status == .submitted }.count,
            nextDue: assignments
                .filter { $0.status != .submitted && $0.dueDate >= Calendar.current.startOfDay(for: .now) }
                .sorted { $0.dueDate < $1.dueDate }
                .first
        )
    }
}
