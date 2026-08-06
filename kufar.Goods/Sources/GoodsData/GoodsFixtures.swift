import Foundation
import GoodsDomain
import SharedKernel

/// Данные вместо сети. Живут в Data-слое: UI о них не знает,
/// подмена на настоящий бэкенд не трогает ни один экран.
extension RemoteGoodsRepository {
    enum Fixtures {
        static let seller = Seller(id: "u-77", name: "Ирина", rating: 4.8, isCompany: false)

        /// Схема атрибутов с бэка. Последнее поле — неизвестного типа:
        /// так проверяется фолбэк, который иначе роняет старые сборки.
        static let attributes = Data("""
        [
          { "id": "state",    "title": "Состояние",   "type": "text",   "value": "Б/у, отличное" },
          { "id": "brand",    "title": "Бренд",       "type": "reference", "value": "Bosch" },
          { "id": "power",    "title": "Мощность",    "type": "number", "value": 750, "unit": "Вт" },
          { "id": "warranty", "title": "Гарантия",    "type": "toggle", "value": true },
          { "id": "eco",      "title": "Эко-рейтинг", "type": "gauge",  "value": 7 }
        ]
        """.utf8)

        static func listing(id: ListingID) -> GoodsListing {
            GoodsListing(
                id: id,
                title: "Пылесос Bosch, почти новый",
                price: Money(amount: 190),
                photoCount: 4,
                seller: seller,
                isPromoted: true,
                attributesJSON: attributes,
                deliveryAvailable: true,
                exchangeAccepted: false
            )
        }
    }
}
