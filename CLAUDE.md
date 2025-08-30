# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

このプロジェクトはAsyncSwiftDataという、SwiftDataを`ModelActor`を通じてBackground Threadで利用するためのSwift Packageです。iOS 17以上をサポートし、SwiftDataの永続化データをactor境界を跨いで安全に操作するためのProtocolベースのアーキテクチャを提供します。

## 開発コマンド

### テスト実行
```bash
# XcodeBuildMCPを使用してテストを実行
swift test
```

### パッケージのビルド
```bash
# パッケージをビルド
swift build
```

## アーキテクチャ

### プロトコル設計
以下の3つのProtocolが連携してSwiftDataの安全なasync操作を実現:

1. **IdentifiableEntityProtocol**: actor境界を跨げるSendable構造体
2. **IdentifiableModelProtocol**: PersistentModelのIDプロパティ要件
3. **EntityConvertable**: ModelとEntity間の変換処理
4. **AsyncSwiftDataRepositoryProtocol**: 実際のCRUD操作を提供

### Repository実装パターン
`@ModelActor`アクターでRepositoryを作成し、以下のメソッドが自動実装:
- `_get(id: UUID)`: ID指定取得
- `_fetchAll()`: 全件取得
- `_fetch(fetchDescriptor:)`: 条件検索
- `_save(entity:)`: 新規/更新保存
- `_delete(id: UUID)`: 削除

### テスト構造
- Swift Testingフレームワークを使用
- 全テストが`actor AsyncSwiftDataRepositoryTests`内で実装
- インメモリModelContainerによる隔離されたテスト環境
- テスト用のTestModel/TestEntity/TestRepositoryを使用

### 主要制約
- IDプロパティは`@Attribute(.unique)`で一意性を保つ必要
- ModelとEntityは同じIDを共有してデータ整合性を維持
- `hasChanges`チェックによる無駄なsave処理の回避

## ファイル構成

```
Sources/AsyncSwiftData/
├── AsyncSwiftDataError.swift          # エラー定義
└── Protocol/
    ├── AsyncSwiftDataRepositoryProtocol.swift  # メインRepository Protocol
    ├── EntityConvertable.swift                 # Model⇔Entity変換
    ├── IdentifiableEntityProtocol.swift        # Sendable Entity要件
    └── IdentifiableModelProtocol.swift         # Model ID要件

Tests/AsyncSwiftDataTests/
├── AsyncSwiftDataRepositoryTests.swift # メインテスト
├── TestEntity.swift                    # テスト用Entity
├── TestModel.swift                     # テスト用Model
└── TestRepository.swift                # テスト用Repository
```