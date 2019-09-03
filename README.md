# MiqHub
mikutterのためのプラグインインストーラー

## インストール
```bash
curl -L https://github.com/yuntan/mikutter-miqhub/archive/master.tar.gz | tar -xz && mv mikutter-miqhub-master ~/.mikutter/plugin/miqhub
```

## つかいかた
「Worldを追加 > GitHub」を開きます．指定されたURLを開き，「Generate new token」を押します．

![Generate new token](https://i.gyazo.com/665be8f29214d4e3e0b09a64ed1f568c.png)

Scopeは何も選択せずに「Generate token」を押します．

![Generate new token](https://i.gyazo.com/d65ccf4f43c5ff26b2e31b02b4cec655.png)

表示されたtokenをmikutterに貼り付けて，Worldの追加を完了します．ここで一度再起動して下さい．右下にアイコンが追加されるのでそれを押します．

![アイコン](https://i.gyazo.com/00804c82bcff9c8a0b71ee6567da6bb2.png)]

プラグインの一覧が表示されます．右クリックして「…をインストール」でインストールします．

![プラグインの一覧](https://i.gyazo.com/f712f3d6b347f90372e00818952f9bdb.png)]

## Q&A
**Q.** GitHubに公開している自分のプラグインをMiqHubで検索できるようにするにはどうすればいいですか？  
**A.** 「mikutter-plugin」をリポジトリのトピックに追加して下さい．リポジトリに`.mikutter.yml`が含まれていることを確認して下さい．

![topic:mikutter-plugin](https://i.gyazo.com/6eeb0e15c22e038b66df60800d766318.png)

**Q.** MiqHubでインストールしたプラグインが動きません．  
**A.** プラグインの対象バージョンと依存関係を確認して下さい．MiqHubの今のバージョンは対象バージョンと依存関係を確認しません．

## 未実装の機能
- かわいいアイコン
- システムメッセージ
- 対象バージョン・依存関係の確認
- 更新コマンド
- 自動更新（opt-out）
- subpartsでインストール済み・更新の情報を表示
- star, forkしたユーザー一覧の取得・表示
- プラグイン一覧をStar数順に並び替える機能
- Starを付けたプラグインを一括インストールする機能
