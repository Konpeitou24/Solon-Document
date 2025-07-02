# class

Solon言語ではオブジェクト指向をサポートするために `class` を使用します。  
`class` で定義される型は値型として動作します。

```solon
class クラス名 {
  // メンバーなど
}
```

クラス名は大文字から始まる命名でなければなりません。

## アクセス修飾子

Solonでは、クラス・インターフェース・メンバーなどに以下のアクセス修飾子を指定できます。

- `public`: どこからでもアクセス可能
- `private`: 同じクラスやモジュール内からのみアクセス可能
- `protected`: 派生クラスからもアクセス可能（クラスメンバーのみ）

```solon
public class Sample {
  public let id: int32 = 0;
  private let secret: str = "";
  protected let $value: int32 = 10;
}
```

インターフェースや関数にも同様にアクセス修飾子を付与できます。

```solon
private def helper() -> void { /* ... */ }
public interface Greeter { /* ... */ }
```

## クラスの継承

クラスの継承は以下のように記述します。

```solon
class 派生クラス名: 基底クラス名 {
  // ...
}
```

また、インターフェースの実装も同様に行います。

```solon
class 実装クラス名: インターフェース名 {
  // ...
}
```

## 多重継承について

Solonでは「明確さ」「安全性」「予測可能性」を重視するため、多重継承は許可されません。  
1つのクラスは1つの基底クラスのみ継承できます。

## 静的メンバー

静的なメソッドやフィールドは `static` を使用して定義します。

```solon
public static def メソッド名() -> 戻り値の型 {
  // ...
}

public static let 静的値: 型 = 初期値;
public static let $静的カウンタ: 型 = 初期値;
```

静的メンバーはクラス名を通じてアクセスされます。

## コンストラクタ

コンストラクタは `def new(...) -> self` として定義します。  
以下のような特徴を持ちます。

1. 名前は常に `new` に固定
2. 戻り値の型を明示（`-> self`）
3. 通常のメソッドと同様の構文

```solon
public class Greet {
  public def new() -> self {
    // 初期化処理
  }
}
```

### コンストラクタによる初期化

初期化対象のメンバーがある場合、コンストラクタで初期値を割り当てます。

```solon
class Hoge {
  let fuga: str = u8str.empty;
  let fuga-fuga: int32 = 0;
  let fuga-fuga-fuga: int32 = 10;

  public def new(arg-fuga: str, arg-fuga-fuga: int32, arg-fuga-fuga-fuga: int32) -> self {
    self {fuga = arg-fuga, fuga-fuga-fuga = arg-fuga-fuga-fuga};
  }
}
```

位置ベースの初期化も可能です。

```solon
class Hoge {
  let fuga: str = u8str.empty;
  let fuga-fuga: int32 = 0;
  let fuga-fuga-fuga: int32 = 10;

  public def new(arg-fuga: str, arg-fuga-fuga: int32, arg-fuga-fuga-fuga: int32) -> self {
    self {fuga, _, fuga-fuga-fuga};
  }
}
```

この方法で初期化できるのは **ミュータブルな（可変）プロパティのみ** です。  
不変なプロパティはコンストラクタでのみ初期化可能です。

> オブジェクト初期化子は、public かつミュータブルなプロパティに対してのみ使用できます。

## デストラクタによる解放処理

クラスに開放すべきメンバーがある場合、`drop()` または `dispose()` を用いて回収処理を定義できます。

## @disposing! 属性とリソース管理仕様

Solon では、安全で明示的なリソース解放を支援するために `@disposing!` 属性と `using` スコープ構文を導入します。

---

### 属性: `@disposing!`

- `@disposing!` は、クラスに明示的なリソース解放（`dispose()` の呼び出し）を **義務付ける属性**です。
- この属性が付与されたクラスは、インスタンスの使用後に **明示的に `dispose()` を呼び出す必要があります**。

```solon
@disposing!
public class FileHandle {
  def dispose() {
    println("ファイルを閉じました");
  }
}
```

---

### 暗黙の `IDisposable` 実装

- `@disposing!` を付与されたクラスは、自動的に `IDisposable` インターフェースを実装したものとして扱われます。
- そのため、次のように型チェックが可能です。

```solon
def close-if-needed(obj: any) {
  if obj is IDisposable {
    obj.dispose();
  }
}
```

---

### `using` スコープ構文による自動解放

- `@disposing!` が付与されたクラスのインスタンスは、`using` スコープ構文によってスコープ終了時に `dispose()` を自動的に呼び出すことができます。

```solon
using conn = new DbConnection {
  conn.query("SELECT * FROM users");
}
// conn.dispose() が自動で呼ばれる
```

---

### 警告・エラー動作

- `@disposing!` が付与されたクラスで `dispose()` を明示的に呼ばず、`using` も使わないままスコープを抜けた場合：
  - デフォルトでは **コンパイル警告** が発生します
  - 設定により **エラー** として扱うことも可能です

```solon
let f = new FileHandle(); // dispose() 呼び出しなし → 警告
```

---

## 明示的な無視：`@disposing-ignore!`

- 意図的に `dispose()` を呼ばないことを明示したい場合、変数宣言に `@disposing-ignore!` を付けることで警告を抑制できます。

```solon
@disposing-ignore!
let f = new FileHandle();
// 明示的に破棄しないことを宣言（危険だが有効）
```

---

## まとめ

| 項目                     | 内容                                               |
|--------------------------|----------------------------------------------------|
| `@disposing!`            | このクラスは `dispose()` を必ず呼ぶ必要がある      |
| 暗黙 `IDisposable` 実装 | `@disposing!` を付けるだけで型チェックが可能になる |
| `using` 構文             | スコープ終了時に `dispose()` を自動呼び出し        |
| 警告/エラー              | `dispose()` を忘れるとビルド警告（またはエラー）   |
| `@disposing-ignore!`      | 呼び出しを意図的に無視する際に使用                 |


# interface

Solonでは、インターフェースを使ってクラスの契約や多重実装を明確に表現できます。

## インターフェースの定義

```solon
[public | friend | private] interface インターフェース名 {
  def greet(e: EventArgs) -> void;
}
```

## インターフェースの実装

```solon
class Origin: BaseClass, インターフェース名 as エイリアス {
  def OriginGreet() of: インターフェース名.greet {
    // 実装内容
  }
}
```

- クラスは複数のインターフェースを `as エイリアス名` で別名付きで実装できます。
- 実装メソッドは `of: インターフェース名.メソッド名` で明示的に紐付けます。
- エイリアスは任意です。必要ない場合は省略できます。

この構文により、同名メソッドの衝突を防ぎ、柔軟な多重実装が可能になります。

# static class（モジュール）

静的なメソッドの集合を記述するには `module`（静的クラス）を使用します。

```solon
module モジュール名 {
  // 静的なメソッド
}
```

モジュール内のメソッドはすべて暗黙的に `static` として扱われます。

```solon
public def main(args: str[]) {
  module-name.Method();
}
```

# with ステートメント

`with` ステートメントを使うと、一時的に修飾名を省略して同一オブジェクトに繰り返しアクセスできます。

```solon
let user = new User();
with user {
  .name = "Taro";
  .age = 20;
  .printProfile();
}
```

`with` のネストはできません。

```solon
let user = new User();
with user {
  let profile = user.profile;

  with profile { // エラー: withの重ね掛けは不可
    // ...
  }
}
```
