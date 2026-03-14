import SwiftUI
import SwiftData

struct EditOutingView: View {
    @Bindable var outing: Outing
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                if let session = outing.session {
                    Section("Session Info") {
                        HStack {
                            Image(systemName: session.rating.icon)
                                .foregroundStyle(session.rating.color)
                            Text(session.fieldLocation)
                        }
                        Text(session.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("Performance Stats") {
                    Stepper("Eliminations: \(outing.eliminations)", value: $outing.eliminations, in: 0...100)
                    Stepper("Times Eliminated: \(outing.timesEliminated)", value: $outing.timesEliminated, in: 0...100)
                    
                    VStack(alignment: .leading) {
                        Text("Shots Fired")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Shots for this marker", value: $outing.shotsFired, format: .number)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .navigationTitle("Edit Performance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .disabled(outing.shotsFired <= 0)
                }
            }
        }
    }
}

#Preview {
    let outing = Outing(shotsFired: 2000)
    EditOutingView(outing: outing)
}
