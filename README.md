# hogeki

マウスの方向に砲台から弾を発射するミニゲーム(になる予定の何か)。
https://topostaro.github.io/hogeki/output/

クリックすると発射されて、赤い四角(ターゲット)を狙おう。
命中すると、新たなターゲットが出現する。

TODO:
- スコア表示をする
- 時間制限を設ける
- スコアに応じて、ターゲットの大きさを変化させる

自分のPCで動かすには、Elmをインストール(https://guide.elm-lang.org/install/elm.html) してから、
```
git clone https://github.com/topostaro/hogeki
cd hogeki
elm make src/Main.elm --output=output/main.js
```
