//
//  AsyncSwiftDataRepositoryTests.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation
import Testing
import SwiftData
import Core
import Repository

actor AsyncSwiftDataRepositoryTests {
    let modelContainer: ModelContainer
    let testRepository: AsyncSwiftDataRepository<TestModel, TestEntity>

    init() {
        let schema = Schema([TestModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(for: schema, configurations: modelConfiguration)

        testRepository = AsyncSwiftDataRepository<TestModel, TestEntity>(modelContainer: modelContainer)
    }

    @Test("idに対応するModelが保存されているとき")
    func get_success() async throws {
        let id = UUID()
        let title = "テストタイトル"
        let model = TestModel(id: id, title: title)
        try testRepository.insertModelForTests(model: model)
        #expect(await testRepository.fetchAll().count == 1)

        let targetEntity = try await testRepository.get(id: id)

        #expect(targetEntity.id == id)
        #expect(targetEntity.title == title)
    }

    @Test("idに対応するModelが保存されていないとき")
    func get_failure() async throws {
        #expect(await testRepository.fetchAll().count == 0)

        await #expect(throws: AsyncSwiftDataRepositoryError.notFoundIDError) {
            try await testRepository.get(id: UUID())
        }
    }

    @Test
    func fetchAll() async throws {
        for index in 1...10 {
            let testModel = TestModel(
                id: UUID(),
                title: "テストタイトル\(index)"
            )
            try testRepository.insertModelForTests(model: testModel)
        }
        #expect(await testRepository.fetchAll().count == 10)
    }

    @Test("新規保存")
    func save_insert() async throws {
        #expect(await testRepository.fetchAll().count == 0)

        let id = UUID()
        let title = "テストタイトル"
        let entity = TestEntity(id: id, title: title)

        try await testRepository.save(entity: entity)

        #expect(await testRepository.fetchAll().count == 1)

        let targetEntity = try await testRepository.get(id: id)
        #expect(targetEntity.id == id)
        #expect(targetEntity.title == title)
    }

    @Test("更新時")
    func save_update() async throws {
        let id = UUID()
        let title = "テストタイトル"
        let model = TestModel(id: id, title: title)
        try testRepository.insertModelForTests(model: model)
        #expect(await testRepository.fetchAll().count == 1)

        let updatedTitle = "テストタイトル2"
        let entity = TestEntity(id: id, title: updatedTitle)
        try await testRepository.save(entity: entity)

        #expect(await testRepository.fetchAll().count == 1)

        let targetEntity = try await testRepository.get(id: id)
        #expect(targetEntity.id == id)
        #expect(targetEntity.title == updatedTitle)
    }

    @Test
    func delete() async throws {
        let id = UUID()
        let title = "テストタイトル"
        let model = TestModel(id: id, title: title)
        try testRepository.insertModelForTests(model: model)
        #expect(await testRepository.fetchAll().count == 1)

        try await testRepository.delete(id: id)
        #expect(await testRepository.fetchAll().count == 0)
    }
}

private extension AsyncSwiftDataRepository {
    nonisolated func insertModelForTests(model: TestModel) throws {
        let modelContext = modelExecutor.modelContext
        modelContext.insert(model)
        try modelContext.save()
    }
}
