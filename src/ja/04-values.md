# 04 Values

## 基本的な型

- 整数型
  - `int8`, `uint8` (符号付き/なし 8ビット整数)
  - `int16`, `uint16` (符号付き/なし 16ビット整数)
  - `int32`, `uint32` (符号付き/なし 32ビット整数)
  - `int64`, `uint64` (符号付き/なし 64ビット整数)
- 浮動小数点型
  - `float32` (単精度浮動小数点数)
  - `float64` (倍精度浮動小数点数)
- 文字型
  - UTF-8
    - `u8char`または`char`（UTF-8文字）
  - UTF-16
    - `u16char`（UTF-16文字）
  - UTF-32
    - `u32char` (UTF-32文字)
- 文字列型
  - UTF-8
    - `u8str`または`str`（BOMなしのUTF-8文字列）
    - `u8str-bom`（BOM付のUTF-8文字列）
  - UTF-16
    - `u16str-le` (BOMなしのリトルエンディアンUTF-16文字列)
    - `u16str-be` (BOMなしのビッグエンディアンUTF-16文字列)
    - `u16str` (BOM付UTF-16文字列、BOMでエンディアン判別)
  - UTF-32
    - `u32str-le` (BOMなしのリトルエンディアンUTF-32文字列)
    - `u32str-be` (BOMなしのリトルエンディアンUTF-32文字列)
    - `u32str` (BOM付UTF-32文字列、BOMでエンディアン判別)

### ミュータブルな文字列型

文字列型は基本イミュータブルですが、`$`をプレフィックスとした文字列型はミュータブルです。

### 何もない！

値が存在しない、という値は`null`を使用します。

また、値が存在しない場合の型は`void`を使用します。



## 文字、文字列の値

文字はシングルクォートで囲まれ、値として扱われます。
- UTF-8
  - `u8'v'` または `'v'` (UTF-8文字, `u8char`, `char`)
- UTF-16
  - `u16'v'` (UTF-16文字, `u16char`)
- UTF-32
  - `u32'v'` (UTF-32文字, `u32char`)

Solon言語の文字列はイミュータブルです。

文字列はダブルクォートで囲まれ、値として扱われます。
- UTF-8
  - `u8"value"` または `"value"` (BOMなしのUTF-8文字列, `u8str`, `str`)
  - `u8"value"bom` (BOM付のUTF-8文字列, `u8str-bom`)
- UTF-16
  - `u16"value"le` (BOMなしのリトルエンディアンUTF-16文字列, `u16str-le`)
  - `u16"value"be` (BOMなしのビッグエンディアンUTF-16文字列, `u16str-be`)
  - `u16"value"` (BOM付UTF-16文字列、BOMでエンディアン判別, `u16str`)
- UTF-32
  - `u32"value"le` (BOMなしのリトルエンディアンUTF-32文字列, `u32str-le`)
  - `u32"value"be` (BOMなしのビッグエンディアンUTF-32文字列, `u32str-be`)
  - `u32"value"` (BOM付UTF-32文字列、BOMでエンディアン判別, `u32str`)

また、文字の結合でBOMを付与したい場合、`as`句を使います。
これは安全な型変換でご紹介します。
```Solon
(u8'h' & u8'e' & u8'l' & u8'l' & u8'o') as u8str-bom;
```

###  ミュータブル文字列と文字列補間

Solonの文字列はイミュータブルであり、関数は常に新しい文字列を返す必要があります。

しかし`$`記号をプレフィックスとしてつけた文字列はミュータブルとして扱われます。

これらはすべて`$`をプレフィックスとする型を使用します。

```Solon
let greet: $u8str = $u8"Hello!World!";
let greet-2: $str = $"How do you do?";
```

さらに変数などを埋め込むことが可能です。

```Solon
let to_world: str = "world";
let to_bro: str = "bro";

def greet(message_to: str) -> void {
  print($"hello,{message_to}");
  return void;
}

greet(to_world); // hello,world
greet(to_bro); // hello,bro
```

### 文字列の結合

Solonの文字列結合は常に新しい文字列を返します。

文字列の結合には`&`を使用します。

```
let greet: str = "Hello," & "World.";
```


これは安全な型変換でご紹介します。
```Solon
(u8'h' & u8'e' & u8'l' & u8'l' & u8'o') as u8str-bom;
```

###  ミュータブル文字列と文字列補間

Solonの文字列はイミュータブルであり、関数は常に新しい文字列を返す必要があります。

しかし`$`記号をプレフィックスとしてつけた文字列はミュータブルとして扱われます。

これらはすべて`$`をプレフィックスとする型を使用します。

```Solon
let greet: $u8str = $u8"Hello!World!";
let greet-2: $str = $"How do you do?";
```

さらに変数などを埋め込むことが可能です。

```Solon
let to_world: str = "world";
let to_bro: str = "bro";

def greet(message_to: str) -> void {
  print($"hello,{message_to}");
  return void;
}

greet(to_world); // hello,world
greet(to_bro); // hello,bro
```

### 文字列の結合

Solonの文字列結合は常に新しい文字列を返します。

文字列の結合には`&`を使用します。

```
let greet: str = "Hello," & "World.";
```


## 数値、数値の型

Solonでは基本的な数値は`int32`、小数点が付く場合は`float64`として扱われます。

```Solon
let $x = 123;       // $x は int32 型に推論される
let y: int64 = 42; // 明示的に int64 型を指定
let z: uint8 = 255; // 明示的に uint8 型を指定
```

後ほど扱いますが、他の型として扱う場合は`as`で変換してください。


## 安全な型変換

Solon言語では、安全な型変換を`as`句で行います。

型変換は以下のような場合に利用できます。
- クラスの基底クラス・派生クラス間（例：`Animal`から`Dog`、`Dog`から`Animal` など）
- インターフェースの実装クラスとインターフェース型間
- プリミティブ型同士（例：int→float など）

型に互換性のない場合や、値がnullの場合は、変換は失敗しnullが返されます。

```Solon
// 型変換の基本形
元の値 as 変換後の型
```

### 例：クラスの型変換

```Solon
class Animal {}
class Dog: Animal {}

let a: Animal = new Dog();
let d: Dog = a as Dog; // OK
let c: Cat = a as Cat; // 失敗時はnull
```

### 例：インターフェースの型変換

```Solon
interface Greeter {
  def greet() -> void;
}
class Person: Greeter {
  def greet() -> void {
    print("Hi!");
  }
}
let g: Greeter = new Person();
let p: Person = g as Person; // OK
```

### 例：プリミティブ型の変換

```Solon
let i: int32 = 1;
let f: float32 = i as float32; // 1.0
let s: str = i as str; // エラー。これはできません。
```

※「as」句では数値型同士の変換（int→floatなど）は可能ですが、数値から文字列（str）への変換はできません。

### 例：ミュータブル型とイミュータブル型の相互変換

```Solon
let im_string: str = "immutable";
let mu_string: $str = im_string[2..] as $str;

let re_im_string: str = ($"im" & mu_string) as str;
```

### 変換できないパターン

型が互換性のない場合や、変換できない型同士の場合はnullが返されます。

### 失敗時の挙動

型変換が失敗した場合はnullが返るため、必ずnullチェックを行ってください。

```Solon
let maybeDog = a as Dog;
if maybeDog != null {
  maybeDog.bark();
} else {
  print("Dogではありません。");
}
```

### 注意事項
- 「as」句は安全な型変換であり、変換に失敗しても例外は発生しません。
- プリミティブ型同士（例：int→floatなど）の変換は可能ですが、数値から文字列（str）への変換はできません。
- 型変換が失敗した場合はnullが返るため、必ずnullチェックを行ってください。

こんな感じで「as」句を使いこなして、型変換もバッチリです！✨


Solon言語では、安全な型変換を`as`句で行います。

型変換は以下のような場合に利用できます。
- クラスの基底クラス・派生クラス間（例：`Animal`から`Dog`、`Dog`から`Animal` など）
- インターフェースの実装クラスとインターフェース型間
- プリミティブ型同士（例：int→float など）

型に互換性のない場合や、値がnullの場合は、変換は失敗しnullが返されます。

```Solon
// 型変換の基本形
元の値 as 変換後の型
```

### 例：クラスの型変換

```Solon
class Animal {}
class Dog: Animal {}

let a: Animal = new Dog();
let d: Dog = a as Dog; // OK
let c: Cat = a as Cat; // 失敗時はnull
```

### 例：インターフェースの型変換

```Solon
interface Greeter {
  def greet() -> void;
}
class Person: Greeter {
  def greet() -> void {
    print("Hi!");
  }
}
let g: Greeter = new Person();
let p: Person = g as Person; // OK
```

### 例：プリミティブ型の変換

```Solon
let i: int32 = 1;
let f: float32 = i as float32; // 1.0
let s: str = i as str; // エラー。これはできません。
```

※「as」句では数値型同士の変換（int→floatなど）は可能ですが、数値から文字列（str）への変換はできません。

### 例：ミュータブル型とイミュータブル型の相互変換

```Solon
let im_string: str = "immutable";
let mu_string: $str = im_string[2..] as $str;

let re_im_string: str = ($"im" & mu_string) as str;
```

### 変換できないパターン

型が互換性のない場合や、変換できない型同士の場合はnullが返されます。

### 失敗時の挙動

型変換が失敗した場合はnullが返るため、必ずnullチェックを行ってください。

```Solon
let maybeDog = a as Dog;
if maybeDog != null {
  maybeDog.bark();
} else {
  print("Dogではありません。");
}
```

### 注意事項
- 「as」句は安全な型変換であり、変換に失敗しても例外は発生しません。
- プリミティブ型同士（例：int→floatなど）の変換は可能ですが、数値から文字列（str）への変換はできません。
- 型変換が失敗した場合はnullが返るため、必ずnullチェックを行ってください。

こんな感じで「as」句を使いこなして、型変換もバッチリです！✨


- 「as」句は安全な型変換であり、変換に失敗しても例外は発生しません。
- プリミティブ型同士（例：int→floatなど）の変換は可能ですが、数値から文字列（str）への変換はできません。
- 型変換が失敗した場合はnullが返るため、必ずnullチェックを行ってください。

こんな感じで「as」句を使いこなして、型変換もバッチリです！✨


## 型推論

一部のシンタックスシュガーや右辺から型が明らかである場合は、型推論が有効です。

その他の、その行のみで型が判別できない関数呼び出しなどは型が必要になります。

```
// 右辺で初期化されている型が明らか
let object = new Object();
// 右辺で定義されている値の型が明らか
let my_string = u8"UTF-8 string";
// 型変換が適用されていて明らか
let num = 123 as uint32;
// 関数の戻り値の型がその行だけで読めないためエラー
let connection = object.begin-connection(); // エラー！

```


一部のシンタックスシュガーや右辺から型が明らかである場合は、型推論が有効です。

その他の、その行のみで型が判別できない関数呼び出しなどは型が必要になります。

```
// 右辺で初期化されている型が明らか
let object = new Object();
// 右辺で定義されている値の型が明らか
let my_string = u8"UTF-8 string";
// 型変換が適用されていて明らか
let num = 123 as uint32;
// 関数の戻り値の型がその行だけで読めないためエラー
let connection = object.begin-connection(); // エラー！

```


- ラムダ式は例外的に型推論が有効です。
- 記法：`(引数リスト) => 処理内容`
- 引数がない場合も `()` を省略できません。

#### 例

```Solon
// 何も引数を取らず、常に "Hello!" という文字列を返す関数
let sayHello = () => u8"Hello!";
let greeting = sayHello(); // greeting は u8"Hello!"

// 複数の引数を持つラムダ式
let add = (x, y) => x + y;
let result = add(2, 3); // result は 5
```

このように、Solonのラムダ式は簡潔かつ型推論を活用できる柔軟な記法です。

### パイプライン

Solonでは`|>`によりパイプライン処理をサポートします。

従来のネストされた関数よりも、直感的で読みやすい記述ができるような工夫です。

型推論が有効です。

```Solon
引数 |> 関数;
```

活用例

```Solon
// 従来のネスト
let result = process3(process2(process1(data)));

// Solonのパイプライン
let result = data
            |> process1
            |> process2
            |> process3;
```

引数を複数渡す場合は以下の通りです。

```Solon
// カリー化可能関数を定義します。
@curried!
def sum(x: int32, y: int32, z: int32) -> int32 {
  return x + y + z;
}

let result = 10
            |> sum // 10がsumのxに渡される。結果は (y) => (z) => 10 + y + z を返す関数
            |> sum(100) // 100が上記の関数のyに渡される。結果は (z) => 10 + 100 + z を返す関数
            |> sum(1000); // 1000が上記の関数のzに渡される。最終結果は 10 + 100 + 1000 = 1110
```

### 関数型

Solonでは関数を型として扱うことができます。それは主に無名関数などを格納したりする際に利用でき、通常の関数は値として扱われません。

```
// 引数なしの場合
function<戻り値の型>

// 引数ありの場合
function<引数の型, 戻り値の型>
```


このように、Solonのラムダ式は簡潔かつ型推論を活用できる柔軟な記法です。

### パイプライン

Solonでは`|>`によりパイプライン処理をサポートします。

従来のネストされた関数よりも、直感的で読みやすい記述ができるような工夫です。

型推論が有効です。

```Solon
引数 |> 関数;
```

活用例

```Solon
// 従来のネスト
let result = process3(process2(process1(data)));

// Solonのパイプライン
let result = data
            |> process1
            |> process2
            |> process3;
```

引数を複数渡す場合は以下の通りです。

```Solon
// カリー化可能関数を定義します。
@curried!
def sum(x: int32, y: int32, z: int32) -> int32 {
  return x + y + z;
}

let result = 10
            |> sum // 10がsumのxに渡される。結果は (y) => (z) => 10 + y + z を返す関数
            |> sum(100) // 100が上記の関数のyに渡される。結果は (z) => 10 + 100 + z を返す関数
            |> sum(1000); // 1000が上記の関数のzに渡される。最終結果は 10 + 100 + 1000 = 1110
```

### 関数型

Solonでは関数を型として扱うことができます。それは主に無名関数などを格納したりする際に利用でき、通常の関数は値として扱われません。

```
// 引数なしの場合
function<戻り値の型>

// 引数ありの場合
function<引数の型, 戻り値の型>
```


型推論が有効です。

```Solon
引数 |> 関数;
```

活用例

```Solon
// 従来のネスト
let result = process3(process2(process1(data)));

// Solonのパイプライン
let result = data
            |> process1
            |> process2
            |> process3;
```

引数を複数渡す場合は以下の通りです。

```Solon
// カリー化可能関数を定義します。
@curried!
def sum(x: int32, y: int32, z: int32) -> int32 {
  return x + y + z;
}

let result = 10
            |> sum // 10がsumのxに渡される。結果は (y) => (z) => 10 + y + z を返す関数
            |> sum(100) // 100が上記の関数のyに渡される。結果は (z) => 10 + 100 + z を返す関数
            |> sum(1000); // 1000が上記の関数のzに渡される。最終結果は 10 + 100 + 1000 = 1110
```

### 関数型

Solonでは関数を型として扱うことができます。それは主に無名関数などを格納したりする際に利用でき、通常の関数は値として扱われません。

```
// 引数なしの場合
function<戻り値の型>

// 引数ありの場合
function<引数の型, 戻り値の型>
```


無名構造体は型推論が有効です。

```Solon
let report = struct {
  weather: str = "sunny",
  temperature = 30 // ここは右側が自明である場合型推論が有効です。
};

def use_report(): -> void {
  print(report.weather); // sunny
  return;
}
```

戻り値の型として使用される無名構造体もあります。

```Solon
def calc(left: int32, right: int32) -> struct {add: int32, sub: int32} {
  return {add = left + right, sub = left - right};
}
```


  temperature = 30 // ここは右側が自明である場合型推論が有効です。
};

def use_report(): -> void {
  print(report.weather); // sunny
  return;
}
```

戻り値の型として使用される無名構造体もあります。

```Solon
def calc(left: int32, right: int32) -> struct {add: int32, sub: int32} {
  return {add = left + right, sub = left - right};
}
```


またクエリ構文では`let`による型推論が有効です。これは配列のメソッドによるクエリの代替となるシンタックスシュガーとしてこの構文がみなされることから由来します。

### 基本的な構造

クエリ構文は、主に以下のキーワード句で構成されます。

- `from ... in ...`: クエリのデータソースと、各要素を表す範囲変数を定義します。
- `where ...`: 指定した条件に基づいて要素をフィルタリングします。
- `select ...`: フィルタリングされた要素を新しい形に射影します。

```Solon
let numbers: int32[] = [1, 2, 3, 4, 5, 6];

// 偶数をフィルタリングし、その二乗を選択するクエリ
let processed_numbers = from n in numbers // numbersから各要素をnとして取得
                        where n % 2 == 0  // nが偶数である条件でフィルタリング
                        select n * n;     // nを二乗して選択
// processed_numbers は [4, 16, 36] となる（結果は新しいイミュータブルな配列/コレクション）
```

これらクエリ構文は **遅延実行** です。

クエリは定義された時点ではデータ処理を実行しません。これはクエリを変数に代入するだけでは計算が行われないことを意味します。

### 特別な`order by`句

クエリ構文におけるソート操作は、Solonの哲学を追求した独自の記法を採用しています。

- **キーワード** : ソートは`order by`という2つのキーワードをスペースで区切ってしようします。`order`の後に`by`が来ない場合は構文エラーとなります。これにより安全性と簡潔さを両立した構文を実現しています。
- **昇順(Ascending)** : ソートキーの後に何もつけません。これはソートのデフォルト（自然な順序）を表します。
- **降順(Descending)** : ソートキーの直後に`!`を付けます。

`order by`はカンマ区切りで、記述順がそのままソートの優先順位となります。

```Solon
order by item.price!, // まず価格を降順
         item.name    // 次に名前を昇順
```

上記の場合同価格であれば名前が優先されますが、価格の降順は維持されます。

また、比較としてカスタムの比較関数を指定可能です。

```Solon
order by (a, b) => a.custom_rank > b.custom_rank // 比較ロジック
```

### パイプライン処理とクエリ

クエリの末尾にパイプライン処理を含めることができます。

```Solon
let numbers: int32[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
// パイプライン処理の結果が保持される
let sum_of_even_squares = from n in numbers
                          where n % 2 == 0
                          select n * n
                          |> sum; // クエリの結果（偶数の二乗のコレクション）を合計関数にパイプ
```
