## `class`

Solon言語ではオブジェクト指向をサポートするために`class`を使用します。

`class`で定義されるメンバーは参照型です。

```Solon
class クラス名 {
  // メンバなど
}
```

クラス名は大文字から始まる命名でなければなりません。

### アクセス修飾子

Solonでは、クラス・インターフェース・メンバーなどにアクセス修飾子を指定できます。

- `public` … どこからでもアクセス可能
- `private` … 同じクラスやモジュール内からのみアクセス可能
- `protected` … 継承したクラスからもアクセス可能（クラスメンバーのみ）

```Solon
public class Sample {
  public let id: int32 = 0;         // どこからでもアクセス可
  private let secret: str = "";  // このクラス内のみ
  protected let $value: int32 = 10;  // 派生クラスからもアクセス可
}
```

インターフェースや関数にも同様にアクセス修飾子を付与できます。

```Solon
private def helper() -> void { /* ... */ }
public interface Greeter { /* ... */ }
```

### クラスの継承

Solonでは、クラスの継承は以下のように記述します。

```Solon
class 派生クラス名: 基底クラス名 {
    // ...
}
```
この構文で、派生クラスは基底クラスの機能を継承します。

また、インターフェースの実装でも

```Solon
class 実装クラス名: インターフェース名 {

}
```

この構文で実装を行います。

#### 多重継承について

Solon言語は「明確さ」「安全性」「予測可能性」を重視する設計思想から、**多重継承は許可しません**。
1つのクラスは1つの基底クラスのみ継承できます。

### 静的メンバー

静的なメソッドやフィールドは、`static`を用いて定義します。

```Solon
public static def 静的メソッド名() -> 戻り値の型 {
    // ...
}

public static let 静的値: 型 = 初期値;
public static let $静的カウンタ: 型 = 初期値;
```

静的メンバーはクラス名から直接アクセスできます。

### コンストラクタ

Solonのコンストラクタは関数名を`new`にして作成します。

かつてコンストラクタにはいくつかの問題がありました
- クラス名と同一
  - クラス名をそのまま反映するため冗長になりがち。
- 戻り値の型なし
  - `void`ですらなく、戻り値の型が一切記述されない。
- 暗黙的な`new`演算子
  - 呼び出す際に`new`演算子と組み合わせてのみ呼び出される。

これらは「コンストラクタは特別だから」という理由で受け入れられてきましたが、Solonが目指す「自然な明示性」「可読性」の観点からいくつか問題があります。

これらの問題を解決するために、Solonのコンストラクタは以下のような特徴を持ちます。

1. コンストラクタ名は`new`に固定
   - `def new(...)`のように、コンストラクタは常に`new`という名前を持ちます。
   - クラス名を繰り返す煩わしい記法とはおさらばです。
2. 戻り値の型を明示
3. 通常のメソッドのような定義

```
public class Greet {
  public def new() -> self {
    // 初期化処理
  }
}
```

#### コンストラクタによる初期化処理

もしクラスに初期化するべきメンバーがいるのであれば、コンストラクタで簡単に初期化することが可能です。

このような場合、コンストラクタの引数とメンバーの型が一致している必要があります。


```
class Hoge {
  let fuga: str = u8str.empty;
  let fuga-fuga: int32 = 0;
  let fuga-fuga-fuga: int32 = 10;

  public def new(arg-fuga: str, arg-fuga-fuga: int32, arg-fuga-fuga-fuga: int32) -> self {
    // 対応するメンバーに割り当てを行います。
    self {fuga = arg-fuga, fuga-fuga-fuga = arg-fuga-fuga-fuga};
  }
}
```

位置ベースの初期化処理をサポートします。
この場合引数は名前ではなく、順番で適用が判断され、メンバーは名前で判断されます。

```
class Hoge {
  let fuga: str = u8str.empty;
  let fuga-fuga: int32 = 0;
  let fuga-fuga-fuga: int32 = 10;
  public def new(arg-fuga: str, arg-fuga-fuga: int32, arg-fuga-fuga-fuga: int32) -> self {
    // 引数の順番が保持され、割り当てを行います。_の部分は無視されます。
    self {fuga, _, fuga-fuga-fuga};
  }
}
```

### オブジェクト初期化子

オブジェクトの初期化は以下の通りです。

```Solon
let user = new User { age = 10, name = "andy" };
```

このようにして初期化できるのは可変（ミュータブル）なプロパティのみです。
不変（イミュータブル）なプロパティはコンストラクタでのみ初期化可能です。

> ※ オブジェクト初期化子による初期化は、明確さ・安全性・予測可能性の観点から、publicかつミュータブルなプロパティに限定されています。

## `interface`（インターフェース）

Solonでは、インターフェースを使ってクラスの契約や多重実装を明確に表現できます。

### インターフェースの定義

```Solon
[public | friend | private] interface インターフェース名 {
  // 例: greetメソッド
  def greet(e: EventArgs) -> void;
}
```
- アクセス修飾子（public, friend, private）を指定可能です。

### インターフェースの実装

```Solon
class Origin: BaseClass, インターフェース名 as エイリアス {
  def OriginGreet() of: インターフェース名（もしくはエイリアス）.greet {
    // 実装内容
  }
}
```
- クラスは複数のインターフェースを`as エイリアス名`で別名付きで実装できます。
- 実装メソッドは`of: インターフェース名.メソッド名`で明示的に紐付けます。
- 別名（エイリアス）を使うことで、同じメソッド名の衝突や多重実装も明確に管理できます。
- エイリアスは任意なので、特に付ける理由がない場合は付けなくても大丈夫です。
  
この設計により、Solonの「明確さ」「安全性」「予測可能性」を保ちながら柔軟なインターフェース実装が可能です。

#### `import` 句によるモジュール/フォルダーの取り込み

import文は、単一のモジュール全体、またはフォルダー内の複数のモジュールをまとめて現在のスコープに取り込む際に使用します。

#### `bring` 句による名前空間 `namespace` の取り込み

論理的な名前空間は以下のように定義されます。

## `static class`

静的なメソッドの塊を意図的にカテゴライズしたい場合に自身でmoduleを定義したい場合もあるでしょう。

そのためにSolonには`static class`が用意されています。

```Solon
module モジュール名 {
  // 静的なメソッド
}
```

この中に記述されるメソッドはすべて`static`を記述せずともすべて`static`として扱われます。

```
public def main(args: str[]) {
  // モジュール内の呼び出し
  module-name.Method();
}
```
## `with`ステートメント

Solon言語では`with`を使用して、一時的に修飾名を省略できます。

```Solon
With 修飾名 {
  .method;
  let value: int = .menber;
}
```

この機能を利用することで同じオブジェクトのメンバーに対して繰り返しアクセスする際に、毎回修飾名を書く必要がなくなり、コードの可読性と記述性が向上します。

```Solon
let user = new User();
with user {
  .name = "Taro";
  .age = 20;
  .printProfile();
}
```

このように、`with`ブロック内では`user`のメンバーをドット（`.`）で直接参照できます。
複数のプロパティやメソッドをまとめて捜査したい場合に便利です。

Solonでは`with`の重ね掛けはできません。

```Solon
let user = new User();
with user {
  // let profile: Profile = .user.profile; // この記述はエラー。withブロック内ではuserを直接参照できません。
  // 正しくは let profile: Profile = user.profile; （外のuserを参照）
  let user_profile = user.profile; // 外側のuserを参照

  with user_profile { // コンパイルエラー: withの重ね掛けは許可されません
    // ...
  }
}
```

注意：with文のスコープはブロック内に限定されます。他のオブジェクトや変数と混同しないようにしてください。