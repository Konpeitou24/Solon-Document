# class

Solon ではオブジェクト指向をサポートするために `class` を使用します。  
`class` で定義される型は値型として動作します。

```solon
class クラス名 {
  // メンバー
}
```

クラス名は大文字から始まる必要があります。

## アクセス修飾子

クラス・インターフェース・メンバーには以下のアクセス修飾子を指定できます。

- `public`: どこからでもアクセス可能
- `private`: 同じクラスやモジュール内からのみアクセス可能
- `protected`: 派生クラスからもアクセス可能（クラスメンバーのみ）

```solon
public class Sample {
  public let id: int32 = 0;
  private let secret: str = "";
  protected let $value: int32 = 10;
}

private def helper() -> void { … }
public interface Greeter { … }
```

## 継承

### クラスの継承

```solon
class 派生クラス名: 基底クラス名 {
  // …
}
```

### インターフェースの実装

```solon
class 実装クラス名: インターフェース名 {
  // …
}
```

## 多重継承

Solon では明確さ・安全性・予測可能性を重視するため、多重継承は許可されません。  
1つのクラスは1つの基底クラスのみ継承できます。

## 静的メンバー

静的なメソッドやフィールドは `static` で定義します。  
静的メンバーはクラス名を通じてアクセスします。

```solon
public static def メソッド名() -> 戻り値の型 { … }

public static let 静的値: 型 = 初期値;
public static let $静的カウンタ: 型 = 初期値;
```

## コンストラクタ

コンストラクタは `def new(...) -> self` で定義します。

- 名前は常に `new`
- 戻り値の型は `self`
- 通常のメソッドと同様の構文

```solon
public class Greet {
  public def new() -> self {
    // 初期化処理
  }
}
```

### メンバー初期化

コンストラクタでメンバーに初期値を割り当てます。

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

- この方法で初期化できるのはミュータブルなプロパティのみ
- 不変なプロパティはコンストラクタでのみ初期化可能

## デストラクタ

クラスに解放すべきリソースがある場合は `drop()` または `dispose()` を定義します。

## @disposing! 属性とリソース管理

### @disposing!

`@disposing!` はクラスに **明示的なリソース解放を義務付ける属性** です。  
付与されたクラスは `dispose()` を必ず呼び出す必要があります。

```solon
@disposing!
public class FileHandle {
  def dispose() {
    println("ファイルを閉じました");
  }
}
```

### 暗黙の `IDisposable` 実装

`@disposing!` が付いたクラスは暗黙に `IDisposable` を実装します。

```solon
def close-if-needed(obj: any) {
  if obj is IDisposable {
    obj.dispose();
  }
}
```

### using スコープ構文

`using` スコープ構文で、スコープ終了時に `dispose()` が自動で呼ばれます。

```solon
using conn = new DbConnection {
  conn.query("SELECT * FROM users");
}
// conn.dispose() が自動で呼ばれる
```

### 警告・エラー

- `@disposing!` が付いていて `dispose()` を呼ばない場合、警告（または設定によりエラー）が発生します。

```solon
let f = new FileHandle(); // dispose() 呼び出しなし → 警告
```

### @disposing-ignore!

`@disposing-ignore!` を付けると警告を抑制できます。

```solon
@disposing-ignore!
let f = new FileHandle();
// dispose() を意図的に呼ばない
```

# interface

インターフェースはクラスの契約や多重実装を表現します。

## 定義

```solon
[public | friend | private] interface インターフェース名 {
  def greet(e: EventArgs) -> void;
}
```

## 実装

```solon
class Origin: BaseClass, インターフェース名 alias エイリアス {
  def OriginGreet() of: インターフェース名.greet {
    // 実装
  }
}
```

- 複数のインターフェースを `alias エイリアス名` で別名付きで実装可能
- 実装メソッドは `of: インターフェース名.メソッド名` で明示的に紐付ける
- エイリアスは省略可能

# module（静的クラス）

静的なメソッド群は `module` で定義します。  
モジュール内のメソッドはすべて暗黙に `static` です。

```solon
module モジュール名 {
  public def helper() { … }
}

public def main(args: str[]) {
  モジュール名.helper();
}
```
