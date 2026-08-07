import Foundation
import GoodsDomain
import NetworkingInterface
import SharedKernel

/// Реализация протокола из домена. Импортируется ровно одним таргетом — Goods.
/// GoodsUI её не видит: инверсия зависимостей.
package struct RemoteGoodsRepository: GoodsRepository {
    private let client: any HTTPPerforming

    package init(client: any HTTPPerforming) {
        self.client = client
    }

    package func listing(id: ListingID) async throws -> GoodsListing {
        _ = try? await client.get("goods/\(id.rawValue)")
        try? await Task.sleep(for: .milliseconds(150))
        return Self.Fixtures.listing(id: id)
    }
}
