import SwiftUI
import GoodsData
import GoodsDomain
import GoodsUI
import AnalyticsAPI
import Networking
import SharedKernel

/// Единственный продукт пакета. GoodsUI, GoodsData и GoodsDomain
/// продуктами не объявлены — импортировать их извне SwiftPM не даст.
///
/// Возвращаемые типы непрозрачные (`some ViewModifier`), поэтому корню
/// не нужен `import GoodsUI`: он не знает ни одного экрана вертикали.
/// Type identity при этом сохраняется — `some` прячет тип от программиста,
/// но не от компилятора, в отличие от AnyView.
public enum GoodsAssembly {

    public static func makeRepository(client: APIClient) -> any GoodsRepository {
        RemoteGoodsRepository(client: client)
    }

    public static func makeDestinations(
        repo: any GoodsRepository,
        analytics: any AnalyticsTracking
    ) -> some ViewModifier {
        GoodsDestinations(repo: repo, analytics: analytics)
    }

    /// Вклад вертикали в строку общей ленты — пустой, и это осознанный ответ.
    ///
    /// У товаров в строке нечего вычислять: доставка, обмен и состояние —
    /// **данные**, они приезжают схемой и рисуются общим рендерером. Слот
    /// оправдан только там, где нужен код (у авто — расчёт платежа). Заполнять
    /// его ради симметрии значит заводить второй способ делать то, что уже
    /// делает схема.
    @MainActor
    public static func rowAccessory(for ref: ListingRef) -> some View {
        EmptyView()
    }
}
