
import SwiftUI
import SwiftData

struct SearchAssignmentView: View {

    @Query(sort: \Assignment.dueDate)
    private var assignments: [Assignment]

    @StateObject private var viewModel = SearchAssignmentViewModel()

    let userID: String

    // Display only the logged-in user's assignments
    private var userAssignments: [Assignment] {
        assignments.filter {
            $0.userID == userID
        }
    }

    var body: some View {

        NavigationStack {

            List(
                viewModel.results(
                    from: userAssignments,
                    userID: userID
                )
            ) { assignment in

                NavigationLink {
                    AssignmentDetailView(
                        selectedAssignment: assignment,
                        userID: userID
                    )
                } label: {
                    AssignmentRowView(
                        assignment: assignment
                    )
                }
            }
            .overlay {
                if viewModel.results(
                    from: userAssignments,
                    userID: userID
                ).isEmpty {

                    ContentUnavailableView.search(
                        text: viewModel.searchText
                    )
                }
            }
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search title or subject"
            )
            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Menu {

                        Picker(
                            "Subject",
                            selection: $viewModel.selectedSubject
                        ) {

                            Text("All subjects")
                                .tag("All")

                            ForEach(Subject.allCases) { subject in

                                Text(subject.rawValue)
                                    .tag(subject.rawValue)
                            }
                        }

                    } label: {

                        Label(
                            "Filter",
                            systemImage: "line.3.horizontal.decrease"
                        )
                    }
                }
            }
            .navigationTitle("Search")
        }
    }
}
