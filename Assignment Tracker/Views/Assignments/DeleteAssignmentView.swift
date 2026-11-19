import SwiftUI

struct DeleteAssignmentView: View {
    let assignmentTitle: String
    var onDelete: () -> Void

    var body: some View {
        Button(role: .destructive, action: onDelete) {
            Label("Delete \(assignmentTitle)", systemImage: "trash")
        }
    }
}

