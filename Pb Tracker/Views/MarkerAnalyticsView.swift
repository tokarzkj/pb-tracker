import SwiftUI
import SwiftData
import Charts

struct MarkerAnalyticsView: View {
    let marker: Marker
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Summary Header
                HStack(spacing: 40) {
                    StatView(title: "Lifetime", value: "\(marker.totalLifetimeShots)", icon: "bolt.fill", color: .orange)
                    StatView(title: "Outings", value: "\(marker.outings.count)", icon: "flag.checkered", color: .green)
                    StatView(title: "Kills", value: "\(totalKills)", icon: "target", color: .red)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.secondary.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)

                // Ratios Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Performance Ratios")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Label("Avg Eliminations", systemImage: "target")
                            Spacer()
                            Text(String(format: "%.1f", marker.averageEliminations))
                                .bold()
                        }
                        Divider()
                        HStack {
                            Label("K/D Ratio", systemImage: "scalemass")
                            Spacer()
                            Text(String(format: "%.2f", marker.kdRatio))
                                .bold()
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                }

                // Trend Section
                if !marker.outings.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Shot Trend (Last 5 Outings)")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Chart {
                            let trendOutings = marker.outings.sorted(by: { $0.session?.date ?? .distantPast < $1.session?.date ?? .distantPast }).suffix(5)
                            ForEach(trendOutings) { outing in
                                BarMark(
                                    x: .value("Date", outing.session?.date ?? Date(), unit: .day),
                                    y: .value("Shots", outing.shotsFired)
                                )
                                .foregroundStyle(Color.orange.gradient)
                                .accessibilityLabel("\(outing.session?.date.formatted(date: .abbreviated, time: .omitted) ?? ""): \(outing.shotsFired) shots")
                            }
                        }
                        .frame(height: 200)
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day))
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("\(marker.name) Stats")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
    
    private var totalKills: Int {
        marker.outings.reduce(0) { $0 + $1.eliminations }
    }
}

#Preview {
    let marker = Marker(name: "My CS3")
    return NavigationStack {
        MarkerAnalyticsView(marker: marker)
    }
}
