# Generic State Machine Library for C++ :: チュートリアル


Hello World!
ストップウオッチ
## Hello World!

### 状態遷移図

// 紛失

### コード

```
01: #include <iostream>
02: #include "GenericStateMachine.h"
03: 
04: using namespace statemachinecxx_sourceforge_jp;
05: 
06: struct param {};                // イベントパラメータ
07: struct result {};               // 処理結果
08: 
09: // 状態コンテナクラス
10: struct Greeting {
11:     // ヘルパーマクロ(おっとっと! 看板に偽りあり、ですね ;-)
12:     DECLARE_StateContainer(Greeting, param, result, entryPoint);
13:     // 引数1：状態コンテナクラス名
14:     // 引数2：イベントパラメータ型名
15:     // 引数3：処理結果型名
16:     // 引数4：初期状態関数
17: 
18:     Greeting() {
19:         std::cout << "construct Greeting" << std::endl;
20:     }
21: 
22:     ~Greeting() {
23:         std::cout << "destruct Greeting" << std::endl;
24:     }
25: 
26:     // 状態関数 -- イベントを引数に取り、状態を返す
27:     State entryPoint(const Event& event) {
28:         switch(event) {
29:         case ENTRY_EVENT:       // 入場時アクション
30:             std::cout << "Hello World!" << std::endl;
31:             return 0;
32:         case EXIT_EVENT:        // 退場時アクション
33:             std::cout << "Bye Bye World!" << std::endl;
34:             return 0;
35:         }
36: 
37:         // 処理しなかったイベントは上位状態(super state)で
38:         // ハンドリングさせる
39:         return State::Super(&Greeting::TopState);
40:         // TopState は DECLARE_StateContainer が定義している
41:     }
42: };
43: 
44: int main(int argc, char** argv) {
45:     std::cout << 1 << std::endl;
46: 
47:     // 状態機械を実体化する
48:     GenericStateMachine<Greeting> greeting;
49: 
50:     std::cout << 2 << std::endl;
51: 
52:     // 起動
53:     greeting.Start();
54: 
55:     std::cout << 3 << std::endl;
56: 
57:     return 0;
58: }
```

実行結果

```
1
construct Greeting
2
Hello World!
3
Bye Bye World!
destruct Greeting
```

### 解説
| 行番号    | 説明 |
|-----------|------|
| 1-2       | ライブラリが提供するのは、`"GenericStateMachine.h"` だけです。 |
| 4         | ライブラリの名前空間です。 |
| 6-7       | イベントのパラメータと、処理結果をカスタマイズできます。<br>このサンプルでは使わないので、空の構造体にしておきます。 |
| 12        | 状態コンテナクラスに必要な型や関数を定義するヘルパーマクロです。以下の型を定義します。
```cpp
 typedef GenericState<状態コンテナクラス名> State;
 typedef GenericEvent<イベントパラメータ型名> Event;
 typedef State (状態コンテナクラス名::*Handler)(const Event&);
 typedef 処理結果型名 Output;
 ``` 

また、最上位の状態関数も定義します。

```cpp
State TopState(const Event& event) {
switch(event) {
    case INIT_EVENT:
        return State::Initial(&状態コンテナクラス名::初期状態関数);
    }
    return 0;
}
```
ヘルパーマクロの展開結果は、`public` である必要があります。

| 行番号    | 説明 |
|-----------|------|
| 18-24     | コンストラクタとデストラクタです。 |
| 27        | 状態関数です。状態関数のアドレスは、ヘルパーマクロの定義した `Handler` 型変数に格納できます。 |
| 28        | `Event` クラスの **`int operator()`** を使ってイベントを判別します。 |
| 29-31     | 状態に入る時に発生するイベントです。**イベントを処理をした場合は必ず 0** を返します。<br>状態関数のお約束です。 |
| 32-34     | 状態から抜ける時に発生するイベントです。**イベントを処理をした場合は必ず 0** を返します。<br>状態関数のお約束です。 |
| 37-40     | 処理しなかったイベントに対しては、必ず **`State::Super(上位の状態関数のアドレス)`** を返します。<br>状態関数のお約束です。 |
| 47-48     | 状態機械を `Greeting` で実体化します。`Greeting` のコンストラクタが実行されます。 |
| 52-53     | **`Start()`** で初期遷移を実行します。`TopState` から `entryPoint` へと状態遷移が行なわれます。<br>`entryPoint` に対して `ENTRY` イベントが転送されます。 |
| 57-58     | `entryPoint` に対して `EXIT` イベントが転送されます。<br>最後に、`Greeting` のデストラクタが呼び出されます。 |


## ストップウォッチ

STARTSTOP と RESET ボタンを備えたストップウオッチのモデルです。

### 状態遷移図
(紛失)

### コード

```
01: #include <iostream>
02: #include "GenericStateMachine.h"
03: 
04: using namespace statemachinecxx_sourceforge_jp;
05: 
06: struct param {};                // イベントパラメータは使わない
07: struct result { int elapsed; }; // 処理結果
08: 
09: // ユーザー定義イベント
10: enum {
11:     STARTSTOP = USER_EVENT,
12:     RESET,
13: };
14: 
15: struct StopWatch {
16:     // ヘルパーマクロ
17:     DECLARE_StateContainer(StopWatch, param, result, Stopped);
18: 
19:     // 結果を初期化
20:     StopWatch() { result_.elapsed = 0; }
21: 
22:     // 停止状態
23:     State Stopped(const Event& event) {
24:         switch(event) {
25:         case STARTSTOP:         // 状態遷移
26:             std::cout << "*** start ***" << std::endl;
27:             return State::Transition(&StopWatch::Running);
28:         case RESET:             // 内部遷移(リセット)
29:             std::cout << "*** reset ***" << std::endl;
30:             result_.elapsed = 0;
31:             return 0;
32:         }
33: 
34:         return State::Super(&StopWatch::TopState);
35:     }
36: 
37:     // 計測状態
38:     State Running(const Event& event) {
39:         switch(event) {
40:         case ENTRY_EVENT:       // 計測を開始
41:             start_ = time(0);
42:             return 0;
43:         case EXIT_EVENT:        // 計測を終了
44:             result_.elapsed += time(0) - start_;
45:             std::cout << "RESULT: " << result_.elapsed << std::endl;
46:             return 0;
47:         case STARTSTOP:         // 状態遷移
48:             return State::Transition(&StopWatch::Stopped);
49:         case RESET:             // 内部遷移(LAP 計測)
50:             std::cout << "LAP: " << time(0) - start_ + result_.elapsed << std::endl;
51:             return 0;
52:         }
53: 
54:         return State::Super(&StopWatch::TopState);
55:     }
56: 
57:     // 処理結果
58:     const Output& Result() const {
59:         return result_;
60:     }
61: 
62: private:
63:     result result_;
64:     time_t start_;
65: };
66: 
67: int main(int argc, char** argv) {
68:     GenericStateMachine<StopWatch> sw;
69: 
70:     sw.Start();
71: 
72:     while(true) {
73:         char ch;
74:         std::cout << "command(s:start/stop, r:reset, q:quit)> ";
75:         std::cin >> ch;
76:         if(ch == 'q') break;
77:         switch(ch) {
78:         case 's':
79:             sw.Dispatch(STARTSTOP);
80:             break;
81:         case 'r':
82:             sw.Dispatch(RESET);
83:             break;
84:         }
85:     }
86: 
87:     std::cout << "Elapsed=" << sw.Result().elapsed << std::endl;
88: 
89:     return 0;
90: }
```

### 実行結果

```
$ ./a.out 
command(s:start/stop, r:reset, q:quit)> s
*** start ***
command(s:start/stop, r:reset, q:quit)> r
LAP: 2
command(s:start/stop, r:reset, q:quit)> r
LAP: 4
command(s:start/stop, r:reset, q:quit)> s
RESULT: 5
command(s:start/stop, r:reset, q:quit)> s
*** start ***
command(s:start/stop, r:reset, q:quit)> s
RESULT: 7
command(s:start/stop, r:reset, q:quit)> r
*** reset ***
command(s:start/stop, r:reset, q:quit)> s
*** start ***
command(s:start/stop, r:reset, q:quit)> s
RESULT: 2
command(s:start/stop, r:reset, q:quit)> q
Elapsed=2
$
```

### 解説

| 行番号    | 説明 |
|-----------|------|
| 7         | 処理結果型を定義してます。状態コンテナクラスの `Result()` メソッドでこの構造体の `const` 参照を得ることができます。 |
| 9-13      | ユーザーイベント用の識別子として `STARTSTOP` と `RESET` を定義しています。<br>`USER_EVENT` はライブラリが定義しているユーザーイベント用の初期値です。<br>この初期値によって、`ENTRY` や `EXIT` など他のライブラリ定数と衝突しないことを保証できます。 |
| 19-20     | 処理結果を初期化します。 |
| 25-27     | `STARTSTOP` イベントをハンドリングしています。状態遷移をする時のお約束は、<br>**`State::Transition(状態関数のアドレス)`** を返すことです。 |
| 28-31     | `RESET` イベントで経過時間を 0 にリセットします。 |
| 34        | 状態関数のお約束です。 |
| 40-42     | `ENTRY` イベントです。計測を開始します。 |
| 43-46     | `EXIT` イベントです。計測を終了します。 |
| 47-48     | `Stopped` に状態遷移しています。この次に、`EXIT` イベントが発生します。 |
| 49-51     | `RESET` イベントで `LAP` を計測しています。 |
| 54        | 状態関数のお約束です。 |
| 57-60     | 処理結果型への `const` 参照を返します。 |
| 68-70     | 実体化と初期遷移です。`Stopped` 状態に遷移します。 |
| 73-76     | コマンドを処理しています。 |
| 78-83     | **`Dispatch()`** を呼び出して、イベントを転送しています。 |
| 87        | **`Reseult()`** を呼び出して、処理結果を取得しています。 |


## ダウンロード

ライブラリ(修正 BSD ライセンス)

Copyright © 2006 Tomotaka SUWA All Rights Reserved.
