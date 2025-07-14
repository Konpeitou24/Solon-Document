# map

Solon では、キーと値のペアを複数格納するために `map` を使用します。  
`map<Key, Value>` は内部的には **`pair<Key, Value>[]` のエイリアス** です。  
つまり、map は特別な構造ではなく、単なる `pair` の配列です。

## 定義

`map<Key, Value>` は以下のように定義されます：

```solon
type map<Key, Value> = pair<Key, Value>[]
```

`pair<Key, Value>` はキーと値を持つ単純な構造です。

## リテラルの書き方

map はリテラルで初期化できます。  
リテラルは内部的に `pair(key, value)` に展開されます。

```solon
let ages: map<str, int32> = [
  "Alice" to 30,
  "Bob" to 25,
  "Carol" to 20
];
```

これはコンパイラによって以下に展開されます：

```solon
let ages: map<str, int32> = [
  pair("Alice", 30),
  pair("Bob", 25),
  pair("Carol", 20)
];
```

## `to` の意味

`to` は、キーと値のペアを表すための自然な構文です。  
`to` は Solon において **pair のリテラル専用の構文糖** です。

例えば、単独の pair も次のように書けます：

```solon
let p: pair<str, int32> = "Alice" to 30;
```

内部的には：
```solon
pair("Alice", 30)
```
と同じです。

## map の特徴

- **map はただの pair の配列**
- map に特別なハッシュや検索構造はありません（必要なら別途構築する）
- 複数の `pair<Key, Value>` を持つ配列として扱われます

## 例

```solon
let phonebook: map<str, str> = [
  "Alice" to "1234",
  "Bob" to "5678",
  "Carol" to "91011"
];

for entry in phonebook {
  println("${entry.key} : ${entry.value}");
}
```

出力：
```
Alice : 1234
Bob : 5678
Carol : 91011
```

## 補足

- `map<K, V>` の実体は `pair<K, V>[]` なので、map も配列操作が可能です。
- リテラルの記号は `to` で統一されています。`=>` は使用しません。
- map は読みやすさを重視し、Solon の「自然な明示性」を体現しています。
