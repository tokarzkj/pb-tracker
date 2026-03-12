import Foundation
import SwiftData

@Model
final class Outing {
    var id = UUID()
    var shotsFired: Int = 0
    var eliminations: Int = 0
    var timesEliminated: Int = 0
    
    // Relationship: Each performance is tied to one marker
    var marker: Marker?
    
    // Relationship: Each performance is part of a session
    var session: Session?

    init(
        shotsFired: Int = 0,
        eliminations: Int = 0,
        timesEliminated: Int = 0,
        marker: Marker? = nil,
        session: Session? = nil
    ) {
        self.shotsFired = shotsFired
        self.eliminations = eliminations
        self.timesEliminated = timesEliminated
        self.marker = marker
        self.session = session
    }
}
