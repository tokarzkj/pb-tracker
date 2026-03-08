import Foundation
import SwiftData

@Model
final class Outing {
    var id = UUID()
    var date: Date = Date()
    var fieldLocation: String = ""
    var paintBrand: String = ""
    var paintGrade: String = ""
    var eliminations: Int = 0
    var timesEliminated: Int = 0
    var shotsFired: Int = 0
    var notes: String?
    
    // Relationship: Each outing is tied to one marker
    var marker: Marker?

    init(
        date: Date = Date(),
        fieldLocation: String = "",
        paintBrand: String = "",
        paintGrade: String = "",
        eliminations: Int = 0,
        timesEliminated: Int = 0,
        shotsFired: Int = 0,
        notes: String? = nil,
        marker: Marker? = nil
    ) {
        self.date = date
        self.fieldLocation = fieldLocation
        self.paintBrand = paintBrand
        self.paintGrade = paintGrade
        self.eliminations = eliminations
        self.timesEliminated = timesEliminated
        self.shotsFired = shotsFired
        self.notes = notes
        self.marker = marker
    }
}
