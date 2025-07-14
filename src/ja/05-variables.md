# Solon: 変数・所有権・借用・参照・`@immutable` の設計指針

Solon における変数、所有権、借用、参照、可変性、および `@immutable` 属性の正しい使い方と注意点をまとめます。

---

## 📖 基本方針

| 目的 | 書き方 |
|------|--------|
| **変数がミュータブルか** | 変数名に `$` を付ける |
| **型がミュータブルか**   | 型名に `$` を付ける |
| **参照かどうか**         | 型に `&` を付ける |
| **参照先を可変にする**   | `$borrow` を使う |
| **参照先の値を書き換える** | `at` 構文を使う |
| **型に `$` を付けるのを禁止する** | `@immutable` を付ける |

---

## 📖 変数の定義

```solon
let name: Identifier = Identifier("abc");  // 不変
let $name: Identifier = Identifier("xyz"); // ミュータブル
```

---

## 📖 可変な型

```solon
let s: str = "abc";        // 不変の文字列
let $s: $str = $"abc";     // 可変の文字列
```

| 宣言例                              | 所有権 | 参照？ | 変数ミュータブル？ | 値ミュータブル？ |
|------------------------------------|---------|---------|---------------------|-------------------|
| `let id: Identifier = …;`         | ✅      | ❌      | ❌                 | ❌               |
| `let $id: Identifier = …;`        | ✅      | ❌      | ✅                 | ❌               |
| `let color: $Color = …;`          | ✅      | ❌      | ❌                 | ✅               |
| `let $color: $Color = …;`         | ✅      | ❌      | ✅                 | ✅               |

---

## 📖 借用と参照

### 不変参照
```solon
let r: &Identifier = borrow name;
```

### ミュータブル参照
```solon
let $r: $&($Color) = $borrow color;
```

---

### 厳密な型表記

| 状況 | 型表記 |
|------|--------|
| 不変な値への不変参照 | `&T` |
| 可変な値への不変参照 | `&($T)` |
| 可変な値への可変参照 | `$&($T)` |

---

## 📖 所有権とムーブ

```solon
let id: Identifier = Identifier("abc");
let new_id = move id;
print("{id}"); // ❌ エラー：id は無効
```

---

## 📖 参照先の書き換え: `at` 構文

参照先を書き換えるときは `at` を使います。

```solon
if at color = Color("red") {
    print("書き換え成功");
} else {
    print("無効な参照");
}
```

---

## 📖 `@immutable` 属性

`@immutable` は **型に `$` を付けることを禁止** する属性です。  
型のインスタンス自体は変数としてミュータブルにできますが、  
型レベルでのミュータブル化（`$型名`）は許されません。

---

### 使用例

```solon
@immutable
struct Identifier {
    value: str;
}

let id: Identifier = Identifier("abc");       // ✅ OK
let $id: Identifier = Identifier("xyz");     // ✅ OK（変数がミュータブル）
let id: $Identifier = Identifier("def");     // ❌ NG（型に `$` は禁止）
```

---

### 注意点

✅ `@immutable` が付いていても変数のミュータビリティは自由  
✅ 型のフィールドや構造を `$` にすることは不可  
✅ `$型名` は完全に禁止  
✅ `!` サフィックスは不要。`@immutable` で十分

---

### おすすめの使いどころ

- 識別子やIDなど、本質的に不変な値オブジェクト
- 色や座標などの値オブジェクト

---

## 📖 よくある間違い

| 書き方                                | 問題 |
|--------------------------------------|------|
| `let id: $Identifier = …;`         | ❌ NG（`@immutable` 型に `$` は付けられない） |
| `at r = Identifier("x");` （不変参照） | ❌ NG（不変参照は書き換え不可） |

---

このガイドに沿えば、Solon で安全かつ明快に変数・参照・可変性を扱えます。
