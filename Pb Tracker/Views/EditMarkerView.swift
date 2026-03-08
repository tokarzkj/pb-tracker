import SwiftUI
import SwiftData
import PhotosUI

struct EditMarkerView: View {
    @Bindable var marker: Marker
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var isShowingCamera = false
    @State private var isImageLoading = false

    var isFormValid: Bool {
        !marker.name.isEmpty && !marker.modelName.isEmpty && !isImageLoading
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Name")
                        Text("*").foregroundStyle(.red)
                        Spacer()
                        TextField("My CS3", text: $marker.name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Model")
                        Text("*").foregroundStyle(.red)
                        Spacer()
                        TextField("Planet Eclipse CS3", text: $marker.modelName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Serial Number")
                        Spacer()
                        TextField("Optional", text: Binding(
                            get: { marker.serialNumber ?? "" },
                            set: { marker.serialNumber = $0.isEmpty ? nil : $0 }
                        ))
                        .multilineTextAlignment(.trailing)
                    }
                } header: {
                    Text("Marker Details")
                }

                Section("Visuals") {
                    VStack(spacing: 16) {
                        if isImageLoading {
                            ProgressView()
                                .frame(height: 150)
                        } else if let imageData = marker.imageData, let image = Image(data: imageData) {
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
            .navigationTitle("Edit Marker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .disabled(!isFormValid)
                }
            }
            .fullScreenCover(isPresented: $isShowingCamera) {
                CameraView(capturedData: $marker.imageData)
            }
            .onChange(of: selectedItem) { oldValue, newItem in
                Task {
                    isImageLoading = true
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        marker.imageData = data
                    }
                    isImageLoading = false
                }
            }
        }
    }
}

#Preview {
    let marker = Marker(name: "My CS3", modelName: "PE CS3")
    return EditMarkerView(marker: marker)
}
