
import SwiftUI

struct AssignmentFormView: View {

    @Binding var title: String
    @Binding var subject: String
    @Binding var faculty: String
    @Binding var dueDate: Date
    @Binding var marks: String
    @Binding var notes: String
    @Binding var status: AssignmentStatus

    let errorMessage: String?

    var body: some View {

        Form {

            Section("Basic Information") {

                TextField("Assignment title", text: $title)

                Picker("Subject", selection: $subject) {
                    ForEach(Subject.allCases) { subject in
                        Text(subject.rawValue)
                            .tag(subject.rawValue)
                    }
                }

                TextField("Faculty name", text: $faculty)
            }

            Section("Submission") {

                DatePicker(
                    "Due date",
                    selection: $dueDate,
                    displayedComponents: [.date, .hourAndMinute]
                )

                TextField("Enter marks", text: $marks)
                    .keyboardType(.numberPad)

                Picker("Status", selection: $status) {
                    ForEach(AssignmentStatus.allCases) { status in
                        Text(status.rawValue)
                            .tag(status)
                    }
                }
            }

            Section("Notes") {

                TextEditor(text: $notes)
                    .frame(minHeight: 100)
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}
