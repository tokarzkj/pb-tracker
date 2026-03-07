import Foundation
import SwiftData

@Model
final class MaintenanceRecord {
    var id = UUID()
    var date: Date
    var shotsSinceLast: Int
    var tasks: [String]
    var category: MaintenanceCategory
    var notes: String?
    var imageData: Data?
    
    // Relationship: Each record belongs to one Marker
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
