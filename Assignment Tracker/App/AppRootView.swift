import SwiftUI
import SwiftData

struct AppRootView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var authViewModel = AuthenticationViewModel()

    var body: some View {
        Group {
            if let user = authViewModel.currentUser {
                TabView(selection: $coordinator.selectedTab) {
                    DashboardView(user: user, onSignOut: authViewModel.signOut)
                        .tabItem { Label("Dashboard", systemImage: "house") }
                        .tag(0)

                    AssignmentListView(userID: user.id)
                        .tabItem { Label("Assignments", systemImage: "list.bullet") }
                        .tag(1)
                }
                .environmentObject(coordinator)
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
        .onAppear {
            authViewModel.configure(context: modelContext)
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
    }
}
