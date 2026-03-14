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
