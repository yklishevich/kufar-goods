import SwiftUI
import Observation
import GoodsDomain
import GoodsInterface
import SearchInterface
import ProfileInterface
import AnalyticsAPI
import Navigation
import SchemaKit
import ListingKit
import DesignComponents
import DesignTokens
import SharedKernel

@MainActor
@Observable
final class GoodsDetailModel {
    private let repo: any GoodsRepository
    private let analytics: any AnalyticsTracking

    let id: ListingID
    private(set) var state: LoadState<GoodsListing> = .loading
    private(set) var attributes: [SchemaField] = []

    init(id: ListingID, repo: any GoodsRepository, analytics: any AnalyticsTracking) {
        self.id = id
        self.repo = repo
        self.analytics = analytics
    }

    func load() async {
        // Ретрай после ошибки начинается с .loading, иначе заглушка останется на экране.
        state = .loading
        do {
            let loaded = try await repo.listing(id: id)
            // Схема атрибутов — вторичный контент: её поломка деградирует один блок,
            // а не роняет карточку. Но деградация не молчит — событие уходит в мониторинг.
            // Неизвестный тип отдельного поля — не ошибка: он станет .unknown и будет скрыт.
            do {
                attributes = try JSONDecoder().decode([SchemaField].self, from: loaded.attributesJSON)
            } catch {
                attributes = []
                analytics.track(.schemaDecodeFailed(id: id, vertical: .goods))
            }
            state = .loaded(loaded)
            analytics.track(.listingOpened(id: id, vertical: .goods))
        } catch {
            // Ошибка — состояние экрана, а не guard return:
            // вечный спиннер хуже честного «не получилось».
            state = .failed
        }
    }

    func contactTapped() {
        analytics.track(.contactRequested(id: id))
    }
}

struct GoodsDetailScreen: View {
    @Environment(Router.self) private var router
    @State private var model: GoodsDetailModel

    init(id: ListingID, repo: any GoodsRepository, analytics: any AnalyticsTracking) {
        _model = State(wrappedValue: GoodsDetailModel(id: id, repo: repo, analytics: analytics))
    }

    var body: some View {
        // switch по LoadState — _ConditionalContent, ветки сохраняют identity.
        // .task висит на контейнере и стреляет один раз при появлении экрана;
        // ретрай зовёт load() явно — иначе смена ветки запускала бы её повторно.
        content
            .task { await model.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch model.state {
        case .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let listing):
            card(for: listing)
        case .failed:
            ErrorStateView(message: "Не удалось загрузить объявление") {
                Task { await model.load() }
            }
        }
    }

    private func card(for listing: GoodsListing) -> some View {
        ListingDetailScaffold(
            header: ListingHeader(
                id: listing.id,
                title: listing.title,
                price: listing.price,
                photoCount: listing.photoCount,
                seller: listing.seller,
                isPromoted: listing.isPromoted
            ),
            onSellerTap: {
                // Переход в чужую фичу: знаем КУДА идти, не знаем ЧТО нарисуется.
                router.push(ProfileRoute.profile(listing.seller.id))
            },
            onContact: { model.contactTapped() },
            attributes: {
                SchemaSection(fields: model.attributes)
            },
            extras: {
                GoodsShippingCard(
                    delivery: listing.deliveryAvailable,
                    exchange: listing.exchangeAccepted
                )
                // «Другие объявления продавца» — это поисковый запрос,
                // а не экран вертикали: у продавца бывают и товары, и авто.
                // Поэтому Goods про Auto по-прежнему ничего не знает.
                Button {
                    router.push(SearchRoute.sellerListings(listing.seller.id))
                } label: {
                    SectionCard {
                        HStack {
                            Text("Другие объявления продавца").font(Typography.title)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Palette.secondaryText)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        )
    }
}

struct GoodsShippingCard: View {
    let delivery: Bool
    let exchange: Bool

    var body: some View {
        SectionCard {
            Text("Доставка и обмен").font(Typography.title)
            LabeledRow(title: "Доставка", value: delivery ? "Есть" : "Нет")
            LabeledRow(title: "Обмен", value: exchange ? "Рассмотрю" : "Нет")
        }
    }
}
