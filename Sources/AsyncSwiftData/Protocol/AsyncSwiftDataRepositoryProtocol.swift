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

    var modelContext: ModelContext { get }

    /// 指定のIDをもつ`Entity`を返す
    /// 見つからない場合にはエラーをスローする
    /// - parameters:
    ///   - id: 取得対象のidプロパティ
    func _get(id: UUID) async throws -> Entity

    /// 保存されている全ての`Entity`を配列で返す
    func _fetchAll() async -> [Entity]

    /// `Entity`のIDと同じIDを持つPersistentModelが保存されていなければ、新規保存する
    /// 保存されていれば、内容を更新する
    /// - parameters:
    ///   - entity: 保存もしくは更新するEntity
    func _save(entity: Entity) async throws

    /// 指定のIDを持つ`Entity`を削除する
    /// - parameters:
    ///   - id: 削除対象のID
    func _delete(id: UUID) async throws
}

extension AsyncSwiftDataRepositoryProtocol where Entity == Model.Entity, Model: IdentifiableModelProtocol & EntityConvertable {
    public func _get(id: UUID) async throws -> Entity {
        guard let model = getModel(id: id) else { throw AsyncSwiftDataError.idNotFound }
        return model.makeEntity()
    }

    public func _fetchAll() async -> [Entity] {
        let fetchDescriptor = FetchDescriptor<Model>()
        let models = try? modelContext.fetch(fetchDescriptor)
        guard let models else { return [] }
        return models.map { $0.makeEntity() }
    }

    public func _save(entity: Entity) async throws {
        guard let model = getModel(id: entity.id) else {
            let model = Model(entity: entity)
            modelContext.insert(model)
            try saveModelContext()
            return
        }
        model.apply(entity: entity)
        try saveModelContext()
    }

    public func _delete(id: UUID) async throws {
        guard let model = getModel(id: id) else {
            throw AsyncSwiftDataError.idNotFound
        }
        modelContext.delete(model)
        try saveModelContext()
    }

    private func getModel(id: UUID) -> Model? {
        let fetchDescriptor = FetchDescriptor<Model>(
            predicate: #Predicate { $0.id == id }
        )
        let model = try? modelContext.fetch(fetchDescriptor).first
        return model
    }

    private func saveModelContext() throws {
        do {
            try modelContext.save()
            return
        } catch {
            throw AsyncSwiftDataError.modelContextSaveFailed
        }
    }
}
