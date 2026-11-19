import SwiftUI

struct AssignmentRowView: View {
    let assignment: Assignment

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(assignment.title).font(.headline)
                Spacer()
                StatusBadgeView(status: assignment.status)
            }
            Text(assignment.subject).font(.subheadline).foregroundStyle(.secondary)
            HStack {
                Label(assignment.dueDate.assignmentDate, systemImage: "calendar")
                Spacer()
                if assignment.isOverdue {
                    Text("Overdue").font(.caption.bold()).foregroundStyle(.red)
                }
            }
            .font(.caption)
        }
        .padding(.vertical, 4)
    }
}
