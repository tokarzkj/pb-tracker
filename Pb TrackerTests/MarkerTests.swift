import Testing
@testable import PBTracker

struct MarkerTests {
    @Test func markerInitialization() {
        let marker = Marker(
            name: "My CS3",
            modelName: "Planet Eclipse CS3",
            serialNumber: "PE-12345-CS3"
        )
        
        #expect(marker.name == "My CS3")
        #expect(marker.modelName == "Planet Eclipse CS3")
        #expect(marker.serialNumber == "PE-12345-CS3")
        #expect(marker.totalLifetimeShots == 0)
    }
}
