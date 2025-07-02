# `struct`

Solon言語では、関連するデータをひとまとめにするために構造体(`struct`)を定義できます。

`struct`のデフォルトコンストラクタは記述されずとも自動的に用意され、これを使用しインスタンス化することができます。

また、`struct`は値型として扱われます。

```Solon
class 構造体名 {
  型: メンバ,
  型: メンバ
}
```

構造体名は大文字から始まる命名でなければなりません。

例えば以下のように使用します。

```Solon
struct Point {
  x: int32,
  y: int32
}

def use_point(): -> void {
  let p: Point = new Point; // コンストラクタがなくてもインスタンス化可能
  return;
}
```

Solonのstructはデフォルトでイミュータブルですが、名前のプレフィックスに`$`を使用することでミュータブルすることができます。

```Solon
struct $Person {
  name: str,
  age: int32
}
```

### 無名構造体

Solon言語では、`struct`型として、無名構造体の定義が可能です。

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