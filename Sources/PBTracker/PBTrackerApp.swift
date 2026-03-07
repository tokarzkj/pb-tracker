import SwiftUI
import SwiftData

@main
struct PBTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MarkerListView()
        }
        .modelContainer(for: [Marker.self, MaintenanceRecord.self])
    }
}
