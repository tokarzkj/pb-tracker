import Testing
@testable import PBTracker

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
    func deletingMaintenanceRecordRecalculatesLifetimeShots() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, MaintenanceRecord.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Test CS3", modelName: "PE CS3")
        context.insert(marker)
        
        let record1 = MaintenanceRecord(shotsSinceLast: 2000, marker: marker)
        let record2 = MaintenanceRecord(shotsSinceLast: 1500, marker: marker)
        context.insert(record1)
        context.insert(record2)
        
        #expect(marker.totalLifetimeShots == 3500)
        
        // Delete one record
        context.delete(record1)
        try context.save()
        
        #expect(marker.totalLifetimeShots == 1500)
    }

    @Test @MainActor
    func markerCascadeDeletesMaintenanceRecords() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, MaintenanceRecord.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Delete Me", modelName: "PE CS3")
        context.insert(marker)
        
        let record = MaintenanceRecord(shotsSinceLast: 1000, marker: marker)
        context.insert(record)
        
        // Delete the marker
        context.delete(marker)
        try context.save()
        
        // Verify both are gone
        let fetchDescriptor = FetchDescriptor<MaintenanceRecord>()
        let records = try context.fetch(fetchDescriptor)
        #expect(records.isEmpty)
    }
}
