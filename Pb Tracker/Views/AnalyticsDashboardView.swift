import SwiftUI
import SwiftData

struct AnalyticsDashboardView: View {
    @Query private var markers: [Marker]
    @Query private var sessions: [Session]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Section {
                        LazyVGrid(columns: columns, spacing: 16) {
                            StatView(title: "Markers", value: "\(markers.count)", icon: "scope", color: .blue)
                            StatView(title: "Shots", value: "\(totalLifetimeShots)", icon: "bolt.fill", color: .orange)
                            StatView(title: "Sessions", value: "\(sessions.count)", icon: "flag.checkered", color: .green)
                            StatView(title: "Avg K/D", value: String(format: "%.2f", averageKDRatio), icon: "scalemass", color: .purple)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    } header: {
                        HStack {
                            Text("Overview")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)

                    Section {
                        VStack(spacing: 12) {
                            let sortedMarkers = markers.sorted(by: { $0.totalLifetimeShots > $1.totalLifetimeShots })
                            let maxShots = Double(sortedMarkers.first?.totalLifetimeShots ?? 1)
                            
                            ForEach(sortedMarkers) { marker in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(marker.name)
                                            .font(.subheadline)
                                            .bold()
                                        Spacer()
                                        Text("\(marker.totalLifetimeShots)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    GeometryReader { geo in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.secondary.opacity(0.1))
                                                .frame(height: 8)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.blue.gradient)
                                                .frame(width: geo.size.width * CGFloat(Double(marker.totalLifetimeShots) / maxShots), height: 8)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    } header: {
                        HStack {
                            Text("Usage by Marker")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Analytics")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var totalLifetimeShots: Int {
        markers.reduce(0) { $0 + $1.totalLifetimeShots }
    }
    
    private var averageKDRatio: Double {
        guard !markers.isEmpty else { return 0 }
        let totalKD = markers.reduce(0.0) { $0 + $1.kdRatio }
        return totalKD / Double(markers.count)
    }
}

#Preview {
    AnalyticsDashboardView()
        .modelContainer(for: [Marker.self, Session.self, Outing.self], inMemory: true)
}
