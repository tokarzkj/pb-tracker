import SwiftUI
import SwiftData
import PhotosUI

struct MaintenanceLoggingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let marker: Marker
    
    @State private var date = Date()
    @State private var shotsSinceLast = 0
    @State private var category: MaintenanceCategory = .routine
    @State private var notes = ""
    @State private var selectedTasks: Set<String> = []
    @State private var imageData: Data?
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
        NavigationStack {
            Form {
                Section("Session Stats") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shots Since Last Maintenance")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        TextField("Number of shots", value: $shotsSinceLast, format: .number)
                            .font(.system(.title, design: .monospaced))
                            .keyboardType(.numberPad)
                        
                        HStack {
                            Button("+1000 (1/2 Case)") { shotsSinceLast += 1000 }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                            
                            Button("+2000 (Case)") { shotsSinceLast += 2000 }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                            
                            Button("Reset") { shotsSinceLast = 0 }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Tasks Performed") {
                    Picker("Category", selection: $category) {
                        ForEach(MaintenanceCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 4)
                    
                    ForEach(predefinedTasks, id: \.self) { task in
                        Toggle(task, isOn: Binding(
                            get: { selectedTasks.contains(task) },
                            set: { isSelected in
                                if isSelected {
                                    selectedTasks.insert(task)
                                } else {
                                    selectedTasks.remove(task)
                                }
                            }
                        ))
                        .toggleStyle(CheckboxToggleStyle())
                    }
                }
                
                Section("Details & Photo") {
                    TextField("Additional Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...10)
                    
                    if let imageData, let image = Image(data: imageData) {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onTapGesture { isShowingCamera = true }
                    } else {
                        Button(action: { isShowingCamera = true }) {
                            Label("Add Photo of Work", systemImage: "camera.badge.ellipsis")
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .navigationTitle("Log Maintenance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRecord()
                    }
                    .disabled(selectedTasks.isEmpty && notes.isEmpty)
                }
            }
            .fullScreenCover(isPresented: $isShowingCamera) {
                CameraView(capturedData: $imageData)
            }
        }
    }
    
    private func saveRecord() {
        let record = MaintenanceRecord(
            date: date,
            shotsSinceLast: shotsSinceLast,
            tasks: Array(selectedTasks),
            category: category,
            notes: notes.isEmpty ? nil : notes,
            imageData: imageData,
            marker: marker
        )
        
        modelContext.insert(record)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save maintenance record: \(error.localizedDescription)")
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(configuration.isOn ? .blue : .secondary)
                    .font(.title3)
                configuration.label
                    .foregroundStyle(.primary)
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let marker = Marker(name: "Test CS3", modelName: "PE CS3")
    return MaintenanceLoggingView(marker: marker)
}
