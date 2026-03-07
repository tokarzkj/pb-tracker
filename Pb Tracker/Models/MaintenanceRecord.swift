import Foundation
import SwiftData

@Model
final class MaintenanceRecord {
    var id = UUID()
    var date: Date = Date()
    var shotsSinceLast: Int = 0
    var tasks: [String] = []
    var category: MaintenanceCategory = MaintenanceCategory.routine
    var notes: String?
    var imageData: Data?
    
    // Relationship: Each record belongs to one Marker
    // Note: Must be optional for CloudKit sync.
    var marker: Marker?

    init(
        date: Date = Date(),
        shotsSinceLast: Int = 0,
        tasks: [String] = [],
        category: MaintenanceCategory = .routine,
        notes: String? = nil,
        imageData: Data? = nil,
        marker: Marker? = nil
    ) {
        self.date = date
        self.shotsSinceLast = shotsSinceLast
        self.tasks = tasks
        self.category = category
        self.notes = notes
        self.imageData = imageData
        self.marker = marker
    }
}
