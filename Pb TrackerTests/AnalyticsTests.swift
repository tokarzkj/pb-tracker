import Testing
import SwiftData
import Foundation
@testable import Pb_Tracker

struct AnalyticsTests {
    @Test @MainActor
    func daysSinceLastMaintenanceCalculation() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, MaintenanceRecord.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Test CS3")
        context.insert(marker)
        
        // No records yet
        #expect(marker.daysSinceLastMaintenance == nil)
        
        // Record from 10 days ago
        let tenDaysAgo = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        let record = MaintenanceRecord(date: tenDaysAgo, marker: marker)
        context.insert(record)
        
        #expect(marker.daysSinceLastMaintenance == 10)
    }

    @Test @MainActor
    func performanceAveragesCalculation() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, Outing.self, Session.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Test CS3")
        context.insert(marker)
        
        let session = Session(fieldLocation: "SC Village")
        context.insert(session)
        
        let outing1 = Outing(shotsFired: 1000, eliminations: 5, timesEliminated: 1, marker: marker, session: session)
        let outing2 = Outing(shotsFired: 1000, eliminations: 10, timesEliminated: 2, marker: marker, session: session)
        context.insert(outing1)
        context.insert(outing2)
        
        // Average Eliminations: (5 + 10) / 2 = 7.5
        #expect(marker.averageEliminations == 7.5)
        
        // K/D Ratio: (5 + 10) / (1 + 2) = 5.0
        #expect(marker.kdRatio == 5.0)
    }
}
