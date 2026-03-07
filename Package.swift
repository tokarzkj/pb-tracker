// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PBTracker",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .executable(name: "PBTracker", targets: ["PBTracker"])
    ],
    targets: [
        .executableTarget(
            name: "PBTracker",
            path: "Sources/PBTracker"
        ),
        .testTarget(
            name: "PBTrackerTests",
            dependencies: ["PBTracker"]
        ),
    ]
)
