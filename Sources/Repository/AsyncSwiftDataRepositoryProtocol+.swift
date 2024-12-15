//
//  AsyncSwiftDataRepositoryProtocol+.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation
import SwiftData
import Core

extension AsyncSwiftDataRepositoryProtocol where Entity == Model.Entity, Model: IdentifiableModelProtocol & EntityConvertable {
    nonisolated var modelContext: ModelContext { modelContext }

    public func get(id: UUID) async throws -> Entity {
           guard let model = getModel(id: id) else { throw AsyncSwiftDataError.idNotFound }
           return model.makeEntity()
       }
   
       public func fetchAll() async -> [Entity] {
           let fetchDescriptor = FetchDescriptor<Model>()
           let models = try? modelContext.fetch(fetchDescriptor)
           guard let models else { return [] }
           return models.map { $0.makeEntity() }
       }
   
       public func save(entity: Entity) async throws {
           guard let model = getModel(id: entity.id) else {
               let model = Model(entity: entity)
               modelContext.insert(model)
               try saveModelContext()
               return
           }
           model.apply(entity: entity)
           try saveModelContext()
       }
   
       public func delete(id: UUID) async throws {
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
