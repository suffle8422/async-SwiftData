//
//  TestEntity.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation
import AsyncSwiftDataCore

struct TestEntity: IdentifiableEntityProtocol {
    let id: UUID
    let title: String
}
