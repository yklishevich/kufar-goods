import SwiftUI
import GoodsDomain
import GoodsInterface
import AnalyticsAPI
import SharedKernel

/// ViewModifier, а не фабрика с AnyView — намеренно.
/// navigationDestination строит ветки статически, switch даёт
/// _ConditionalContent, type identity сохраняется, стирания нет нигде.
///
/// Дефолтных аргументов в init нет: `repo: = RemoteGoodsRepository(client: .live)`
/// заставил бы фичу знать продовый эндпоинт, а в превью дал бы живую сеть
/// при забытом аргументе. Репозиторий приходит из композиционного корня.
package struct GoodsDestinations: ViewModifier {
    private let repo: any GoodsRepository
    private let analytics: any AnalyticsTracking

    package init(repo: any GoodsRepository, analytics: any AnalyticsTracking) {
        self.repo = repo
        self.analytics = analytics
    }

    package func body(content: Content) -> some View {
        content.navigationDestination(for: GoodsRoute.self) { route in
            switch route {
            case .details(let id):
                GoodsDetailScreen(id: id, repo: repo, analytics: analytics)
            }
        }
    }
}
