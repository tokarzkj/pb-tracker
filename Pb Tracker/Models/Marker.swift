import Foundation
import SwiftData

@Model
final class Marker {
    var id = UUID()
    var name: String = ""
    var modelName: String = ""
    var serialNumber: String?
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
    var totalLifetimeShots: Int {
        outings.reduce(0) { $0 + $1.shotsFired }
    }

    var daysSinceLastMaintenance: Int? {
        guard let lastRecord = maintenanceLogs.sorted(by: { $0.date > $1.date }).first else {
            return nil
        }
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfRecordDay = calendar.startOfDay(for: lastRecord.date)
        let components = calendar.dateComponents([.day], from: startOfRecordDay, to: startOfToday)
        return components.day
    }

    var averageEliminations: Double {
        guard !outings.isEmpty else { return 0 }
        let total = outings.reduce(0) { $0 + $1.eliminations }
        return Double(total) / Double(outings.count)
    }

    var kdRatio: Double {
        let stats = outings.reduce((kills: 0, deaths: 0)) { acc, outing in
            (acc.kills + outing.eliminations, acc.deaths + outing.timesEliminated)
        }
        guard stats.deaths > 0 else { return Double(stats.kills) }
        return Double(stats.kills) / Double(stats.deaths)
    }

    // Relationship: A marker has many maintenance records
    @Relationship(deleteRule: .cascade, inverse: \MaintenanceRecord.marker)
    var maintenanceLogs: [MaintenanceRecord] = []
    
    // Relationship: A marker has many performances (Outings)
    @Relationship(deleteRule: .cascade, inverse: \Outing.marker)
    var outings: [Outing] = []

    init(name: String = "", modelName: String = "", serialNumber: String? = nil, imageData: Data? = nil) {
        self.name = name
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.imageData = imageData
    }
}
