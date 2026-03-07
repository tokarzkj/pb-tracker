import SwiftUI

struct MarkerRowView: View {
    let marker: Marker

    var body: some View {
        HStack {
            if let imageData = marker.imageData, let image = Image(data: imageData) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Image(systemName: "scope")
                    .font(.title2)
                    .frame(width: 50, height: 50)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.blue)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(marker.name)
                    .font(.headline)
                Text(marker.modelName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(marker.totalLifetimeShots)")
                    .font(.system(.body, design: .monospaced))
                    .bold()
                Text("Lifetime Shots")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
