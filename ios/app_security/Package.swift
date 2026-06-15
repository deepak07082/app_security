// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "app_security",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "app-security", targets: ["app_security"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "app_security",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)