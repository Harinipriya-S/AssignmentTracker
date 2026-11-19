import SwiftUI
import SwiftData

struct AddAssignmentView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddAssignmentViewModel()
    var onSave: () -> Void = {}

    var body: some View {
        NavigationStack {
            AssignmentFormView(
                title: $viewModel.title, subject: $viewModel.subject,
                faculty: $viewModel.faculty, dueDate: $viewModel.dueDate,
                marks: $viewModel.marks, notes: $viewModel.notes,
                status: $viewModel.status, errorMessage: viewModel.errorMessage
            )
            .navigationTitle("New Assignment")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.save(context: context) { onSave(); dismiss() }
                    }
                }
            }
        }
    }
}
