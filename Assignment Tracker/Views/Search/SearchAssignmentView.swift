import SwiftUI
import SwiftData

struct SearchAssignmentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Assignment.dueDate) private var assignments: [Assignment]
    @StateObject private var viewModel = SearchAssignmentViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.results(from: assignments)) { assignment in
                NavigationLink {
                    AssignmentDetailView(assignment: assignment)
                } label: {
                    AssignmentRowView(assignment: assignment)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search title or subject")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Subject", selection: $viewModel.selectedSubject) {
                            Text("All subjects").tag("All")
                            ForEach(Subject.allCases) { subject in
                                Text(subject.rawValue).tag(subject.rawValue)
                            }
                        }
                    } label: { Label("Filter", systemImage: "line.3.horizontal.decrease") }
                }
            }
            .navigationTitle("Search")
        }
    }
}
