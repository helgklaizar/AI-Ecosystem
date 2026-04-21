// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GravityHub",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "GravityHub",
            dependencies: [])
    ]
)
