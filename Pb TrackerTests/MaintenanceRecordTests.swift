import Testing
import SwiftData
import Foundation
@testable import Pb_Tracker

struct MaintenanceRecordTests {
    @Test @MainActor 
    func addingMaintenanceRecord() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, MaintenanceRecord.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Test CS3", modelName: "PE CS3")
        context.insert(marker)
        
        // Add a record
        let record = MaintenanceRecord(tasks: ["Cleaning"], marker: marker)
        context.insert(record)
        
        #expect(marker.maintenanceLogs.count == 1)
        #expect(marker.maintenanceLogs.first?.tasks.contains("Cleaning") == true)
    }
}
