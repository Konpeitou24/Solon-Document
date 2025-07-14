# class

Solon ではオブジェクト指向をサポートするために `class` を使用します。  
`class` で定義される型は参照型として動作します。

```solon
class クラス名 {
  // メンバー
}
```

クラス名は大文字から始める必要があります。

## 定義

### 基本構文

```solon
class Sample {
  // メンバー
}
```

- クラス本体にはフィールド、メソッドを定義できます。
- クラス名は PascalCase で記述します。

## フィールドとメソッド

### フィールドの宣言

```solon
class Sample {
  public let name: str = "default";
  private let secret: str = "hidden";
  protected let $counter: int32 = 0;
}
```

- `let` は不変のフィールド
- `$let` はミュータブルなフィールド
- アクセス修飾子（後述）を付けることで可視性を制御します。

### メソッドの宣言

```solon
class Sample {
  public def greet() {
    println("Hello!");
  }
}
```

## アクセス修飾子

フィールドやメソッドに付ける修飾子は以下の通りです。

| 修飾子     | 説明                                |
|------------|------------------------------------|
| `public`   | どこからでもアクセス可能          |
| `private`  | 同じクラスまたはモジュール内のみ |
| `protected`| 派生クラスからもアクセス可能      |

```solon
public class Sample {
  public let id: int32 = 0;
  private let secret: str = "";
  protected let $value: int32 = 10;
}

private def helper() -> void { … }
```

## 静的メンバー

静的なフィールドやメソッドは `static` を付けて定義します。

```solon
class Utility {
  public static def printInfo() {
    println("Static method");
  }

  public static let counter: int32 = 0;
  public static let $mutableCounter: int32 = 0;
}
```

- 静的メンバーはインスタンス化せずに、クラス名からアクセスします。

```solon
Utility.printInfo();
```

## 継承

### クラスの継承

Solon では1つのクラスだけを継承できます。多重継承はできません。

```solon
class Derived: Base {
  // …
}
```

## コンストラクタ

クラスを初期化するには `def new(...) -> self` を定義します。

### 基本構文

```solon
public class Person {
  public def new(name: str) -> self {
    self { name };
  }
}
```

- 名前は常に `new`
- 戻り値は `self`

## メンバー初期化

コンストラクタでフィールドに初期値を割り当てることができます。

### 通常の初期化

```solon
class Hoge {
  let name: str = "";
  let count: int32 = 0;

  public def new(name: str, count: int32) -> self {
    self { name = name, count = count };
  }
}
```

### 位置ベース初期化

```solon
class Hoge {
  let name: str = "";
  let count: int32 = 0;

  public def new(name: str, count: int32) -> self {
    self { name, count };
  }
}
```

- 位置ベースはフィールド順に割り当てます。
- ミュータブルなフィールドはコンストラクタ以外でも書き換え可能ですが、不変フィールドはコンストラクタでのみ初期化できます。

## デストラクタ

リソースの解放処理が必要な場合は `drop()` または `dispose()` を定義します。

```solon
class Resource {
  def dispose() {
    println("リソースを解放しました");
  }
}
```

- 明示的に呼び出すか、`@disposing!` 属性で自動管理します（詳細は別途）。

## まとめ

| 概要                | 内容                                           |
|---------------------|-----------------------------------------------|
| クラス名            | PascalCase、大文字開始                       |
| フィールド          | 不変は `let`、可変は `$let`                   |
| アクセス修飾子      | `public` / `private` / `protected`           |
| 静的メンバー        | `static` で定義、クラスから直接アクセス       |
| 継承                | 単一継承のみ                                  |
| コンストラクタ      | `def new(...) -> self`                        |
| メンバー初期化      | 名前指定または位置ベース                     |
| デストラクタ        | `drop()` / `dispose()` を定義可能            |
