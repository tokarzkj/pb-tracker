import SwiftUI

struct ContentView: View {
    @State private var pbs: [PersonalBest] = PersonalBest.examples
    @State private var isShowingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(pbs) { pb in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(pb.name)
                                .font(.headline)
                            Text(pb.category)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(pb.value, specifier: "%.1f") \(pb.unit)")
                                .font(.system(.body, design: .monospaced))
                                .bold()
                            Text(pb.date, style: .date)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete { indexSet in
                    pbs.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("PB Tracker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { isShowingAddSheet = true }) {
                        Label("Add PB", systemImage: "plus")
                    }
                }
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                #endif
            }
        }
    }
}

#Preview {
    ContentView()
}
