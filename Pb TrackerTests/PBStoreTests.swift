import XCTest
@testable import Pb_Tracker

final class PBStoreTests: XCTestCase {
    func testAddPB() throws {
        // Red: PBStore doesn't exist yet
        let store = PBStore()
        let newPB = PersonalBest(name: "Squat", value: 315, unit: "lbs", date: Date(), category: "Strength")
        
        store.add(newPB)
        
        XCTAssertEqual(store.pbs.count, 1)
        XCTAssertEqual(store.pbs.first?.name, "Squat")
    }
}
