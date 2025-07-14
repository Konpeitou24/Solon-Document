# Solon: `match` の仕様

`match` は、複数の値に応じて処理を分岐させる構文です。  
**常に値を返すため、`;` が必要** です。

---

## 基本形

```solon
let result = match value {
  1 => {
    println("one");
    ~> "Hello";
  }, 
  2 => println("two"),
  _ => println("other")
};
```

---

## 特徴

### 値を返す
- `match` は式であり、必ず値を返します。
- 返された値を変数に代入したり、他の式に組み込むことができます。

```solon
let message = match status {
  200 => "OK",
  404 => "Not Found",
  _   => "Unknown"
};
```

---

### `~>` 弱い return
- ブロック内で `~>` を使うことで、そのブロックの戻り値を明示的に指定します。
- 弱い return とは、関数全体を終了させずに、そのブロックの値として返すという意味です。

```solon
match value {
  1 => {
    println("one");
    ~> "Hello"; // このブロックの戻り値
  },
  _ => "default"
};
```

---

### セミコロンが必須
- `match` は式であるため、文として終えるときには必ず `;` が必要です。

```solon
match value {
  1 => println("one"),
  _ => println("other")
};
```

---

## まとめ

| 特徴                       | 内容 |
|----------------------------|------|
| 常に値を返す                | 戻り値を代入・利用可能 |
| セミコロンが必須            | 式なので必ず `;` で終える |
| ブロックの戻り値を指定可能  | `~>` を使う |
| デフォルトケース            | `_` を使用 |

---

### 完全な例

```solon
let result = match value {
  1 => {
    println("Case 1");
    ~> "Result 1";
  },
  2 => {
    println("Case 2");
    ~> "Result 2";
  },
  _ => "Default"
};
println(result);
```

この場合、`result` には `"Result 1"` または `"Result 2"` または `"Default"` が入ります。

