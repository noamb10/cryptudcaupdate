// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "MyProject",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]),
        .executable(
            name: "MyExecutable",
            targets: ["MyExecutable"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.5.4"),
    ],
    targets: [
        .target(
            name: "MyLibrary",
            dependencies: [
                "Alamofire",
            ],
            path: "Sources/MyLibrary"
        ),
        .target(
            name: "MyExecutable",
            dependencies: [
                "MyLibrary",
            ],
            path: "Sources/MyExecutable"
        ),
        .testTarget(
            name: "MyLibraryTests",
            dependencies: ["MyLibrary"],
            path: "Tests/MyLibraryTests"
        ),
    ]
)
