import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String

    var body: some View {
        ContentUnavailableView(title, systemImage: "tray", description: Text(message))
            .frame(maxWidth: .infinity)
    }
}

