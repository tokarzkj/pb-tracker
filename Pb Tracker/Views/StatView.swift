import SwiftUI

struct StatView: View {
    let title: String
    let value: String
    var icon: String?
    var color: Color = .primary

    var body: some View {
        VStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
            }
            Text(value)
                .font(.system(.title2, design: .monospaced))
                .bold()
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title): \(value)")
    }
}

#Preview {
    HStack(spacing: 20) {
        StatView(title: "Shots", value: "1500", icon: "bolt.fill", color: .blue)
        StatView(title: "Kills", value: "12", icon: "target", color: .green)
    }
}
