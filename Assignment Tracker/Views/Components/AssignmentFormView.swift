import SwiftUI

struct AssignmentFormView: View {
    @Binding var title: String
    @Binding var subject: String
    @Binding var faculty: String
    @Binding var dueDate: Date
    @Binding var marks: Int
    @Binding var notes: String
    @Binding var status: AssignmentStatus
    let errorMessage: String?

    var body: some View {
        Form {
            Section("Basic information") {
                TextField("Assignment title", text: $title)
                Picker("Subject", selection: $subject) {
                    ForEach(Subject.allCases) { Text($0.rawValue).tag($0.rawValue) }
                }
                TextField("Faculty name", text: $faculty)
            }
            Section("Submission") {
                DatePicker("Due date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                Stepper("Marks: \(marks)", value: $marks, in: 0...AppConstants.maximumMarks)
                Picker("Status", selection: $status) {
                    ForEach(AssignmentStatus.allCases) { Text($0.rawValue).tag($0) }
                }
            }
            Section("Notes") {
                TextEditor(text: $notes).frame(minHeight: 100)
            }
            if let errorMessage {
                Section { Text(errorMessage).foregroundStyle(.red) }
            }
        }
    }
}
