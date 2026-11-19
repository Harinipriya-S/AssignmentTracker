import SwiftUI
import SwiftData

struct AssignmentListView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = AssignmentListViewModel()
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Status", selection: Binding(
                        get: { viewModel.selectedStatus?.rawValue ?? "All" },
                        set: { viewModel.selectedStatus = $0 == "All" ? nil : AssignmentStatus(rawValue: $0) }
                    )) {
                        Text("All").tag("All")
                        ForEach(AssignmentStatus.allCases) { status in
                            Text(status.rawValue).tag(status.rawValue)
                        }
                    }
                }
                ForEach(viewModel.visibleAssignments) { assignment in
                    NavigationLink {
                        AssignmentDetailView(assignment: assignment)
                    } label: {
                        AssignmentRowView(assignment: assignment)
                    }
                }
                .onDelete { offsets in
                    let items = viewModel.visibleAssignments
                    for index in offsets { viewModel.delete(items[index]) }
                }
            }
            .navigationTitle("Assignments")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showingAdd) { AddAssignmentView { viewModel.refresh() } }
            .onAppear { viewModel.load(context: context) }
        }
    }
}
