# AsyncSwiftData

## about AsyncSwiftData
AsyncSwiftDataは、`ModelActor`を利用してSwiftDataの利用をBackgroundThreadで利用するためのライブラリです。

## Installation
SwiftPackageManagerよりインストールしてください。
Package.swiftファイルからインストールする場合には以下のように設定をお願いします。
```Swift
let package = Package(
    name: "SomeProduct",
    products: [
        .library(name: "SomeProduct", targets: ["SomeProduct"])
    ],
    dependencies: [
        .package(url: "https://github.com/suffle8422/async-SwiftData.git", exact: "0.1.0")
    ],
    targets: [
        .target(
            name: "SomeProduct",
            dependencies: [
                .product(name: "AsyncSwiftData", package: "async-SwiftData")
            ]
        )
    ]
)
```

## Useage
1. `IdentifiableEntityProtocol`を継承したEntityを作成する。
`PersistentModel`は`Sendable`でないため、`IdentifiableEntityProtocol`を継承した構造体でアクター境界を超えます
```Swift
struct SampleEntity: IdentifiableEntityProtocol {
    let id: UUID
    let title: String
}
```

2. `IdentifiableModelProtocol`と、`EntityConvertable`を継承した`PersistentModel`を作成する
> [!IMPORTANT]
> `IdentifiableModelProtocl`の`id`プロパティはプライマリーキーとして利用されるため、一意な値である必要があります。
> `@Attribute(.unique)`を付与することで、一意性を担保できます。
> CloudKitとの連携などで、`@Attribute(.unique)`が付与できない場合にも必ず一意性を担保してください。
> 一意性が保たれない場合、永続化データの取り出しや更新が正常に行われない可能性があります。 
```Swift
final class SampleModel: IdentifiableModelProtocol {
    @Attribute(.unique)
    var id: UUID

    var title: String

    init(id: UUID, title: String) {
        self.id = id
        self.title = title
    }
}

extension EntityConvertable {
    typealias Entity = SampleEntity

    convenience init(entity: SampleEntity) {
        self.init(id: entity.id, title: entity.title)
    }

    func makeEntity() -> SampleEntity {
        SampleEntity(id: id, title: title)
    }

    func apply(entity: SampleEntity) {
        id = entity.id
        title = entity.title
    }
}
```

3. `modelContainer`を作成する
`modelContainer`を作成してください。
ここで作成した`modelContainer`は、以下の2箇所で同じインスタンスを利用するように注意してください。
- `AsyncSwiftDataRepository`の初期化時にDIする
- 適切なViewに`ModelContainerModifier`を利用する際、引数として利用する
```Swift
let schema = Schema([SampleModel.self])
let modelConfiguration = ModelConfiguration(schema: schema)
let modelContainer = try! ModelContainer(for: schema, configurations: modelConfiguration)
```

4. RepositoryをActorで作成する
```Swift
@ModelActor
actor SampleRepository: AsyncSwiftDataRepositoryProtocol {
    typealias Entity = SampleEntity
    typealias Model = SampleModel

    // make additional functions
}
```

5. Repositoryを利用してCRUD処理を行う
Repositoryのインスタンスを作成することで、以下の関数が利用できます
- _get(id: UUID)
  - 特定のIDをもつEntityを返します
  - 見つからない場合には`AsyncSwiftDataError.idNotFound`がスローされます
- _fetchAll()
    - 保存されているModelの一覧を配列で返します
- _fetch(fetchDescriptor:)
    - 保存されているModelに対して、fetchDescriptorを適応してfetchした結果を返します
- _save(entity: Entity)
    - entityのIDがすでに永続化されていれば内容を更新する
    - 永続化されていなければ、insert処理を実行する
- _delete(id: UUID)
    - 特定のIDを持つ永続化データを削除する
