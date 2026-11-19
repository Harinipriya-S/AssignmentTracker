import Foundation

enum FormValidator {
    static func isValid(title: String, faculty: String, marks: Int) -> Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !faculty.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (0...AppConstants.maximumMarks).contains(marks)
    }
}
