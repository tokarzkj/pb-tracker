import SwiftUI
import SwiftData

struct AnalyticsDashboardView: View {
    @Query private var markers: [Marker]
    @Query private var sessions: [Session]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Collection Totals") {
                    HStack {
                        Label("Total Markers", systemImage: "scope")
                        Spacer()
                        Text("\(markers.count)")
                            .bold()
                    }
                    HStack {
                        Label("Lifetime Shots", systemImage: "bolt.fill")
                        Spacer()
                        Text("\(totalLifetimeShots)")
                            .bold()
                    }
                    HStack {
                        Label("Total Sessions", systemImage: "flag.checkered")
                        Spacer()
                        Text("\(sessions.count)")
                            .bold()
                    }
                }
                
                Section("Performance Averages") {
                    HStack {
                        Label("Avg K/D Ratio", systemImage: "scalemass")
                        Spacer()
                        Text(String(format: "%.2f", averageKDRatio))
                            .bold()
                    }
                    HStack {
                        Label("Avg Eliminations", systemImage: "target")
                        Spacer()
                        Text(String(format: "%.1f", averageEliminations))
                            .bold()
                    }
                }
                
                Section("Marker Comparison") {
                    ForEach(markers.sorted(by: { $0.totalLifetimeShots > $1.totalLifetimeShots })) { marker in
                        HStack {
                            Text(marker.name)
                            Spacer()
                            Text("\(marker.totalLifetimeShots) shots")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Analytics")
        }
    }
    
    private var totalLifetimeShots: Int {
        markers.reduce(0) { $0 + $1.totalLifetimeShots }
    }
    
    private var averageKDRatio: Double {
        guard !markers.isEmpty else { return 0 }
        let totalKD = markers.reduce(0.0) { $0 + $1.kdRatio }
        return totalKD / Double(markers.count)
    }
    
    private var averageEliminations: Double {
        guard !markers.isEmpty else { return 0 }
        let totalAvg = markers.reduce(0.0) { $0 + $1.averageEliminations }
        return totalAvg / Double(markers.count)
    }
}

#Preview {
    AnalyticsDashboardView()
        .modelContainer(for: [Marker.self, Session.self, Outing.self], inMemory: true)
}
