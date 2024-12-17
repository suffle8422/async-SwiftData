//
//  AsyncSwiftDataRepositoryTests.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation
import Testing
import SwiftData
import AsyncSwiftData

actor AsyncSwiftDataRepositoryTests {
    let modelContainer: ModelContainer
    let testRepository: TestRepository

    init() {
        let schema = Schema([TestModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(for: schema, configurations: modelConfiguration)

        testRepository = TestRepository(modelContainer: modelContainer)
    }

    @Test("idに対応するModelが保存されているとき")
    func get_success() async throws {
        let id = UUID()
        let title = "テストタイトル"
        let model = TestModel(id: id, title: title)
        try await testRepository.insertModelForTests(model: model)
        #expect(await testRepository._fetchAll().count == 1)

        let targetEntity = try await testRepository._get(id: id)

        #expect(targetEntity.id == id)
        #expect(targetEntity.title == title)
    }

    @Test("idに対応するModelが保存されていないとき")
    func get_failure() async throws {
        #expect(await testRepository._fetchAll().count == 0)

        await #expect(throws: AsyncSwiftDataError.idNotFound) {
            try await testRepository._get(id: UUID())
        }
    }

    @Test
    func fetchAll() async throws {
        for index in 1...10 {
            let testModel = TestModel(
                id: UUID(),
                title: "テストタイトル\(index)"
            )
            try await testRepository.insertModelForTests(model: testModel)
        }
        #expect(await testRepository._fetchAll().count == 10)
    }

    @Test("新規保存")
    func save_insert() async throws {
        #expect(await testRepository._fetchAll().count == 0)

        let id = UUID()
        let title = "テストタイトル"
        let entity = TestEntity(id: id, title: title)

        try await testRepository._save(entity: entity)

        #expect(await testRepository._fetchAll().count == 1)

        let targetEntity = try await testRepository._get(id: id)
        #expect(targetEntity.id == id)
        #expect(targetEntity.title == title)
    }

    @Test("更新時")
    func save_update() async throws {
        let id = UUID()
        let title = "テストタイトル"
        let model = TestModel(id: id, title: title)
        try await testRepository.insertModelForTests(model: model)
        #expect(await testRepository._fetchAll().count == 1)

        let updatedTitle = "テストタイトル2"
        let entity = TestEntity(id: id, title: updatedTitle)
        try await testRepository._save(entity: entity)

        #expect(await testRepository._fetchAll().count == 1)

        let targetEntity = try await testRepository._get(id: id)
        #expect(targetEntity.id == id)
        #expect(targetEntity.title == updatedTitle)
    }

    @Test
    func delete() async throws {
        let id = UUID()
        let title = "テストタイトル"
        let model = TestModel(id: id, title: title)
        try await testRepository.insertModelForTests(model: model)
        #expect(await testRepository._fetchAll().count == 1)

        try await testRepository._delete(id: id)
        #expect(await testRepository._fetchAll().count == 0)
    }

}

private extension TestRepository {
    func insertModelForTests(model: TestModel) throws {
        modelContext.insert(model)
        try modelContext.save()
    }
}
