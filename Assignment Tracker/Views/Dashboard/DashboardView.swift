import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingAdd = false
    @State private var showingSearch = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your study overview").font(.title2.bold())
                    AssignmentSummaryCard(summary: viewModel.summary)
                    HStack {
                        Text("Upcoming assignments").font(.headline)
                        Spacer()
                        Button("See all") { coordinator.selectedTab = 1 }
                    }
                    if let next = viewModel.summary.nextDue {
                        UpcomingAssignmentCard(assignment: next)
                    } else {
                        EmptyStateView(title: "No upcoming assignments", message: "Add an assignment to see it here.")
                    }
                    Button { showingAdd = true } label: {
                        Label("Add assignment", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingSearch = true } label: { Image(systemName: "magnifyingglass") }
                }
            }
            .sheet(isPresented: $showingAdd) { AddAssignmentView { viewModel.refresh() } }
            .sheet(isPresented: $showingSearch) { SearchAssignmentView() }
            .onAppear { viewModel.load(context: context) }
            .onChange(of: showingAdd) { _, isShowing in if !isShowing { viewModel.refresh() } }
        }
    }
}
