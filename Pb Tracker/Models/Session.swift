import Foundation
import SwiftData
import SwiftUI

enum OutingRating: String, Codable, CaseIterable {
    case poor = "Poor"
    case neutral = "Neutral"
    case great = "Great"
    
    var icon: String {
        switch self {
        case .poor: return "hand.thumbsdown"
        case .neutral: return "face.dashed"
        case .great: return "face.smiling"
        }
    }
    
    var color: Color {
        switch self {
        case .poor: return .red
        case .neutral: return .orange
        case .great: return .green
        }
    }
}

@Model
final class Session {
    var id = UUID()
    var date: Date = Date()
    var fieldLocation: String = ""
    var paintBrand: String = ""
    var paintGrade: String = ""
    var rating: OutingRating = OutingRating.neutral
    var notes: String?
    
    // Relationship: A session has many marker-specific performances (Outings)
    @Relationship(deleteRule: .cascade, inverse: \Outing.session)
    var outings: [Outing] = []

    init(
        date: Date = Date(),
        fieldLocation: String = "",
        paintBrand: String = "",
        paintGrade: String = "",
        rating: OutingRating = .neutral,
        notes: String? = nil
    ) {
        self.date = date
        self.fieldLocation = fieldLocation
        self.paintBrand = paintBrand
        self.paintGrade = paintGrade
        self.rating = rating
        self.notes = notes
    }
}
