//
//  EntityConvertable.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import AsyncSwiftDataCore

/// PersistentModelと対応するEnitiyと違いに変換可能であることを示すProtocol
public protocol EntityConvertable {
    associatedtype Entity: IdentifiableEntityProtocol

    /// `Entity`から対応するPersistentModelを作成する
    /// - parameters:
    ///   - entity: PersistentModelの生成に利用する`Entity`
    init(entity: Entity)

    /// PersistentModelから対応する`Entity`を生成する
    func makeEntity() -> Entity

    /// `Entity`と同様のIDを持つPersistentModelの内容を更新する
    func apply(entity: Entity)
}
