import SwiftUI

struct UpcomingAssignmentCard: View {
    let assignment: Assignment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(assignment.title).font(.headline)
            Text(assignment.subject).foregroundStyle(.secondary)
            Label(assignment.dueDate.assignmentDate, systemImage: "calendar")
                .font(.subheadline)
            StatusBadgeView(status: assignment.status)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
    }
}
