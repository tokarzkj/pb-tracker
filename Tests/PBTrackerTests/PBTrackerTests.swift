import XCTest
@testable import PBTracker

final class PBTrackerTests: XCTestCase {
    func testExampleModel() throws {
        let example = PersonalBest.examples[0]
        XCTAssertEqual(example.name, "Bench Press")
        XCTAssertEqual(example.value, 225)
        XCTAssertEqual(example.unit, "lbs")
    }
}
