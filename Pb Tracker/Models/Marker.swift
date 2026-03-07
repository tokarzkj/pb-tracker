import Foundation
import SwiftData

@Model
final class Marker {
    // Note: Removed #Unique as it is not supported by CloudKit sync in 2026.
    
    var id = UUID()
    var name: String = ""
    var modelName: String = ""
    var serialNumber: String?
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
    var totalLifetimeShots: Int {
        maintenanceLogs.reduce(0) { $0 + $1.shotsSinceLast }
    }

    // Relationship: A marker has many maintenance records
    // Note: Explicitly made optional and provided inverse for CloudKit.
    @Relationship(deleteRule: .cascade, inverse: \MaintenanceRecord.marker)
    var maintenanceLogs: [MaintenanceRecord] = []

    init(name: String = "", modelName: String = "", serialNumber: String? = nil, imageData: Data? = nil) {
        self.name = name
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.imageData = imageData
    }
}
