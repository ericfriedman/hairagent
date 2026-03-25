// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HairAgent",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "HairAgent", targets: ["HairAgent"]),
    ],
    targets: [
        .target(
            name: "HairAgent",
            path: "HairAgent",
            exclude: ["HairAgentApp.swift"]
        ),
        .testTarget(
            name: "HairAgentTests",
            dependencies: ["HairAgent"],
            path: "HairAgentTests"
        ),
    ]
)
