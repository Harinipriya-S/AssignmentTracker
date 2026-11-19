import SwiftUI

struct FilterAssignmentView: View {
    @Binding var selectedSubject: String

    var body: some View {
        Picker("Subject", selection: $selectedSubject) {
            Text("All subjects").tag("All")
            ForEach(Subject.allCases) { subject in
                Text(subject.rawValue).tag(subject.rawValue)
            }
        }
    }
}
