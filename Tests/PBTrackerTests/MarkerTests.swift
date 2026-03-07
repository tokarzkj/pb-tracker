import XCTest
@testable import PBTracker

final class MarkerTests: XCTestCase {
    func testMarkerInitialization() throws {
        // Red: Marker model doesn't exist yet
        let marker = Marker(
            name: "My CS3",
            modelName: "Planet Eclipse CS3",
            serialNumber: "PE-12345-CS3"
        )
        
        XCTAssertEqual(marker.name, "My CS3")
        XCTAssertEqual(marker.modelName, "Planet Eclipse CS3")
        XCTAssertEqual(marker.serialNumber, "PE-12345-CS3")
        XCTAssertEqual(marker.totalLifetimeShots, 0)
    }
}
