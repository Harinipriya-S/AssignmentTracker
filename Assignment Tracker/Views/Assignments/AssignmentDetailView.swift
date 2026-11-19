
import SwiftUI
import SwiftData

struct AssignmentDetailView: View {

    let selectedAssignment: Assignment
    let userID: String

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = AssignmentDetailViewModel()
    @State private var showEditView = false

    var body: some View {

        Group {

            if let assignment = viewModel.assignment {

                Form {

                    Section("Assignment Information") {

                        LabeledContent("Title") {
                            Text(assignment.title)
                        }

                        LabeledContent("Subject") {
                            Text(String(describing: assignment.subject))
                        }

                        LabeledContent("Faculty") {
                            Text(assignment.faculty)
                        }

                        LabeledContent("Due Date") {
                            Text(
                                assignment.dueDate.formatted(
                                    date: .abbreviated,
                                    time: .omitted
                                )
                            )
                        }
                    }

                    Section("Submission Details") {

                        LabeledContent("Marks") {
                            Text(String(describing: assignment.marks))
                        }

                        LabeledContent("Status") {
                            Text(String(describing: assignment.status))
                        }

                        LabeledContent("Notes") {
                            Text(
                                assignment.notes.isEmpty
                                ? "No notes added"
                                : assignment.notes
                            )
                        }
                    }

                    Section {

                        Button(role: .destructive) {

                            viewModel.deleteAssignment()
                            dismiss()

                        } label: {

                            Label(
                                "Delete Assignment",
                                systemImage: "trash"
                            )
                        }
                    }
                }
                .toolbar {

                    ToolbarItem(placement: .topBarTrailing) {

                        Button {

                            showEditView = true

                        } label: {

                            Text("Edit")
                                .fontWeight(.semibold)
                        }
                    }
                }
                .sheet(isPresented: $showEditView) {

                    EditAssignmentView(
                        assignment: assignment,
                        userID: userID
                    )
                }

            } else {

                ContentUnavailableView(
                    "Assignment Not Available",
                    systemImage: "doc.text.magnifyingglass",
                    description: Text(
                        viewModel.errorMessage ?? "Assignment not found."
                    )
                )
            }
        }
        .navigationTitle("Assignment Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            viewModel.load(
                assignment: selectedAssignment,
                context: context,
                userID: userID
            )
        }
    }
}
