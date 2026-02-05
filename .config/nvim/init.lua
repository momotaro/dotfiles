vim.keymap.set(
  'n', ',,sc',
  function() vim.cmd('source ~/.config/nvim/init.lua') end,
  { noremap = true, silent = true }
)

local home_dir = os.getenv("HOME")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = require('plugins')
require('lazy').setup(plugins)

require('golang')

-- 基本的な設定
-- ----------------------------------------------------
local py2_command = '(type pyenv &>/dev/null && echo -n "$(pyenv root)/versions/neovim2/bin/python") || echo -n $(which python2)'
local py3_command = '(type pyenv &>/dev/null && echo -n "$(pyenv root)/versions/neovim3/bin/python") || echo -n $(which python3)'
vim.g.python_host_prog = vim.fn.system(py2_command)
vim.g.python3_host_prog = vim.fn.system(py3_command)
vim.g.loaded_perl_provider = 0

vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.clipboard = 'unnamed,unnamedplus'

vim.opt.encoding = 'UTF-8'
vim.opt.fileencodings = 'UTF-8,sjis'
vim.opt.guifont = '*'

vim.opt.termguicolors = true

-- 起動時のメッセージを表示しない
vim.opt.shortmess:append 'I'

-- folding
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false

-- 改行コードの自動認識
vim.opt.fileformats = 'unix,mac,dos'

--カーソルキーで行末／行頭の移動可能に設定"
vim.opt.whichwrap:append 'b'
-- バックスペースキーで削除できるものを指定
-- indent  : 行頭の空白
-- eol     : 改行
-- start   : 挿入モード開始位置より手前の文字
vim.opt.backspace = 'indent,eol,start'

-- vim.opt.expandtab = true -- 後でファイルタイプごとに設定

-- 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
-- （インデント設定は下部の「Configure filetype」セクションで一括設定）

-- 行数表示
-- vim.opt.nu = true -- 後で必要に応じて設定
-- バッファを切替えてもundoの効力を失わない
vim.opt.hidden = true
-- コマンドライン補完を拡張モードにする
vim.opt.wildmode = 'list:longest,full'

-- 日本語ヘルプを使う
vim.opt.helplang = 'ja'

-- バックアップ関係
-- ----------------------------------------------------
vim.opt.swapfile = true
vim.opt.directory = home_dir .. "/.vim_swap"
vim.opt.undofile = true
vim.opt.undodir = home_dir .. "/.vim_undofile"
-- vim.opt.backup = true
-- vim.opt.backupdir = "~/.backup"

-- 検索関係
-- ----------------------------------------------------
-- コマンド、検索パターンを100個まで履歴に残す
vim.opt.history = 100
-- 検索の時に大文字小文字を区別しない
vim.opt.ignorecase = true
-- 検索の時に大文字が含まれている場合は区別して検索する
vim.opt.smartcase = true
-- 最後まで検索したら先頭に戻る
vim.opt.wrapscan = true
-- インクリメンタルサーチを使わない
vim.opt.incsearch = false

-- 表示関係
-- ----------------------------------------------------
-- タイトルをウインドウ枠に表示する
vim.opt.title = true
-- 行番号を表示しない
vim.opt.number = false -- 後で必要に応じて設定
-- ルーラーを表示
vim.opt.ruler = true
-- 入力中のコマンドをステータスに表示する
vim.opt.showcmd = true
-- ステータスラインを常に表示（グローバルステータスライン: 上部で laststatus=3 に設定済み）
-- 括弧入力時の対応する括弧を表示
vim.opt.showmatch = true
-- 対応する括弧の表示時間を2にする
vim.opt.matchtime = 3
-- 検索結果文字列のハイライトを有効にする
vim.opt.hlsearch = true
-- コメント文の色を変更
vim.cmd('highlight Comment ctermfg=DarkCyan')
--カーソルがある画面上の行を強調する
vim.opt.cursorline = true
--外部のエディタで編集中のファイルが変更されたら、自動的に読み直す
vim.opt.autoread = true
-- (行がそれより長くなると、この幅を超えないように空白の後で改行される)を無効にする
vim.opt.textwidth = 0
-- ウィンドウの幅より長い行は折り返して、次の行に続けて表示する
vim.opt.wrap = true
-- ステータスラインに表示する情報の指定
vim.opt.statusline = [[%n:%y%F\|%{(&fenc!=''?&fenc:&enc).'\|'.&ff.'\|'}%m%r%=<%l/%L:%p%%>]]

-- カレントウィンドウにのみ罫線を引く
vim.api.nvim_create_augroup('cch', { clear = true })
vim.api.nvim_create_autocmd('WinLeave', {
  group = 'cch',
  pattern = '*',
  callback = function() vim.opt_local.cursorline = false end,
})
vim.api.nvim_create_autocmd({'WinEnter', 'BufRead'}, {
  group = 'cch',
  pattern = '*',
  callback = function() vim.opt_local.cursorline = true end,
})

-- 保存時にディレクトリがない場合は、自動的に作成する
vim.api.nvim_create_augroup('vimrc-auto-mkdir', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    local filepath = vim.fn.expand('%:p')
    local dir = vim.fn.fnamemodify(filepath, ':h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
      vim.notify(string.format('Created directory: %s', dir), vim.log.levels.INFO, {})
    end
  end,
})

-- syntax enableを実行
vim.keymap.set('n', ',syn', ':syntax enable<CR>', { noremap = true, silent = true })

-- : <-> ;
vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('n', ':', ';', { noremap = true })

-- Key map for Insert mode
-- ------------------------------------
-- Emacs like
vim.keymap.set('i', '<C-b>', '<Left>', { silent = true })
vim.keymap.set('i', '<C-f>', '<Right>', { silent = true })
-- Etc
vim.keymap.set('i', '<C-k>', '<Esc>lc$', { silent = true })
vim.keymap.set('i', '<C-e>', '<Esc>$a', { silent = true })
vim.keymap.set('i', '<C-a>', '<Esc>^i', { silent = true })
-- VSurround alias
vim.keymap.set('x', 's', 'S', { noremap = false }) -- xmap は noremap デフォルト false

-- Hilight
-- ------------------------------------
--tab文字も区別されずにハイライトされるので、区別したいときはTab文字の表示を別に設定する必要がある。
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.cmd('syntax match SOLSpace "^\\s\\+" display containedin=ALL')
    vim.cmd('highlight SOLSpace term=underline ctermbg=darkblue')
  end,
})

--全角スペースをハイライトさせる。
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.cmd('syntax match JISX0208Space "　" display containedin=ALL')
    vim.cmd('highlight JISX0208Space term=underline ctermbg=darkblue')
  end,
})

-- ステータスラインの色
vim.cmd('highlight StatusLine term=NONE cterm=NONE ctermfg=black ctermbg=white')

-- add filetypes
-- -----------------------------------
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, { pattern = '*.pcss', command = 'set filetype=postcss' })

vim.opt.list = true
vim.opt.listchars = 'tab:>-,trail:*,nbsp:+'

-- eregex(検索、置換でRubyの正規表現が可能)
-- ----------------------------------------------------
vim.keymap.set('n', '/', '/\\v', { noremap = true })
vim.keymap.set('n', '?', '?\\v', { noremap = true })
vim.keymap.set('n', ',/', '/', { noremap = true })
vim.keymap.set('n', ',?', '?', { noremap = true })

-- Tabs
-- ----------------------------------------------------
vim.keymap.set('n', 'tc', ':tabnew<CR>:tabmove<CR>', { silent = true })
vim.keymap.set('n', 'tk', ':tabclose<CR>', { silent = true })
vim.keymap.set('n', 'tn', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', 'tp', ':tabprevious<CR>', { silent = true })

-- jump
for n = 1, 9 do
  vim.keymap.set('n', 't' .. n, ':' .. n .. 'tabnext<CR>', { silent = true })
end

-- Yanking
vim.opt.shada:append '!'

-- ESCの2回押しでハイライト消去
vim.keymap.set('n', '<ESC><ESC>', ':nohlsearch<CR><ESC>', { silent = true })

-- 行頭 -> 非空白行頭 -> 行末をローテートする
local function rotate_in_line()
  local c = vim.fn.col('.')
  local cmd = (c == 1) and '^' or '$'
  vim.cmd.normal(cmd)
  if c == vim.fn.col('.') then
    if cmd == '^' then
      vim.cmd.normal '$'
    else
      vim.cmd.normal '0'
    end
  end
end
vim.keymap.set('n', 'T', function() rotate_in_line() end, { silent = true })

-- :AllMaps (定義されているキーマップを表示)
-- ----------------------------------------
vim.cmd([[
command! -nargs=* -complete=mapping AllMaps map <args> | map! <args> | lmap <args>
]])

-- 現在のバッファーのパスを表示
-- ----------------------------------------
vim.keymap.set('n', ',fp', ':echo expand("%:p")<CR>', { silent = true })

-- 現在のバッファーの相対パスをコピー
-- ----------------------------------------
vim.cmd([[
command! CopyRelativePath let @*=join(remove( split( expand( '%:p' ), "/" ), len( split( getcwd(), "/" ) ), -1 ), "/") | echo "copied"
]])

-- open tig
-- ----------------------------------------
vim.keymap.set('n', 'tig', ':w<CR>:te tig<CR>', { noremap = true })

-- ----------------------------------------
-- Terminal mode
-- ----------------------------------------
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { silent = true })

-- ----------------------------------------
-- Plugins
-- ----------------------------------------

vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

-- Qfreplace
-- ----------------------------------------
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function() vim.keymap.set('n', ',r', ':Qfreplace<CR><ESC>', { noremap = true, silent = true }) end,
})

-- --------------------------------------------
-- Configure filetype
-- --------------------------------------------

-- indent
-- --------------------------------------------
vim.opt.autoindent = true   --改行時に前の行のインデントを計測
vim.opt.smartindent = true  --改行時に入力された行の末尾に合わせて次の行のインデントを増減する
vim.opt.cindent = true      --Cプログラムファイルの自動
vim.opt.smarttab = true -- 新しい行を作った時に高度な自動インデントを行う
vim.opt.expandtab = true -- タブ入力を複数の空白に置き換える

vim.opt.tabstop = 2 -- タブを含むファイルを開いた際, タブを何文字の空白に変換するか
vim.opt.shiftwidth = 2 -- 自動インデントで入る空白数
vim.opt.softtabstop = 0 -- キーボードから入るタブの数

if vim.fn.has('autocmd') then
  -- ファイルタイプの検索を有効にする
  vim.cmd('filetype plugin on')
  -- ファイルタイプに合わせたインデントを利用
  vim.cmd('filetype indent on')
  -- sw=shiftwidth, sts=softtabstop, ts=tabstop, et=expandtabの略
  vim.api.nvim_create_autocmd('FileType', { pattern = 'c', command = 'setlocal sw=4 sts=4 ts=4 noexpandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'html', command = 'setlocal sw=4 sts=4 ts=4 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'ruby', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'zsh', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'python', command = 'setlocal sw=4 sts=4 ts=4 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'scala', command = 'setlocal sw=4 sts=4 ts=4 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'json', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'css', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'scss', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'sass', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'js', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'jsx', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'javascript', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'javascriptreact', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'ts', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'tsx', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'typescript', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
  vim.api.nvim_create_autocmd('FileType', { pattern = 'typescriptreact', command = 'setlocal sw=2 sts=2 ts=2 expandtab' })
end

-- --------------------------------------------
-- Enable omni completion.
-- --------------------------------------------
vim.keymap.set('i', '<Nul>', '<C-Space>')
vim.keymap.set('i', '<C-Space>', '<C-x><C-o>')

-- --------------------------------------------
-- Script
-- --------------------------------------------

-- Toggle window size
-- --------------------------------------------
vim.g.toggle_window_size = 0
local function toggle_window_size()
  if vim.g.toggle_window_size == 1 then
    vim.cmd('wincmd =')
    vim.g.toggle_window_size = 0
  else
    vim.cmd('resize')
    vim.cmd('vertical resize')
    vim.g.toggle_window_size = 1
  end
end
vim.keymap.set('n', 'M', toggle_window_size, { noremap = true })

-- Clipboard operations (replacing vim-fakeclip)
-- --------------------------------------------
vim.keymap.set('n', 'cyy', '"+yy', { silent = true, noremap = true, desc = 'Copy line to clipboard' })
vim.keymap.set('n', 'cp', '"+p', { silent = true, noremap = true, desc = 'Paste from clipboard' })
vim.keymap.set('v', ',cy', '"+y', { silent = true, noremap = true, desc = 'Copy selection to clipboard' })

-- Copy path (replacing copypath.vim)
-- --------------------------------------------
vim.keymap.set('n', ',cp', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  print('Copied: ' .. path)
end, { silent = true, noremap = true, desc = 'Copy full path' })

vim.keymap.set('n', ',cf', function()
  local filename = vim.fn.expand('%:t')
  vim.fn.setreg('+', filename)
  print('Copied: ' .. filename)
end, { silent = true, noremap = true, desc = 'Copy filename' })
