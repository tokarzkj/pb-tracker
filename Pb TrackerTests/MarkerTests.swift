import Testing
import SwiftData
import Foundation
@testable import Pb_Tracker

struct MarkerTests {
    @Test func markerInitialization() {
        let marker = Marker(
            name: "My CS3",
            modelName: "Planet Eclipse CS3",
            serialNumber: "PE-12345-CS3"
        )
        
        #expect(marker.name == "My CS3")
        #expect(marker.modelName == "Planet Eclipse CS3")
        #expect(marker.serialNumber == "PE-12345-CS3")
        #expect(marker.totalLifetimeShots == 0)
    }

    @Test @MainActor
    func addingOutingUpdatesLifetimeShots() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, Outing.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Test CS3", modelName: "PE CS3")
        context.insert(marker)
        
        let outing = Outing(shotsFired: 2000, marker: marker)
        context.insert(outing)
        
        #expect(marker.totalLifetimeShots == 2000)
    }

    @Test @MainActor
    func markerCascadeDeletesRecords() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, MaintenanceRecord.self, Outing.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Delete Me", modelName: "PE CS3")
        context.insert(marker)
        
        let record = MaintenanceRecord(tasks: ["Cleaning"], marker: marker)
        let outing = Outing(shotsFired: 1000, marker: marker)
        context.insert(record)
        context.insert(outing)
        
        // Delete the marker
        context.delete(marker)
        try context.save()
        
        // Verify all are gone
        let records = try context.fetch(FetchDescriptor<MaintenanceRecord>())
        let outings = try context.fetch(FetchDescriptor<Outing>())
        #expect(records.isEmpty)
        #expect(outings.isEmpty)
    }
}
