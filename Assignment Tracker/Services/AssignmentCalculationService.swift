import Foundation

struct AssignmentCalculationService {
    func summary(for assignments: [Assignment]) -> AssignmentSummary {
        AssignmentSummary.make(from: assignments)
    }

    func count(for status: AssignmentStatus, in assignments: [Assignment]) -> Int {
        assignments.filter { $0.status == status }.count
    }
}
I need tops the project in GitHub from initial and I also need to change the username and email in the keychain access
