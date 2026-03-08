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
    @State private var selectedItem: PhotosPickerItem?
    @State private var isShowingCamera = false
    @State private var isImageLoading = false
    
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
                    
                    VStack(spacing: 16) {
                        if isImageLoading {
                            ProgressView()
                                .frame(height: 150)
                        } else if let imageData, let image = Image(data: imageData) {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        HStack(spacing: 20) {
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Label("Photos", systemImage: "photo.on.rectangle")
                            }
                            .buttonStyle(.bordered)

                            Button(action: { isShowingCamera = true }) {
                                Label("Camera", systemImage: "camera.fill")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
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
            .onChange(of: selectedItem) { oldValue, newItem in
                Task {
                    isImageLoading = true
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        imageData = data
                    }
                    isImageLoading = false
                }
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
