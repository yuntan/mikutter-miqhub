# MiqHub
mikutterのためのプラグインインストーラー

## インストール
```bash
curl https://github.com/yuntan/mikutter-miqhub/archive/master.tar.gz | tar -x && mv mikutter-miqhub-master ~/.mikutter/plugin/miqhub
```

## つかいかた
TODO

## Q&A
**Q.** GitHubに公開している自分のプラグインをMiqHubで検索できるようにするにはどうすればいいですか？  
**A.** 「mikutter-plugin」をリポジトリのトピックに追加して下さい．

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
