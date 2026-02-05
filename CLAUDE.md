# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> 日本語で回答すること。

## リポジトリ概要

macOS向けの個人dotfilesリポジトリ。シンボリックリンクで`$HOME`に配置して使用する（インストールスクリプトなし、手動symlink運用）。

## 構成

| 設定対象 | ファイル |
|---------|---------|
| Zsh | `.zshrc`, `.zshenv`, `.zsh_profile` |
| Neovim | `.config/nvim/` （詳細は `.config/nvim/CLAUDE.md` 参照） |
| Tmux | `.tmux.conf` |
| Alacritty | `.config/alacritty/alacritty.toml` |
| Git | `.gitconfig` |
| JetBrains IDE | `.ideavimrc` |
| Xcode | `.xvimrc` |
| Tig | `.tigrc` |
| Vimium | `vimium` |
| AutoKey | `.config/autokey/` |

## アーキテクチャ

### Zsh（シェル）

- **フレームワーク:** Zprezto（インストール済みの場合）
- **3ファイル構成:** `.zshenv`（PATH・環境変数） → `.zsh_profile`（エイリアス・ツール初期化） → `.zshrc`（プロンプト・補完・FZF連携・Vi mode）
- **主要ツール連携:** FZF（ファイル検索・履歴検索）、anyenv、direnv、Homebrew、pnpm
- **エイリアス:** `vim` → `nvim`、`docker-compose` → `docker compose`

### Neovim

Lua設定、lazy.nvimでプラグイン管理。モジュール別にファイル分割（ui/lsp/git/editor/languages/ai/testing）。
詳細は `.config/nvim/CLAUDE.md` を参照。

### Tmux

- **Prefix:** `Ctrl-T`（デフォルトの`Ctrl-B`から変更）
- **プラグインマネージャ:** TPM（`~/.tmux/plugins/tpm`）
- **ペイン移動:** `Ctrl-H/J/K/L`（Vim風）
- **コピーモード:** Vi mode

## 編集時の注意

- `.zshenv`にAPIキーが平文で含まれる。コミット時に新しいキーを追加しないこと
- `node_modules/`はリポジトリに含まれているが、dotfiles自体の機能には無関係（`package.json`はグローバルNode.jsパッケージ用）
- `lazy-lock.json`はNeovimプラグインのロックファイル。プラグイン変更時に自動更新される
