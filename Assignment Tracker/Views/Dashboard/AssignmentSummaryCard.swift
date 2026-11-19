import SwiftUI

struct AssignmentSummaryCard: View {
    let summary: AssignmentSummary

    var body: some View {
        HStack(spacing: 10) {
            metric("Total", value: summary.total, symbol: "doc.text")
            metric("Pending", value: summary.pending, symbol: "clock")
            metric("Submitted", value: summary.submitted, symbol: "checkmark.circle")
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func metric(_ title: String, value: Int, symbol: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: symbol).font(.title2).foregroundStyle(.tint)
            Text("\(value)").font(.title.bold())
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
