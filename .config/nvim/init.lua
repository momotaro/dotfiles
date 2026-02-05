-- ============================================
-- Plugin Manager (lazy.nvim)
-- ============================================
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

-- ============================================
-- 基本設定
-- ============================================
vim.g.loaded_perl_provider = 0

vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.clipboard = 'unnamed,unnamedplus'

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

--カーソルキーで行末／行頭の移動可能に設定
vim.opt.whichwrap:append 'b'
-- コマンドライン補完を拡張モードにする
vim.opt.wildmode = 'list:longest,full'

-- 日本語ヘルプを使う
vim.opt.helplang = 'ja'

-- Yanking
vim.opt.shada:append '!'

-- ============================================
-- バックアップ設定
-- ============================================
vim.opt.swapfile = true
vim.opt.directory = home_dir .. "/.vim_swap"
vim.opt.undofile = true
vim.opt.undodir = home_dir .. "/.vim_undofile"

-- ============================================
-- 検索設定
-- ============================================
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

-- ============================================
-- 表示設定
-- ============================================
-- タイトルをウインドウ枠に表示する
vim.opt.title = true
-- 行番号を表示しない
vim.opt.number = false -- 後で必要に応じて設定
-- 入力中のコマンドをステータスに表示する
vim.opt.showcmd = true
-- 括弧入力時の対応する括弧を表示
vim.opt.showmatch = true
-- 対応する括弧の表示時間を2にする
vim.opt.matchtime = 3
-- 検索結果文字列のハイライトを有効にする
vim.opt.hlsearch = true
--カーソルがある画面上の行を強調する
vim.opt.cursorline = true
--外部のエディタで編集中のファイルが変更されたら、自動的に読み直す
vim.opt.autoread = true
-- (行がそれより長くなると、この幅を超えないように空白の後で改行される)を無効にする
vim.opt.textwidth = 0
-- ウィンドウの幅より長い行は折り返して、次の行に続けて表示する
vim.opt.wrap = true

vim.opt.list = true
vim.opt.listchars = 'tab:>-,trail:*,nbsp:+'

-- ============================================
-- インデント設定
-- ============================================
vim.opt.autoindent = true   --改行時に前の行のインデントを計測
vim.opt.smartindent = true  --改行時に入力された行の末尾に合わせて次の行のインデントを増減する
vim.opt.cindent = true      --Cプログラムファイルの自動
vim.opt.smarttab = true -- 新しい行を作った時に高度な自動インデントを行う
vim.opt.expandtab = true -- タブ入力を複数の空白に置き換える

vim.opt.tabstop = 2 -- タブを含むファイルを開いた際, タブを何文字の空白に変換するか
vim.opt.shiftwidth = 2 -- 自動インデントで入る空白数
vim.opt.softtabstop = 0 -- キーボードから入るタブの数

-- ============================================
-- ファイルタイプ設定
-- ============================================
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c' },
  command = 'setlocal sw=4 sts=4 ts=4 noexpandtab',
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'python', 'scala' },
  command = 'setlocal sw=4 sts=4 ts=4 expandtab',
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'ruby', 'zsh', 'json',
    'css', 'scss', 'sass',
    'javascript', 'javascriptreact',
    'typescript', 'typescriptreact',
  },
  command = 'setlocal sw=2 sts=2 ts=2 expandtab',
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, { pattern = '*.pcss', command = 'set filetype=postcss' })

-- ============================================
-- Autocmd
-- ============================================

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

-- ============================================
-- キーマップ - Normal mode
-- ============================================

-- init.luaリロード
vim.keymap.set(
  'n', ',,sc',
  function() vim.cmd('source ~/.config/nvim/init.lua') end,
  { noremap = true, silent = true }
)

-- : <-> ;
vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('n', ':', ';', { noremap = true })

-- eregex(検索でvery magicを使用)
vim.keymap.set('n', '/', '/\\v', { noremap = true })
vim.keymap.set('n', '?', '?\\v', { noremap = true })
vim.keymap.set('n', ',/', '/', { noremap = true })
vim.keymap.set('n', ',?', '?', { noremap = true })

-- ESCの2回押しでハイライト消去
vim.keymap.set('n', '<ESC><ESC>', ':nohlsearch<CR><ESC>', { silent = true })

-- Tabs
vim.keymap.set('n', 'tc', ':tabnew<CR>:tabmove<CR>', { silent = true })
vim.keymap.set('n', 'tk', ':tabclose<CR>', { silent = true })
vim.keymap.set('n', 'tn', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', 'tp', ':tabprevious<CR>', { silent = true })

for n = 1, 9 do
  vim.keymap.set('n', 't' .. n, ':' .. n .. 'tabnext<CR>', { silent = true })
end

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

-- 現在のバッファーのパスを表示
vim.keymap.set('n', ',fp', ':echo expand("%:p")<CR>', { silent = true })

-- open tig
vim.keymap.set('n', 'tig', ':w<CR>:te tig<CR>', { noremap = true })

-- Toggle window size
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
vim.keymap.set('n', 'cyy', '"+yy', { silent = true, noremap = true, desc = 'Copy line to clipboard' })
vim.keymap.set('n', 'cp', '"+p', { silent = true, noremap = true, desc = 'Paste from clipboard' })

-- Copy path (replacing copypath.vim)
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

-- ============================================
-- キーマップ - Insert mode
-- ============================================
-- Emacs like
vim.keymap.set('i', '<C-b>', '<Left>', { silent = true })
vim.keymap.set('i', '<C-f>', '<Right>', { silent = true })
vim.keymap.set('i', '<C-k>', '<Esc>lc$', { silent = true })
vim.keymap.set('i', '<C-e>', '<Esc>$a', { silent = true })
vim.keymap.set('i', '<C-a>', '<Esc>^i', { silent = true })

-- ============================================
-- キーマップ - Visual mode
-- ============================================
-- VSurround alias
vim.keymap.set('x', 's', 'S', { noremap = false })

-- Clipboard
vim.keymap.set('v', ',cy', '"+y', { silent = true, noremap = true, desc = 'Copy selection to clipboard' })

-- ============================================
-- キーマップ - Terminal mode
-- ============================================
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { silent = true })

-- ============================================
-- コマンド
-- ============================================

-- :AllMaps (定義されているキーマップを表示)
vim.cmd([[
command! -nargs=* -complete=mapping AllMaps map <args> | map! <args> | lmap <args>
]])

-- 現在のバッファーの相対パスをコピー
vim.cmd([[
command! CopyRelativePath let @*=join(remove( split( expand( '%:p' ), "/" ), len( split( getcwd(), "/" ) ), -1 ), "/") | echo "copied"
]])
