import Testing
import SwiftData
import Foundation
@testable import Pb_Tracker

struct OutingTests {
    @Test @MainActor
    func addingSessionAndOutingUpdatesMarkerTotalShots() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, Session.self, Outing.self, configurations: config)
        let context = container.mainContext
        
        let marker = Marker(name: "Test CS3", modelName: "PE CS3")
        context.insert(marker)
        
        let session = Session(fieldLocation: "SC Village")
        context.insert(session)
        
        // Add an outing (marker performance in a session)
        let outing = Outing(shotsFired: 1500, marker: marker, session: session)
        context.insert(outing)
        
        #expect(marker.outings.count == 1)
        #expect(session.outings.count == 1)
        #expect(marker.totalLifetimeShots == 1500)
    }

    @Test @MainActor
    func multipleMarkersInOneSession() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Marker.self, Session.self, Outing.self, configurations: config)
        let context = container.mainContext
        
        let cs3 = Marker(name: "My CS3")
        let ego = Marker(name: "My Ego")
        context.insert(cs3)
        context.insert(ego)
        
        let session = Session(fieldLocation: "Paintball Gateway")
        context.insert(session)
        
        let cs3Outing = Outing(shotsFired: 2000, marker: cs3, session: session)
        let egoOuting = Outing(shotsFired: 500, marker: ego, session: session)
        context.insert(cs3Outing)
        context.insert(egoOuting)
        
        #expect(session.outings.count == 2)
        #expect(cs3.totalLifetimeShots == 2000)
        #expect(ego.totalLifetimeShots == 500)
    }
}
