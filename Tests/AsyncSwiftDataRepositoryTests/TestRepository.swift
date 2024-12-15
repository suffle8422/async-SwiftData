//
//  TestRepository.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import SwiftData
import AsyncSwiftDataCore
import AsyncSwiftDataRepository

@ModelActor
actor TestRepository: AsyncSwiftDataRepositoryProtocol {
    typealias Entity = TestEntity
    typealias Model = TestModel
}
