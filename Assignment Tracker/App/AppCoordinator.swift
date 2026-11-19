import SwiftUI
import SwiftData
import Combine
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var selectedAssignmentID: PersistentIdentifier?
}
