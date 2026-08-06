// swift-tools-version: 5.9
import PackageDescription

// Вертикаль владеет карточкой объявления и своим доменом.
// Ленты у неё больше нет: лента общая и живёт в поиске.

let package = Package(
    name: "KufarGoods",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "Goods", targets: ["Goods"])
    ],
    dependencies: [
        .package(id: "kufar.GoodsContracts", from: "1.0.0"),
        .package(id: "kufar.SearchContracts", from: "1.0.0"),
        .package(id: "kufar.IdentityContracts", from: "1.0.0"),
        .package(id: "kufar.Foundation", from: "1.0.0"),
        .package(id: "kufar.Navigation", from: "1.0.0"),
        .package(id: "kufar.Analytics", from: "1.0.0"),
        .package(id: "kufar.DesignTokens", from: "1.0.0"),
        .package(id: "kufar.DesignComponents", from: "1.0.0"),
        .package(id: "kufar.SchemaKit", from: "1.0.0"),
        .package(id: "kufar.ListingKit", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "GoodsDomain",
            dependencies: [
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        ),
        .target(
            name: "GoodsData",
            dependencies: [
                "GoodsDomain",
                .product(name: "Networking", package: "kufar.Foundation"),
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        ),
        .target(
            name: "GoodsUI",
            dependencies: [
                "GoodsDomain",
                .product(name: "GoodsInterface", package: "kufar.GoodsContracts"),
                .product(name: "SearchInterface", package: "kufar.SearchContracts"),
                .product(name: "ProfileInterface", package: "kufar.IdentityContracts"),
                .product(name: "Navigation", package: "kufar.Navigation"),
                .product(name: "DesignTokens", package: "kufar.DesignTokens"),
                .product(name: "DesignComponents", package: "kufar.DesignComponents"),
                .product(name: "SchemaKit", package: "kufar.SchemaKit"),
                .product(name: "ListingKit", package: "kufar.ListingKit"),
                .product(name: "AnalyticsAPI", package: "kufar.Analytics"),
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        ),
        .target(
            name: "Goods",
            dependencies: [
                "GoodsUI",
                "GoodsData",
                "GoodsDomain",
                .product(name: "AnalyticsAPI", package: "kufar.Analytics"),
                .product(name: "Networking", package: "kufar.Foundation"),
                // ListingRef в сигнатуре rowAccessory(for:).
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        )
    ]
)
