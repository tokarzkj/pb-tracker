import Foundation

struct PersonalBest: Identifiable, Codable {
    var id = UUID()
    var name: String
    var value: Double
    var unit: String
    var date: Date
    var category: String
}

extension PersonalBest {
    @MainActor
    static let examples: [PersonalBest] = [
        PersonalBest(name: "Bench Press", value: 225, unit: "lbs", date: Date(), category: "Strength"),
        PersonalBest(name: "5K Run", value: 21.5, unit: "min", date: Date().addingTimeInterval(-86400 * 5), category: "Cardio"),
        PersonalBest(name: "Deadlift", value: 315, unit: "lbs", date: Date().addingTimeInterval(-86400 * 2), category: "Strength")
    ]
}
