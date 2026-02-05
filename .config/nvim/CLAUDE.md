# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

**Plugin Manager:** lazy.nvim（init.luaでブートストラップ）
**Config Language:** Lua 5.1 (Neovim Lua)
**Entry Point:** `init.lua` → plugins/ → 言語別モジュール

### ファイル構成

```
nvim/
├── init.lua               # コア設定、キーマップ、autocmd
├── lua/
│   ├── plugins/
│   │   ├── init.lua       # プラグインモジュールのimport
│   │   ├── ui.lua         # UI/表示系（colorscheme, tree, lualine等）
│   │   ├── lsp.lua        # LSP/補完（Mason, nvim-cmp, treesitter）
│   │   ├── git.lua        # Git関連（fugitive, gitgutter, blame）
│   │   ├── editor.lua     # 編集支援（surround, comment, motion等）
│   │   ├── languages.lua  # 言語固有（Ruby, Markdown, Prettier等）
│   │   ├── ai.lua         # AI支援（Copilot, Agentic, Translator）
│   │   └── testing.lua    # テスト（neotest, coverage）
│   └── golang/            # Go専用設定
└── lazy-lock.json         # プラグイン依存ロックファイル
```

## 主要システム

| システム | 実装 |
|---------|------|
| LSP/補完 | Mason + nvim-lspconfig + nvim-cmp |
| ファイル探索 | nvim-tree.lua |
| Git操作 | Fugitive, GitGutter, LazyGit |
| AI支援 | Copilot + Agentic.nvim |
| テスト | neotest + neotest-go |

## Go開発

Go開発に特化した設定が`lua/golang/init.lua`にある：

- **テストファイル切替:** `,A`（`_test.go`とソースを切替）
- **保存時import整理:** LSP autocmdで自動実行
- **インデント:** 4スペース、タブ展開なし

## 重要なキーマップ

| キー | 動作 |
|------|------|
| `,,sc` | init.luaをホットリロード |
| `,,g` | LazyGit切替 |
| `,,at` | Agentic Chat切替 |
| `,A` | テストファイル切替（Go） |
| `ff` | FZFファイル検索 |
| `gd` | LSP定義へジャンプ |
| `gi` | LSP実装へジャンプ |
| `gr` | LSP参照表示 |
| `;`/`:` | 入れ替え（`;`でコマンドモード） |

## プラグイン追加方法

適切なカテゴリのファイル（`lua/plugins/*.lua`）にlazy.nvim形式で追加：

```lua
{
  "author/plugin-name",
  event = "VeryLazy",  -- 遅延読み込み
  config = function()
    require("plugin-name").setup({})
  end,
}
```

## 対応言語

Go, Python, Ruby, JavaScript, TypeScript, Rust, Scala, JSON, YAML, HTML, Markdown, Bash, Lua

各言語のインデント設定は`init.lua`のautocmd内で定義。

## 注意事項

- Coc.nvimからNative LSP + Masonへ移行済み
- coc-settings.jsonは削除済み（使用しないこと）
- VimFilerからnvim-tree.luaへ移行済み
- Tree-sitterでシンタックスハイライトを担当（個別のシンタックスプラグインは不要）
