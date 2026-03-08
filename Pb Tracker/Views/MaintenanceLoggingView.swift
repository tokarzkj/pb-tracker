import SwiftUI
import SwiftData
import PhotosUI

struct MaintenanceLoggingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let marker: Marker
    
    @State private var date = Date()
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
                Section {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                } header: {
                    Text("Date")
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
                        Button {
                            if selectedTasks.contains(task) {
                                selectedTasks.remove(task)
                            } else {
                                selectedTasks.insert(task)
                            }
                        } label: {
                            HStack {
                                Image(systemName: selectedTasks.contains(task) ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selectedTasks.contains(task) ? .blue : .secondary)
                                    .font(.title3)
                                
                                Text(task)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
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

#Preview {
    let marker = Marker(name: "Test CS3", modelName: "PE CS3")
    return MaintenanceLoggingView(marker: marker)
}
