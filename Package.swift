// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PBTracker",
    platforms: [
        .iOS("26.0")
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
