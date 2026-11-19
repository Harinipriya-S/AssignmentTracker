import SwiftUI
import SwiftData

struct AssignmentDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AssignmentDetailViewModel()
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    let assignment: Assignment

    var body: some View {
        Form {
            Section("Assignment") {
                LabeledContent("Title", value: assignment.title)
                LabeledContent("Subject", value: assignment.subject)
                LabeledContent("Faculty", value: assignment.faculty)
                LabeledContent("Due date", value: assignment.dueDate.assignmentDateTime)
                LabeledContent("Marks", value: "\(assignment.marks)")
                LabeledContent("Status") {
                    Picker("Status", selection: Binding(
                        get: { assignment.status },
                        set: { viewModel.updateStatus($0, for: assignment, context: context) }
                    )) {
                        ForEach(AssignmentStatus.allCases) { Text($0.rawValue).tag($0) }
                    }
                }
                if !assignment.notes.isEmpty { Text(assignment.notes) }
                if assignment.isOverdue { Label("This assignment is overdue", systemImage: "exclamationmark.triangle").foregroundStyle(.red) }
            }
        }
        .navigationTitle("Details")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Edit", systemImage: "pencil") { showingEdit = true }
                    Button("Delete", systemImage: "trash", role: .destructive) { showingDeleteAlert = true }
                } label: { Image(systemName: "ellipsis") }
            }
        }
        .sheet(isPresented: $showingEdit) { EditAssignmentView(assignment: assignment) }
        .alert("Delete assignment?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                context.delete(assignment)
                try? context.save()
                dismiss()
            }
        } message: { Text("This action cannot be undone.") }
    }
}
