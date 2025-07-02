# イベントシステム仕様（Solon）

Solonは、イベント駆動型の処理を言語構文で直接記述できるよう設計されています。  
本仕様では、イベントの定義、購読、スコープ制御、解除、伝播について記述します。

---

## 🎯 イベントハンドラの定義

イベントの引数型に応じて、まず delegate（関数型）を定義します。

```solon
delegate def EventHandler(e: EventArgs) -> void;
```

---

## 🔔 イベントの宣言

イベントは `event` で定義し、アクセス修飾子をつけることもできます。

```solon
private event OnPushXXX: EventHandler;
```

---

## イベントの発生

イベントは`raise`で発火させる。

```Solon
raise OnPushXXX(EventArgs.empty()); // 引数はデリゲートの引数と合致していなければエラーです。
```

## ➕ 明示的な購読（+=）

関数をイベントに手動で購読させるには `+=` を使用します。

```solon
OnPushXXX += FunctionName;
```

関数のシグネチャはイベントハンドラと一致する必要があります。

---

## 🪄 自動購読関数（auto-subscribe）

関数定義に `on:` を指定すると、自動でイベント購読・解除が行われます。

```solon
def HandlePush() on: OnPushXXX -> void {
  println("Push!");
}
```

- スコープの終了と共に購読は解除されます。
- `+=` は不要です。

---

## 🧩 無名イベントハンドラ（anonymous handler）

無名で呼び出し不可のイベントハンドラも定義可能です。

```solon
on: OnPushXXX -> void {
  println("Pushed anonymously!");
}
```

- そのスコープにおいて1つのみ定義可能
- 明示的に呼び出すことはできません（イベント専用）

---

## ➖ 購読の解除（-=）

イベントから関数を削除するには `-=` を使います。

```solon
OnPushXXX -= FunctionName;
```

すべての購読者を一括解除する場合は `*` を使います：

```solon
OnPushXXX -= *;
```

---

## 🧭 スコープとライフタイム

- 自動購読関数・無名ハンドラはスコープの終了時に自動解除されます。
- `OnPushXXX +=` などの明示的な購読は解除しない限り残ります。

---

## 🔄 イベント伝播（VB.NET風モデル）

Solonは VB.NET のイベント伝播を参考に、以下のような伝播機構を導入予定です：

- バブリング（親に伝播する）
- イベント引数で伝播のキャンセルが可能：

```solon
def OnEvent(e: CustomEventArgs) on: SomeEvent -> void {
  e.cancel(); // 伝播停止
}
```

---

## 🔍 今後の拡張案（検討中）

- 複数イベントの同時購読（例：`on: A, B -> void`）
- 一度だけ購読（one-shot handlers）
- 優先度や順序の制御（例：`priority = 10`）

---

## ✅ まとめ

| 機能                 | 構文例                                |
|----------------------|----------------------------------------|
| イベント定義         | `event OnPush: HandlerType;`           |
| ハンドラ購読         | `OnPush += HandlePush;`                |
| 自動購読関数         | `def Func() on: OnPush -> void {}`     |
| 無名ハンドラ         | `on: OnPush -> void {}`                |
| 購読解除             | `OnPush -= Func;` / `OnPush -= *;`     |
| スコープに従う購読   | 自動購読と無名ハンドラのみ            |
| 伝播停止             | `e.cancel();`                          |
