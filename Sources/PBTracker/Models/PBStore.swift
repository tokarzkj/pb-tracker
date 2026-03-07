import Foundation
import Observation

@Observable
final class PBStore {
    var pbs: [PersonalBest] = []

    func add(_ pb: PersonalBest) {
        pbs.append(pb)
    }
}
