import SwiftUI
import SwiftData

struct AddOutingToSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let session: Session
    let initialMarker: Marker?
    
    @Query(sort: \Marker.name) private var markers: [Marker]
    
    @State private var selectedMarker: Marker?
    @State private var shotsFired = 0
    @State private var eliminations = 0
    @State private var timesEliminated = 0

    init(session: Session, initialMarker: Marker?) {
        self.session = session
        self.initialMarker = initialMarker
        self._selectedMarker = State(initialValue: initialMarker)
    }
    
    var body: some View {
        Form {
            Section("Select Marker") {
                Picker("Marker", selection: $selectedMarker) {
                    Text("Select a marker").tag(nil as Marker?)
                    ForEach(markers.filter { marker in
                        !session.outings.contains(where: { $0.marker?.id == marker.id })
                    }) { marker in
                        Text(marker.name).tag(marker as Marker?)
                    }
                }
            }
            
            Section("Performance") {
                Stepper("Eliminations: \(eliminations)", value: $eliminations, in: 0...100)
                Stepper("Times Eliminated: \(timesEliminated)", value: $timesEliminated, in: 0...100)
                
                VStack(alignment: .leading) {
                    Text("Shots Fired")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextField("Shots for this marker", value: $shotsFired, format: .number)
                        .keyboardType(.numberPad)
                }
            }
            
            if !session.outings.isEmpty {
                Section("Already Logged") {
                    ForEach(session.outings) { outing in
                        HStack {
                            Text(outing.marker?.name ?? "Unknown")
                            Spacer()
                            Text("\(outing.shotsFired) shots")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Marker Performance")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add & Finish") {
                    saveOutingAndFinish()
                }
                .disabled(selectedMarker == nil || shotsFired <= 0)
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button("Add Another Marker") {
                    saveOutingAndKeepAdding()
                }
                .disabled(selectedMarker == nil || shotsFired <= 0)
            }
        }
    }
    
    private func saveOutingAndFinish() {
        saveOuting()
        dismiss()
    }
    
    private func saveOutingAndKeepAdding() {
        saveOuting()
        // Reset fields for next marker
        selectedMarker = nil
        shotsFired = 0
        eliminations = 0
        timesEliminated = 0
    }
    
    private func saveOuting() {
        guard let marker = selectedMarker else { return }
        let outing = Outing(
            shotsFired: shotsFired,
            eliminations: eliminations,
            timesEliminated: timesEliminated,
            marker: marker,
            session: session
        )
        modelContext.insert(outing)
        try? modelContext.save()
    }
}
