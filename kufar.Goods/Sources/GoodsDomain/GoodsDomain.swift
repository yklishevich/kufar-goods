import Foundation
import SharedKernel

/// Домен вертикали: модель и ПРОТОКОЛЫ репозиториев.
/// Реализации — в GoodsData, и GoodsUI о них не знает.
///
/// Слоя юзкейсов здесь нет намеренно (раздел 7 документа): вью-модель
/// зовёт репозиторий напрямую. Обёртка с единственным execute() добавила бы
/// файл, тест и точку правки, не добавив ни одного решения. Появится
/// настоящая оркестрация — она ляжет сюда, не тронув ни UI, ни Data.

public struct GoodsListing: Identifiable, Hashable, Sendable {
    public let id: ListingID
    public let title: String
    public let price: Money
    public let photoCount: Int
    public let seller: Seller
    public let isPromoted: Bool
    /// Атрибуты приходят с бэка схемой — это данные, а не код.
    /// В демо описаны JSON-ом, чтобы показать декодирование с фолбэком.
    public let attributesJSON: Data
    public let deliveryAvailable: Bool
    public let exchangeAccepted: Bool

    public init(
        id: ListingID,
        title: String,
        price: Money,
        photoCount: Int,
        seller: Seller,
        isPromoted: Bool,
        attributesJSON: Data,
        deliveryAvailable: Bool,
        exchangeAccepted: Bool
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.photoCount = photoCount
        self.seller = seller
        self.isPromoted = isPromoted
        self.attributesJSON = attributesJSON
        self.deliveryAvailable = deliveryAvailable
        self.exchangeAccepted = exchangeAccepted
    }
}

/// Вертикаль отвечает за карточку и свой домен. Ленты у неё нет:
/// лента общая и живёт в поиске, потому что вертикаль в ней выбирается
/// категорией фильтра, а не вкладкой.
public protocol GoodsRepository: Sendable {
    func listing(id: ListingID) async throws -> GoodsListing
}
