import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Markers", systemImage: "scope") {
                MarkerListView()
            }
            
            Tab("Analytics & Stats", systemImage: "chart.bar.xaxis") {
                AnalyticsDashboardView()
            }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: [Marker.self, Session.self, Outing.self, MaintenanceRecord.self], inMemory: true)
}
