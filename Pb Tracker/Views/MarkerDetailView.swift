import SwiftUI
import SwiftData

struct MarkerDetailView: View {
    @Bindable var marker: Marker
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingLoggingSheet = false
    @State private var isShowingOutingSheet = false
    @State private var isShowingEditSheet = false

    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    if let imageData = marker.imageData, let image = Image(data: imageData) {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .glassEffect()
                    } else {
                        Image(systemName: "scope")
                            .font(.system(size: 60))
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .foregroundStyle(.blue)
                    }

                    HStack(spacing: 40) {
                        StatView(title: "Lifetime", value: "\(marker.totalLifetimeShots)")
                        StatView(title: "Records", value: "\(marker.maintenanceLogs.count)")
                        StatView(title: "Outings", value: "\(marker.outings.count)")
                    }
                }
                .padding(.vertical)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())

            Section("Performance Stats") {
                HStack {
                    Label("Avg Eliminations", systemImage: "target")
                    Spacer()
                    Text(String(format: "%.1f", marker.averageEliminations))
                        .bold()
                }
                HStack {
                    Label("K/D Ratio", systemImage: "scalemass")
                    Spacer()
                    Text(String(format: "%.2f", marker.kdRatio))
                        .bold()
                }
                HStack {
                    Label("Last Maintenance", systemImage: "clock")
                    Spacer()
                    if let days = marker.daysSinceLastMaintenance {
                        Text("\(days) days ago")
                            .foregroundStyle(days > 30 ? .red : .primary)
                    } else {
                        Text("Never")
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Session History") {
                if marker.outings.isEmpty {
                    ContentUnavailableView("No Sessions", systemImage: "flag.checkered", description: Text("You haven't logged any field sessions for this marker yet."))
                } else {
                    ForEach(marker.outings.sorted(by: { $0.session?.date ?? Date() > $1.session?.date ?? Date() })) { outing in
                        if let session = outing.session {
                            NavigationLink {
                                EditOutingView(outing: outing)
                            } label: {
                                OutingRowView(outing: outing, session: session)
                            }
                        }
                    }
                    .onDelete(perform: deleteOutings)
                }
            }

            Section("Maintenance History") {
                if marker.maintenanceLogs.isEmpty {
                    ContentUnavailableView("No Records", systemImage: "wrench.and.screwdriver", description: Text("You haven't logged any maintenance for this marker yet."))
                } else {
                    ForEach(marker.maintenanceLogs.sorted(by: { $0.date > $1.date })) { record in
                        NavigationLink {
                            EditMaintenanceRecordView(record: record)
                        } label: {
                            MaintenanceRowView(record: record)
                        }
                    }
                    .onDelete(perform: deleteRecords)
                }
            }
        }
        .navigationTitle(marker.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: { isShowingEditSheet = true }) {
                        Label("Edit Marker", systemImage: "pencil")
                    }
                    
                    Button(action: { isShowingOutingSheet = true }) {
                        Label("New Session", systemImage: "flag.checkered")
                    }
                    
                    Button(action: { isShowingLoggingSheet = true }) {
                        Label("Log Maintenance", systemImage: "wrench.and.screwdriver")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            EditMarkerView(marker: marker)
        }
        .fullScreenCover(isPresented: $isShowingLoggingSheet) {
            MaintenanceLoggingView(marker: marker)
        }
        .fullScreenCover(isPresented: $isShowingOutingSheet) {
            LogSessionView(initialMarker: marker)
        }
    }

    private func deleteRecords(offsets: IndexSet) {
        let sortedLogs = marker.maintenanceLogs.sorted(by: { $0.date > $1.date })
        for index in offsets {
            modelContext.delete(sortedLogs[index])
        }
    }

    private func deleteOutings(offsets: IndexSet) {
        let sortedOutings = marker.outings.sorted(by: { $0.session?.date ?? Date() > $1.session?.date ?? Date() })
        for index in offsets {
            modelContext.delete(sortedOutings[index])
        }
    }
}

struct OutingRowView: View {
    let outing: Outing
    let session: Session

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: session.rating.icon)
                        .foregroundStyle(session.rating.color)
                    Text(session.fieldLocation)
                        .font(.headline)
                }
                
                HStack(spacing: 12) {
                    Label("\(outing.shotsFired) shots", systemImage: "bolt.fill")
                    Label("\(outing.eliminations) Kills", systemImage: "target")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            Text(session.date, style: .date)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Marker.self, configurations: config)
    let marker = Marker(name: "My CS3", modelName: "Planet Eclipse CS3")
    return NavigationStack {
        MarkerDetailView(marker: marker)
    }
    .modelContainer(container)
}

struct StatView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title2, design: .monospaced))
                .bold()
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
        }
    }
}

struct MaintenanceRowView: View {
    let record: MaintenanceRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
                    .foregroundStyle(.blue)

                Text(record.tasks.joined(separator: ", "))
                    .font(.body)
                    .lineLimit(1)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(record.date, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
