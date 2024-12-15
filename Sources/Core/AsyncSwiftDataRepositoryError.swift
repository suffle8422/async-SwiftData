//
//  AsyncSwiftDataRepositoryError.swift
//  AsyncSwiftData
//
//  Created by ionishi on 2024/12/15.
//

public enum AsyncSwiftDataRepositoryError: Error {
    /// 指定されたIDをもつEntityが見つからない
    case notFoundIDError
    /// すでに存在するIDでinsertが実行された
    case insertDuplicationError
    /// 保存処理に失敗した
    case modelContextSaveFailed
}
