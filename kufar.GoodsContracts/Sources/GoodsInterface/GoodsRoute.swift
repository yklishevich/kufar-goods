import Foundation
import SharedKernel

/// Весь публичный API вертикали для внешнего мира — enum маршрутов.
/// Ни View, ни AnyView, ни import SwiftUI.
///
/// Ленты здесь нет: она общая и живёт в поиске. Вертикаль отвечает
/// только за карточку объявления.
public enum GoodsRoute: Hashable, Codable, Sendable, CaseIterable {
    case details(ListingID)

    public static var allCases: [GoodsRoute] {
        [.details(ListingID("sample"))]
    }
}
