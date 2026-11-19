import SwiftUI
import SwiftData

struct AssignmentListView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = AssignmentListViewModel()
    @State private var showingAdd = false

    let userID: String

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Status", selection: Binding(
                        get: { viewModel.selectedStatus?.rawValue ?? "All" },
                        set: {
                            viewModel.selectedStatus = $0 == "All"
                                ? nil
                                : AssignmentStatus(rawValue: $0)
                        }
                    )) {
                        Text("All").tag("All")
                        ForEach(AssignmentStatus.allCases) { status in
                            Text(status.rawValue).tag(status.rawValue)
                        }
                    }
                }

                ForEach(viewModel.visibleAssignments) { assignment in
                    NavigationLink {
                        AssignmentDetailView(selectedAssignment: assignment, userID: userID)
                    } label: {
                        AssignmentRowView(assignment: assignment)
                    }
                }
                .onDelete { offsets in
                    let items = viewModel.visibleAssignments
                    for index in offsets {
                        viewModel.delete(items[index])
                    }
                }
            }
            .overlay {
                if viewModel.visibleAssignments.isEmpty {
                    ContentUnavailableView(
                        "No assignments",
                        systemImage: "doc.text",
                        description: Text("Add your first assignment.")
                    )
                }
            }
            .navigationTitle("Assignments")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddAssignmentView(userID: userID) { viewModel.refresh() }
            }
            .onAppear {
                viewModel.load(context: context, userID: userID)
            }
            .onChange(of: showingAdd) { _, isShowing in
                if !isShowing { viewModel.refresh() }
            }
        }
    }
}
