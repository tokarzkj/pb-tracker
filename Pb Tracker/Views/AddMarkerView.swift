import SwiftUI
import SwiftData
import PhotosUI

struct AddMarkerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var modelName = ""
    @State private var serialNumber = ""
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isImageLoading = false
    @State private var imageError: String?
    @State private var isShowingCamera = false

    var isFormValid: Bool {
        !name.isEmpty && !modelName.isEmpty && !isImageLoading
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Name")
                        Text("*").foregroundStyle(.red)
                        Spacer()
                        TextField("My CS3", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Model")
                        Text("*").foregroundStyle(.red)
                        Spacer()
                        TextField("Planet Eclipse CS3", text: $modelName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Serial Number")
                        Spacer()
                        TextField("Optional", text: $serialNumber)
                            .multilineTextAlignment(.trailing)
                    }
                } header: {
                    Text("Basic Info")
                }

                Section {
                    VStack(spacing: 16) {
                        HStack {
                            if isImageLoading {
                                ProgressView()
                                    .frame(width: 80, height: 80)
                            } else if let imageData, let image = Image(data: imageData) {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                Image(systemName: "camera")
                                    .font(.title)
                                    .frame(width: 80, height: 80)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .foregroundStyle(.blue)
                            }
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
                    
                    .onChange(of: selectedItem) { _, newItem in
                        Task {
                            isImageLoading = true
                            imageError = nil
                            do {
                                if let data = try await newItem?.loadTransferable(type: Data.self) {
                                    imageData = data
                                }
                            } catch {
                                imageError = "Failed to load image."
                            }
                            isImageLoading = false
                        }
                    }
                    
                    if let imageError {
                        Text(imageError)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                } header: {
                    Text("Visuals")
                }
            }
            .fullScreenCover(isPresented: $isShowingCamera) {
                CameraView(capturedData: $imageData)
            }
            .navigationTitle("New Marker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMarker()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }

    private func saveMarker() {
        let newMarker = Marker(
            name: name,
            modelName: modelName,
            serialNumber: serialNumber.isEmpty ? nil : serialNumber,
            imageData: imageData
        )
        
        modelContext.insert(newMarker)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save marker: \(error.localizedDescription)")
            // In a real app, we'd show an alert here.
        }
    }
}

#Preview {
    AddMarkerView()
        .modelContainer(for: Marker.self, inMemory: true)
}
