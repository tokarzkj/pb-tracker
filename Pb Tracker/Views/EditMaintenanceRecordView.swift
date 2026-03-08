import SwiftUI
import SwiftData

struct EditMaintenanceRecordView: View {
    @Bindable var record: MaintenanceRecord
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var isShowingCamera = false
    
    private let predefinedTasks = [
        "Cleaning",
        "Greasing Bolt",
        "Replacing Screws",
        "Replacing Grips",
        "Replacing O-Rings",
        "Battery Swap"
    ]
    
    var body: some View {
        Form {
            Section {
                DatePicker("Date", selection: $record.date, displayedComponents: .date)
            } header: {
                Text("Date")
            }
            
            Section("Tasks Performed") {
                Picker("Category", selection: $record.category) {
                    ForEach(MaintenanceCategory.allCases, id: \.self) { cat in
                        Text(cat.rawValue).tag(cat)
                    }
                }
                .pickerStyle(.segmented)
                
                ForEach(predefinedTasks, id: \.self) { task in
                    Button {
                        if record.tasks.contains(task) {
                            record.tasks.removeAll { $0 == task }
                        } else {
                            record.tasks.append(task)
                        }
                    } label: {
                        HStack {
                            Image(systemName: record.tasks.contains(task) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(record.tasks.contains(task) ? .blue : .secondary)
                                .font(.title3)
                            
                            Text(task)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Section("Notes & Photo") {
                TextField("Additional Notes", text: Binding(
                    get: { record.notes ?? "" },
                    set: { record.notes = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                .lineLimit(3...10)
                
                if let imageData = record.imageData, let image = Image(data: imageData) {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture { isShowingCamera = true }
                } else {
                    Button(action: { isShowingCamera = true }) {
                        Label("Add Photo", systemImage: "camera.badge.ellipsis")
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
        .navigationTitle("Edit Log")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            CameraView(capturedData: $record.imageData)
        }
    }
}

#Preview {
    let record = MaintenanceRecord(tasks: ["Cleaning"])
    return NavigationStack {
        EditMaintenanceRecordView(record: record)
    }
}
