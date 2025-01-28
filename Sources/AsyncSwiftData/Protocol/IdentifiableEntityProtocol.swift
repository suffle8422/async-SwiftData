//
//  IdentifiableEntityProtocol.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation

/// アクターを超えるためにPersistent Modelから変換されるEntityを示すProtocol
/// `id`プロパティを持つ`
/// AsyncSwiftDataとのやり取りには全てこのProtocolに準拠した型でおこなう
public protocol IdentifiableEntityProtocol: Sendable {
    var id: UUID { get }
}
