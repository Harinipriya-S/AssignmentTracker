import Foundation
import Combine

@MainActor
final class SearchAssignmentViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedSubject = "All"

    func results(from assignments: [Assignment], userID: String) -> [Assignment] {
        assignments.filter { assignment in
            guard assignment.userID == userID else { return false }
            let matchesText = searchText.isEmpty ||
                assignment.title.localizedCaseInsensitiveContains(searchText) ||
                assignment.subject.localizedCaseInsensitiveContains(searchText)
            let matchesSubject = selectedSubject == "All" || assignment.subject == selectedSubject
            return matchesText && matchesSubject
        }
    }
}
