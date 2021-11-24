// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Reachability",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(name: "Reachability", targets: ["Reachability"])
    ],
    targets: [
        .target(name: "Reachability", path: "Sources"),
        .testTarget(name: "ReachabilityTests", dependencies: ["Reachability"], path: "Tests")
    ]
)
