import Foundation

enum MaintenanceCategory: String, Codable, CaseIterable {
    case routine = "Routine"
    case repair = "Repair"
    case deepClean = "Deep Clean"
}
