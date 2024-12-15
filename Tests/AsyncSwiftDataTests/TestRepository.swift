//
//  TestRepository.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import SwiftData
import AsyncSwiftData

@ModelActor
actor TestRepository: AsyncSwiftDataRepositoryProtocol {
    typealias Entity = TestEntity
    typealias Model = TestModel
}
