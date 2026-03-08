import Testing
import SwiftData
import Foundation
@testable import PBTracker

struct MaintenanceRecordTests {
    @Test @MainActor 
    func addingMaintenanceRecordUpdatesLifetimeShots() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, MaintenanceRecord.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Test CS3", modelName: "PE CS3")
        context.insert(marker)
        
        // Initial state
        #expect(marker.totalLifetimeShots == 0)
        
        // Add a record with 2000 shots
        let record1 = MaintenanceRecord(shotsSinceLast: 2000, tasks: ["Cleaning"], marker: marker)
        context.insert(record1)
        
        #expect(marker.maintenanceLogs.count == 1)
        #expect(marker.totalLifetimeShots == 2000)
        
        // Add another record with 1000 shots
        let record2 = MaintenanceRecord(shotsSinceLast: 1000, tasks: ["Greasing Bolt"], marker: marker)
        context.insert(record2)
        
        #expect(marker.maintenanceLogs.count == 2)
        #expect(marker.totalLifetimeShots == 3000)
    }

    @Test @MainActor
    func updatingMaintenanceRecordRecalculatesLifetimeShots() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, MaintenanceRecord.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Test CS3", modelName: "PE CS3")
        context.insert(marker)
        
        let record = MaintenanceRecord(shotsSinceLast: 2000, marker: marker)
        context.insert(record)
        #expect(marker.totalLifetimeShots == 2000)
        
        // Update the shot count (fixing a mistake)
        record.shotsSinceLast = 2500
        try context.save()
        
        #expect(marker.totalLifetimeShots == 2500)
    }
}
