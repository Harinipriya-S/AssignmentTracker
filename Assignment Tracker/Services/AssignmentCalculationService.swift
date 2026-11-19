import Foundation

struct AssignmentCalculationService {
    func summary(for assignments: [Assignment]) -> AssignmentSummary {
        AssignmentSummary.make(from: assignments)
    }

    func count(for status: AssignmentStatus, in assignments: [Assignment]) -> Int {
        assignments.filter { $0.status == status }.count
    }
}
