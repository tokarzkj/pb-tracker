import SwiftUI
import SwiftData

@main
struct Pb_TrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Marker.self,
            MaintenanceRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MarkerListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
