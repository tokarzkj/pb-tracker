import SwiftUI
import SwiftData
import PhotosUI

struct EditMaintenanceRecordView: View {
    @Bindable var record: MaintenanceRecord
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
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
                
                VStack(spacing: 16) {
                    if isImageLoading {
                        ProgressView()
                            .frame(height: 150)
                    } else if let imageData = record.imageData, let image = Image(data: imageData) {
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
        .navigationTitle("Edit Log")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            CameraView(capturedData: $record.imageData)
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                isImageLoading = true
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    record.imageData = data
                }
                isImageLoading = false
            }
        }
    }
}

#Preview {
    let record = MaintenanceRecord(tasks: ["Cleaning"])
    return NavigationStack {
        EditMaintenanceRecordView(record: record)
    }
}
