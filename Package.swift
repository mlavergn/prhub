// swift-tools-version: 5.9

import Foundation
import PackageDescription

let package = Package(
    name: "PRHub",
    platforms: [
        .macOS("13.0"),
    ],
    products: [
        .executable(
            name: "prhub",
            targets: ["PRHubCLI"]
        )
    ],
    targets: [
        .executableTarget(
            name: "PRHubCLI",
            path: "Sources"
        )
    ]
)
