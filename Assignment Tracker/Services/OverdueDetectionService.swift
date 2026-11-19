import Foundation

struct OverdueDetectionService {
    func isOverdue(_ assignment: Assignment, now: Date = .now) -> Bool {
        assignment.status != .submitted &&
        assignment.dueDate < now
    }

    func overdueAssignments(in assignments: [Assignment]) -> [Assignment] {
        assignments.filter { isOverdue($0) }.sorted { $0.dueDate < $1.dueDate }
    }
}
