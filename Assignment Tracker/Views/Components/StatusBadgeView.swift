import SwiftUI

struct StatusBadgeView: View {
    let status: AssignmentStatus

    var body: some View {
        Text(status.displayName)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.14), in: Capsule())
            .foregroundStyle(color)
    }

    private var color: Color {
        switch status {
        case .pending: return .orange
        case .inProgress: return .blue
        case .submitted: return .green
        }
    }
}
