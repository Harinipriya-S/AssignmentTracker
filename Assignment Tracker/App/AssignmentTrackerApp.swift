import SwiftUI
import SwiftData

@main
struct AssignmentTrackerApp: App {
    let container: ModelContainer

    init() {
        do {
            container = try AssignmentModelContainer.makeContainer()
        } catch {
            fatalError("Unable to create app storage: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .modelContainer(container)
        }
    }
}
