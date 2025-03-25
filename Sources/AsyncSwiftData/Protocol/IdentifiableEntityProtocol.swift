//
//  IdentifiableEntityProtocol.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

import Foundation

/// アクター境界を超えるためにPersistent Modelから変換されるEntityを示すProtocol
/// `id`プロパティはプライマリーキーの役割を果たすため一意な値を取るようにする
/// AsyncSwiftDataとのやり取りには全てこのProtocolに準拠した型でおこなう
public protocol IdentifiableEntityProtocol: Sendable {
    var id: UUID { get }
}
