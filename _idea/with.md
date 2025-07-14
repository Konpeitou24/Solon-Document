
# with ステートメント

`with` ステートメントで、同一オブジェクトに対する複数の操作を簡潔に記述できます。

```solon
let user = new User();
with user {
  .name = "Taro";
  .age = 20;
  .printProfile();
}
```

- `with` のネストはできません。

```solon
let user = new User();
with user {
  let profile = user.profile;

  with profile { // エラー: with の重ね掛けは不可
    // …
  }
}
```
