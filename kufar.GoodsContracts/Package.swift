// swift-tools-version: 5.9
import PackageDescription

// Маршруты и публичные модели вертикали «Товары».

let package = Package(
    name: "KufarGoodsContracts",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "GoodsInterface", targets: ["GoodsInterface"])
    ],
    dependencies: [
        .package(id: "kufar.Foundation", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "GoodsInterface",
            dependencies: [
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        )
    ]
)
