import Foundation
import Combine
import SwiftData

@MainActor
final class AssignmentDetailViewModel: ObservableObject {
    func updateStatus(_ status: AssignmentStatus, for assignment: Assignment, context: ModelContext) {
        assignment.status = status
        do { try context.save() } catch { print("Unable to update status: \(error)") }
    }
}
