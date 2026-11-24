
import SwiftUI
import SwiftData

struct AssignmentDetailView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let assignment: Assignment
    let userID: String

    @State private var showEditSheet = false
    @State private var showDeleteAlert = false

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 28) {

                // Assignment Information
                VStack(alignment: .leading, spacing: 12) {

                    Text("Assignment Information")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    VStack(spacing: 0) {

                        detailRow(
                            title: "Title",
                            value: assignment.title
                        )

                        Divider()

                        detailRow(
                            title: "Subject",
                            value: assignment.subject
                        )

                        Divider()

                        detailRow(
                            title: "Faculty",
                            value: assignment.faculty
                        )

                        Divider()

                        detailRow(
                            title: "Due Date",
                            value: assignment.dueDate.formatted(
                                date: .abbreviated,
                                time: .omitted
                            )
                        )
                    }
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }

                // Submission Details
                VStack(alignment: .leading, spacing: 12) {

                    Text("Submission Details")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    VStack(spacing: 0) {

                        detailRow(
                            title: "Marks",
                            value: "\(assignment.marks)"
                        )

                        Divider()

                        HStack {
                            Text("Status")
                                .foregroundStyle(.primary)

                            Spacer()

                            Text(assignment.status.rawValue.capitalized)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 18)

                        Divider()

                        detailRow(
                            title: "Notes",
                            value: assignment.notes.isEmpty
                                ? "No notes added"
                                : assignment.notes
                        )
                    }
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }

                // Edit Assignment Button
                Button {
                    showEditSheet = true
                } label: {

                    HStack {
                        Image(systemName: "pencil")
                            .font(.title3)

                        Text("Edit Assignment")
                            .font(.headline)

                        Spacer()

                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.blue)
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }

                // Delete Assignment Button
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {

                    HStack {
                        Image(systemName: "trash")
                            .font(.title2)

                        Text("Delete Assignment")
                            .font(.headline)

                        Spacer()
                    }
                    .foregroundStyle(.red)
                    .padding(20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                }
            }
            .padding(20)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Assignment Details")
        .navigationBarTitleDisplayMode(.inline)

        // Edit Sheet
        .sheet(isPresented: $showEditSheet) {
            EditAssignmentView(
                assignment: assignment,
                userID: userID
            )
        }

        // Delete Confirmation
        .alert(
            "Delete Assignment?",
            isPresented: $showDeleteAlert
        ) {

            Button("Cancel", role: .cancel) { }

            Button("Delete", role: .destructive) {
                deleteAssignment()
            }

        } message: {
            Text("Are you sure you want to delete this assignment?")
        }
    }

    // Reusable detail row
    private func detailRow(
        title: String,
        value: String
    ) -> some View {

        HStack(alignment: .top) {

            Text(title)
                .foregroundStyle(.primary)

            Spacer()

            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 18)
    }

    // Delete assignment
    private func deleteAssignment() {

        guard assignment.userID == userID else {
            return
        }

        context.delete(assignment)

        do {
            try context.save()
            dismiss()
        } catch {
            print("Unable to delete assignment: \(error)")
        }
    }
}
