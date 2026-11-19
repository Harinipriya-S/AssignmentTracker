import SwiftUI
import SwiftData

struct EditAssignmentView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditAssignmentViewModel

    let assignment: Assignment
    let userID: String

    init(assignment: Assignment, userID: String) {
        self.assignment = assignment
        self.userID = userID
        _viewModel = StateObject(wrappedValue: EditAssignmentViewModel(assignment: assignment))
    }

    var body: some View {
        NavigationStack {
            AssignmentFormView(
                title: $viewModel.title,
                subject: $viewModel.subject,
                faculty: $viewModel.faculty,
                dueDate: $viewModel.dueDate,
                marks: $viewModel.marks,
                notes: $viewModel.notes,
                status: $viewModel.status,
                errorMessage: viewModel.errorMessage
            )
            .navigationTitle("Edit Assignment")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.save(
                            assignment: assignment,
                            context: context,
                            userID: userID
                        ) {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
