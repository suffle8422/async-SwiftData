//
//  IdentifiableModelProtocol.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation

/// SwiftDataで保存さえれるPersitent Modelを示すProtocol
/// `id`プロパティを持つ`
public protocol IdentifiableModelProtocol {
    associatedtype Entity: IdentifiableEntityProtocol
    
    var id: UUID { get }
}
