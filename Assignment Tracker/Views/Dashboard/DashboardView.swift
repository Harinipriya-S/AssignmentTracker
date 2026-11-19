import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingAdd = false
    @State private var showingSearch = false

    let user: User
    let onSignOut: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Welcome, \(user.username)")
                        .font(.title2.bold())

                    Text("Your study overview")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    AssignmentSummaryCard(summary: viewModel.summary)

                    HStack {
                        Text("Upcoming assignments").font(.headline)
                        Spacer()
                        Button("See all") { coordinator.selectedTab = 1 }
                    }

                    if let next = viewModel.summary.nextDue {
                        UpcomingAssignmentCard(assignment: next)
                    } else {
                        EmptyStateView(
                            title: "No upcoming assignments",
                            message: "Add an assignment to see it here."
                        )
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
                    Menu {
                        Button("Search", systemImage: "magnifyingglass") {
                            showingSearch = true
                        }
                        Button("Sign out", systemImage: "rectangle.portrait.and.arrow.right", role: .destructive) {
                            onSignOut()
                        }
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddAssignmentView(userID: user.id) { viewModel.refresh() }
            }
            .sheet(isPresented: $showingSearch) {
                SearchAssignmentView(userID: user.id)
            }
            .onAppear {
                viewModel.load(context: context, userID: user.id)
            }
            .onChange(of: showingAdd) { _, isShowing in
                if !isShowing { viewModel.refresh() }
            }
        }
    }
}
