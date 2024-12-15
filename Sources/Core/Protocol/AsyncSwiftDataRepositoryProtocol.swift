//
//  AsyncSwiftDataRepositoryProtocol.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation
import SwiftData

public protocol AsyncSwiftDataRepositoryProtocol: Actor {
    associatedtype Entity: IdentifiableEntityProtocol
    associatedtype Model: PersistentModel

    nonisolated var modelContext: ModelContext { get }

    /// 指定のIDをもつ`Entity`を返す
    /// 見つからない場合にはエラーをスローする
    /// - parameters:
    ///   - id: 取得対象のidプロパティ
    func get(id: UUID) async throws -> Entity

    /// 保存されている全ての`Entity`を配列で返す
    func fetchAll() async -> [Entity]

    /// `Entity`のIDと同じIDを持つPersistentModelが保存されていなければ、新規保存する
    /// 保存されていれば、内容を更新する
    /// - parameters:
    ///   - entity: 保存もしくは更新するEntity
    func save(entity: Entity) async throws

    /// 指定のIDを持つ`Entity`を削除する
    /// - parameters:
    ///   - id: 削除対象のID
    func delete(id: UUID) async throws
}
