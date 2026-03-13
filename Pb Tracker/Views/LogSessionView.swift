import SwiftUI
import SwiftData

struct LogSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let initialMarker: Marker?
    
    @State private var date = Date()
    @State private var fieldLocation = ""
    @State private var paintBrand = ""
    @State private var paintGrade = ""
    @State private var rating: OutingRating = .neutral
    @State private var notes = ""
    
    @State private var createdSession: Session?
    @State private var isShowingAddOuting = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Date & Location") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Field Location", text: $fieldLocation)
                }
                
                Section("Session Rating") {
                    Picker("Rating", selection: $rating) {
                        ForEach(OutingRating.allCases, id: \.self) { rate in
                            Text(rate.icon).tag(rate)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Paint Details") {
                    TextField("Paint Brand", text: $paintBrand)
                    TextField("Paint Grade", text: $paintGrade)
                }
                
                Section("Notes") {
                    TextField("How was the day?", text: $notes, axis: .vertical)
                        .lineLimit(3...10)
                }
            }
            .navigationTitle("New Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Next") {
                        saveSession()
                    }
                    .disabled(fieldLocation.isEmpty)
                }
            }
            .navigationDestination(isPresented: $isShowingAddOuting) {
                if let session = createdSession {
                    AddOutingToSessionView(session: session, initialMarker: initialMarker)
                }
            }
        }
    }
    
    private func saveSession() {
        let session = Session(
            date: date,
            fieldLocation: fieldLocation,
            paintBrand: paintBrand,
            paintGrade: paintGrade,
            rating: rating,
            notes: notes.isEmpty ? nil : notes
        )
        
        modelContext.insert(session)
        
        do {
            try modelContext.save()
            createdSession = session
            isShowingAddOuting = true
        } catch {
            print("Failed to save session: \(error.localizedDescription)")
        }
    }
}

#Preview {
    LogSessionView(initialMarker: nil)
}
