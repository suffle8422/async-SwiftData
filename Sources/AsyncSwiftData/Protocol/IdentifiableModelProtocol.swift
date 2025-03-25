//
//  IdentifiableModelProtocol.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation

/// SwiftDataで保存れるPersistent Modelを示すProtocol
/// `id`プロパティはプライマリーキーの役割を果たすため一意な値を取るようにする
public protocol IdentifiableModelProtocol {
    associatedtype Entity: IdentifiableEntityProtocol
    
    var id: UUID { get }
}
