# アクセス修飾子

Solonでは、クラス・インターフェース・メンバー・関数などにアクセス修飾子を指定できます。

- `public` … どこからでもアクセス可能
- `private` … 同じクラスやモジュール内からのみアクセス可能
- `protected` … 継承したクラスからもアクセス可能（クラスメンバーのみ）
- `friend` … 同一名前空間やモジュール内からアクセス可能（将来的な拡張用）

```Solon
  public let id: int32 = 0;         // どこからでもアクセス可
  private let secret: str = "";  // このクラス内のみ
  protected let $value: int32 = 10;  // 派生クラスからもアクセス可
```

インターフェースや関数にも同様にアクセス修飾子を付与できます。

```Solon
private def helper() -> void { /* ... */ }
public interface Greeter { /* ... */ }
```