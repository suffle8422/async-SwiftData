//
//  TestModel.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation
import SwiftData
import AsyncSwiftData

@Model
final class TestModel: IdentifiableModelProtocol {
    @Attribute(.unique)
    var id: UUID

    var title: String

    init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}

extension TestModel: EntityConvertable {
    typealias Entity = TestEntity

    convenience init(entity: TestEntity) {
        self.init(id: entity.id, title: entity.title)
    }
    
    func makeEntity() -> TestEntity {
        TestEntity(id: id, title: title)
    }
    
    func apply(entity: TestEntity) {
        title = entity.title
    }
}
