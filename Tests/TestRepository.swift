//
//  TestRepository.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import SwiftData
import Core

@ModelActor
actor TestRepository: AsyncSwiftDataRepositoryProtocol {
    typealias Entity = TestEntity
    typealias Model = TestModel
}
