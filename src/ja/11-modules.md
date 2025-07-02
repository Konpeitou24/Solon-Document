## モジュールと名前空間の仕組み

Solon言語ではコードの分割を2パターン使用し解決します。

- フォルダー/モジュール
  - 物理的な構造により依存関係を解決します。
  - 主にプロジェクト内の連携で使われます。
  - 自動で定義され、`from`句でフォルダーを、`import`でモジュールを取り込みます。
  - 特定のクラスのみを`pick`で取り込めます。`pick`したからといって、静的メソッドはクラス名を省けるわけではありません。
- 名前空間
  - 論理的な構造により依存関係を解決します。
  - `namespace`で定義し、`bring`で取り込みます。
### フォルダー/モジュール

「フォルダー」はメインのプログラムファイルからのディレクトリを、「モジュール」は一つ一つのファイルを表します。

例えば「io/console/output」というフォルダーに、
「`status.sn`」を作成した場合、以下の通りimportできます。

```Solon
from io/console/output import status;
```
こうすることにより、`status.sn`に作成された全てのクラスを「知っている」状態にできます。

`status.sn`にクラス`weather`と`feeling`を追加してみましょう。
```Solon
public class Weather {
  private let $current: str = string.empty;
  public def new(current: str) -> self {
    self.$current = $current;
  }
  public def write -> void {
    print($current);
  }
}

public class Feeling {
  private let $current: str = string.empty;
  public def new(current: str) -> self {
    self.$current = current;
  }
  public def write -> void {
    print($current);
  }
}
```

メインのプログラム`main.sn`でこれらをimportして実行します。
```Solon
from io/console/output import status

public def main(args: str[]) -> int32 {
  let today-weather = new Weather("clear");
  let today-feeling:  = new Feeling("happy");
}
```

この際のスラッシュ`/`に空白を空けてはなりません。
また、`""`で囲う必要もありません。

さらにstatus.snに以下のクラスを作成したとします。
- `public class Time`
  
このような名前はしばしば衝突を起こしやすく、必要としない場合は`import`したいと思わないはずです。

このような場合、必要なクラスのみをモジュールから引用できるよう、以下の通りに書き換えます。

```Solon
from io/console/output import status pick Weather, Feeling

public def main(args: str[]) -> int32 {
  let today-weather = new Weather("clear");
  let today-feeling: Feeling = new Feeling("happy");
}
```

また、1ファイルに1つのクラスを置く慣習に対応します。

例えば、先ほどの`status`モジュールの3つのクラスを、3つのファイルに分割したい場合を考えます。

ファイル名に`status.weather.sn`, `status.feeling.sn`, `status.time.sn`と三つに分け保存します。

この際、`.`以降は無視され、すべて`status`モジュールとして認識されます。

### 名前空間

外部へ提供する場合、クライアントコード側でディレクトリ構造を意識しながらモジュールを`import`,クラスを`pick`する作業は非常に酷なものがあります。

プロジェクト外部へコードを提供したり、もっと概念的にコードを管理するために`namespace`が存在します。

たとえば`food.sn`を作成し、その中に`namespace Meat`を作成したとします。

```Solon
namespace Meat {
  public class Chicken {
    public def BakeWithLava(baked_by: str) -> void {
      print($"The chicken was baked by {baked_by}.");
    }
  }
}
```

この場合モジュール`food`からは隠蔽され、`import food pick Chicken;`はエラーになります。

ではどのように`Chicken`を使うのか？ここで`bring`の登場です。

```Solon
bring Meat;
```

このように`bring`することで、名前空間に属する**すべて**の`class`を使用することができます。

まだ名前の衝突が気になりますか？

安心してください。`bring`句にも`pick`句が使えます。

```
bring Meat pick Chicken;
```

いずれでもクライアントコード側では、`Chicken`クラスを「知っている」状態にできます。

### さらなる衝突回避

使用したいモジュール名や名前空間が衝突してしまう場合、**エイリアス（別名）**を定義することで解決できます。

Solonでは`alias`句を使って、モジュールや名前空間にエイリアスを付与します。

```Solon
alias status = io/console/output/status;
alias Mt = Meat;
```

このようにエイリアスを定義した後、importやbringでエイリアス名を使うことができます。

```Solon
import status pick Weather;
bring Mt pick Chicken;

public def main(args: str[]) -> int32 {
  let current_weather = new status.Weather();
  let eating = new Mt.Chicken();
}
```

- `alias`はトップレベルでのみ利用でき、同じスコープ内で再定義しようとするとコンパイルエラーになります。
- メインファイル以外では、そのファイル内のみ有効なスコープとなります。

```Solon
alias status = io/console/output/status;
alias status = io/console/output/status; // エラー！再定義不可
```

この方式により、fromやbringとエイリアス定義が明確に分離され、構文の混乱や誤用を防げます。

### 循環参照について

モジュールや名前空間が互いにimportやbringし合う「循環参照」が発生すると、依存関係が複雑になり、正しくプログラムを構築できなくなります。

Solonでは循環参照が発生した場合、**コンパイル時にエラー**となり、ビルドが中断されます。

循環参照の例：
```Solon
// moduleA.sn
import moduleB;

// moduleB.sn
import moduleA;
```
このような状態は避け、依存関係が一方向になるように設計してください。

### キーワードのおさらい

- `from` … フォルダー（ディレクトリ）を指定してモジュールを取り込む際に使う句
- `alias` … モジュールや名前空間に別名（エイリアス）を付ける
- `import` … モジュールを取り込む
- `bring` … 名前空間を取り込む
- `pick` … モジュールや名前空間から特定のクラスや関数だけを選択して取り込む

このセクションで登場したキーワードをまとめました。必要に応じてこの一覧を参照してください。

## 配列

Solon言語の配列は基本的にイミュータブルであり、サイズの変更やが利用できません。

文字列も配列の一種のため、ここで紹介する内容が一部適用できます。

また、配列のインデックスは0から始まります。

定義方法は以下の通りです。

```Solon
let numbers: int32[] = [1, 2, 3, 4, 5];
let names: str[] = ["Alice", "Bob", "Charlie"];
```

このように、配列リテラルは角括弧（[ ]）で囲み、要素をカンマ区切りで記述します。

また、`$`を付けて、配列をミュータブルとして定義することも可能です。

```Solon
let numbers: int32$[] = $[1, 2, 3, 4, 5];
let names: str$[] = $["a", "b", "c"]; 
```

### 多次元配列

#### ジャグ配列

各行ごとに長さの違う配列は以下のように宣言します。

```Solon
let matrix int32[][] = [][];
let mut_matrix int32$[][] = $[][];
```

#### 矩形配列

各行、各列がすべて同じ長さの配列は以下のように宣言します。

```Solon
let table int32[,] = [,];
let table int32$[,] = $[,];
```

### インデックスアクセス

Solon言語では単一の値を配列から取り出す際にインデックスアクセスを行います。

```Solon
array[index];
```

例えば数値を複数格納する配列から特定の値を取り出す場合は以下の通りです。

```Solon
// 配列のインデックスアクセス
let numbers: int32[] = [10, 20, 30, 40, 50];
let first_number = numbers[0]; // 10
let third_number = numbers[2]; // 30
```

文字列型も配列のため、同様に値を取り出せます。

```Solon
// イミュータブルな文字列
let message: str = "Hello, Solon!";
let $first_message: char = message[0]; // "H"
// $first_message の型は、アクセス前の対応する char になる
```

### スライス

Solon言語では構文によるスライスをサポートします。

スライスされた配列は`let`変数に代入する際に型情報を必要とします。

これはスライス構文をシンタックスシュガーではなく独立した一機能として判断しているためです。

スライスされたイミュータブルな配列`[]`は常にコピーを返します。
スライスされたミュータブルな配列`$[]`は常にビューを返します。

半開区間（`start`を含み`end`を含まない）です。
`numbers[i..i + 1]` は、i 番目の要素のみを正確に指します。

```Solon
let arr: int32[] = [1, 2, 3, 4, 5];
let sub: int32[] = arr[1..4]; // [2, 3, 4]

let message: str = "Hello, Solon!";
let greeting: str = message[0..5]; // "Hello"
```

また、指定の場所から最後までを選ぶことも、最初から指定の場所までを選ぶことも可能です。

```Solon
let arr: int32[] = [1, 2, 3, 4, 5];
let sub_to_last: int32[] = arr[2..]; // [3, 4, 5]
let sub_from_first: int32[] = arr[..3]; // [1, 2, 3]
```

全てを選び、配列をコピーすることも可能です。

```Solon
let arr: int32[] = [1, 2, 3, 4, 5];
let copy: int32[] = arr[..]; // [1, 2, 3, 4, 5]
```

さらにSolonでは`:`によるstep値の指定をサポートします。

構文は`start..end`を基本とし、その後さらにコロン`:`とステップ値を追加して`[start..end:step]`とします。

- `start`: スライス開始インデックス（含む、0スタート）
- `end`: スライス終了インデックス（含まない、半開区間）
- `step`: 各要素を取り出す感覚。正の整数である必要がある。

```Solon
let numbers: int32[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// 1番目から9番目までを2つ飛ばしで取得
let every_other = numbers[0..9:2]; // [1, 3, 5, 7, 9]

// 偶数番目の要素をすべて取得（インデックス1から最後まで2つ飛ばし）
let even_indexed = numbers[1..:2]; // [2, 4, 6, 8, 10]
```

### 逆順配列

初期化時に`@reversed!`属性を付けた配列は、内容は通常通りリテラルで書かれた正順で存在しますが、その配列が論理的に扱われる際には要素が反対の順序で扱われます。

```Solon
@reversed!
let numbers: int32[] = [1, 2, 3, 4, 5];
// Solonのコンパイラは numbers という変数を見たときに、
// 内部的に「これは逆順にアクセスされるべき配列だ」と認識します。
let first_element: int32[] = numbers[0]; // -> 論理的に最初の要素は 5 なので、5 が返る
let second_element: int32[] = numbers[1]; // -> 論理的に2番目の要素は 4 なので、4 が返る
let sub_slice: int32[] = numbers[1..3]; // -> 論理的に2番目(4)から3番目(3)までなので、[4, 3] が返る
```

`@reversed!`の`!`は、この配列がリテラル通りの順序ではない、特殊な順序付けで初期化されることを示唆しています。

## 配列のクエリ構文について

Solon言語では、配列に対してクエリ構文が利用できます。

この機能は、配列の要素を柔軟かつ直感的に操作できるように設計されており、開発者が複雑なデータ操作を簡潔に記述できることを目的としています。

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

## 例外

Solon言語の例外は`throw`を使って発生します。

投げられる例外の型は、基底クラスのどこかに必ず`Exception`を含む必要があります。つまり`throw`で投げられる例外のインスタンスは必ず`Exception`継承クラスであるか、その子孫である必要があるわけです。

```Solon
// 基本的な例外を投げます
throw new Exception();
```

## 例外処理

- `try`
  - 例外が発生する可能性のある、メインの処理ロジックを記述する場所です。
  - このブロック内のコードは最初に実行されます。もし実行中に例外がスローされた場合、その例外で補足できる`catch`ブロックがあれば、そこに制御が移ります。
- `catch`
  - `try`ブロック内でスローされた特定の種類の例外を補足し、それに応じたエラー回復ロジックを記述する場所です。
  - `catch 変数名: 例外型名`の形式で、補足したい例外の型と、その例外インスタンスを保持する変数を指定します。変数が不要な場合は、`catch 例外型名`と記述できます。
  - 複数の`catch`ブロックを定義する場合は、より具体的な例外型（子クラス）から順に記述する必要があります。最初に一致した`catch`ブロックのみが実行されます。
- `finally`
  - `try`ブロック、または`catch`ブロックの実行後に、例外の有無にかかわらず必ず実行されるクリーンアップ処理を記述します。