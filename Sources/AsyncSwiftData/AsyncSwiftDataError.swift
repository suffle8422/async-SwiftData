//
//  AsyncSwiftDataError.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

/// SwiftDataのCRUD処理内で発生するエラー定義
public enum AsyncSwiftDataError: Error {
    /// 指定されたIDをもつEntityが見つからない
    case idNotFound
    /// 保存処理に失敗した
    case modelContextSaveFailed
}
