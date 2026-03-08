import SwiftUI
import SwiftData

struct MarkerListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Marker.name) private var markers: [Marker]
    @State private var isShowingAddMarkerSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                MeshGradient(width: 3, height: 3, points: [
                    [0, 0], [0.5, 0], [1, 0],
                    [0, 0.5], [0.5, 0.5], [1, 0.5],
                    [0, 1], [0.5, 1], [1, 1]
                ], colors: [
                    .blue.opacity(0.1), .blue.opacity(0.2), .indigo.opacity(0.1),
                    .cyan.opacity(0.2), .blue.opacity(0.1), .indigo.opacity(0.2),
                    .indigo.opacity(0.1), .cyan.opacity(0.2), .blue.opacity(0.1)
                ])
                .ignoresSafeArea()

                List {
                    if markers.isEmpty {
                        ContentUnavailableView {
                            Label("No Markers Found", systemImage: "plus.circle")
                        } description: {
                            Text("Add your first marker to start tracking maintenance.")
                        } actions: {
                            Button("Add Marker") {
                                isShowingAddMarkerSheet = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .listRowBackground(Color.clear)
                    } else {
                        ForEach(markers) { marker in
                            NavigationLink {
                                MarkerDetailView(marker: marker)
                            } label: {
                                MarkerRowView(marker: marker)
                            }
                            .listRowBackground(Color.white.opacity(0.4).glassEffect())
                        }
                        .onDelete(perform: deleteMarkers)
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Your Markers")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { isShowingAddMarkerSheet = true }) {
                            Label("Add Marker", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isShowingAddMarkerSheet) {
                    AddMarkerView()
                        .presentationDetents([.fraction(0.7), .large])
                        .presentationSizing(.form)
                }
            }
        }
    }

    private func deleteMarkers(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(markers[index])
        }
    }
}

#Preview {
    MarkerListView()
        .modelContainer(for: Marker.self, inMemory: true)
}
