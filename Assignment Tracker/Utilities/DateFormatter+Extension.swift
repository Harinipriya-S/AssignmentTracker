import Foundation

extension Date {
    var assignmentDate: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var assignmentDateTime: String {
        formatted(date: .abbreviated, time: .shortened)
    }
}
