import SwiftUI

struct AppRootView: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var authViewModel = AuthenticationViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                TabView(selection: $coordinator.selectedTab) {
                    DashboardView()
                        .tabItem { Label("Dashboard", systemImage: "house") }
                        .tag(0)
                    AssignmentListView()
                        .tabItem { Label("Assignments", systemImage: "list.bullet") }
                        .tag(1)
                }
                .environmentObject(coordinator)
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
    }
}
