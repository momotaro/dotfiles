" 基本的な設定
"----------------------------------------------------
let g:python_host_prog = system('(type pyenv &>/dev/null && echo -n "$(pyenv root)/versions/neovim2/bin/python") || echo -n $(which python2)')
let g:python3_host_prog = system('(type pyenv &>/dev/null && echo -n "$(pyenv root)/versions/neovim3/bin/python") || echo -n $(which python3)')

set clipboard=unnamed,unnamedplus

set encoding=UTF-8
set fileencodings=UTF-8,sjis
set guifont=*

set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" 起動時のメッセージを表示しない
set shortmess+=I

" viとの互換性をとらない(vimの独自拡張機能を使う為)
set nocompatible

" folding
set foldmethod=indent
set nofoldenable

" 改行コードの自動認識
set fileformats=unix,mac,dos
" " ビープ音を鳴らさない
set vb t_vb=
"カーソルキーで行末／行頭の移動可能に設定"
set whichwrap=b
" バックスペースキーで削除できるものを指定
" indent  : 行頭の空白
" eol     : 改行
" start   : 挿入モード開始位置より手前の文字
set backspace=indent,eol,start

set expandtab

" 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
set smartindent
set autoindent

" 行数表示
"set nu
" バッファを切替えてもundoの効力を失わない
set hidden
" コマンドライン補完を拡張モードにする
set wildmode=list:longest,full

" 日本語ヘルプを使う
set helplang=ja

" バックアップ関係
"----------------------------------------------------
" バックアップをとらない
set nobackup
" ファイルの上書きの前にバックアップを作る
" (ただし、backup
" がオンでない限り、バックアップは上書きに成功した後削除される)
set nowritebackup
" バックアップをとる場合
"set backup
" バックアップファイルを作るディレクトリ
set backupdir=~/.backup
" スワップファイルを作るディレクトリ
set directory=~/.vim_swap
"Persistent undoを有効化(7.3)
set undofile
"アンドゥの保存場所(7.3)
set undodir=~/.vim_undofile

" 検索関係
"----------------------------------------------------
" コマンド、検索パターンを100個まで履歴に残す
set history=100
" 検索の時に大文字小文字を区別しない
set ignorecase
" 検索の時に大文字が含まれている場合は区別して検索する
set smartcase
" 最後まで検索したら先頭に戻る
set wrapscan
" インクリメンタルサーチを使わない
set incsearch

" 表示関係
"----------------------------------------------------
" タイトルをウインドウ枠に表示する
set title
" 行番号を表示しない
set nonumber
" ルーラーを表示
set ruler
" タブ文字を CTRL-I で表示し、行末に $ で表示する
set list
" 入力中のコマンドをステータスに表示する
set showcmd
" ステータスラインを常に表示
set laststatus=2
" 括弧入力時の対応する括弧を表示
set showmatch
" 対応する括弧の表示時間を2にする
set matchtime=3
" 検索結果文字列のハイライトを有効にする
set hlsearch
" コメント文の色を変更
highlight Comment ctermfg=DarkCyan
"カーソルがある画面上の行を強調する
set cursorline
"外部のエディタで編集中のファイルが変更されたら、自動的に読み直す
set autoread
" (行がそれより長くなると、この幅を超えないように空白の後で改行される)を無効にする
set textwidth=0
" ウィンドウの幅より長い行は折り返して、次の行に続けて表示する
set wrap
" ステータスラインに表示する情報の指定
set statusline=%n\:%y%F\
\|%{(&fenc!=''?&fenc:&enc).'\|'.&ff.'\|'}%m%r%=<%l/%L:%p%%>

" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

" 文字コードの設定
set encoding=UTF-8
set termencoding=UTF-8
set fileencoding=utf-8

"保存時にディレクトリがない場合は、自動的に作成する
augroup vimrc-auto-mkdir  " {{{
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)  " {{{
  if !isdirectory(a:dir) && (a:force ||
  \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
  endfunction  " }}}
augroup END  " }}}

" syntax enableを実行
nnoremap ,syn :<C-u>syntax enable<CR>

" : <-> ;
noremap ; :
noremap : ;

" Key map for Insert mode
"------------------------------------
" Emacs like
imap <silent> <C-p> <Up>
imap <silent> <C-n> <Down>
imap <silent> <C-b> <Left>
imap <silent> <C-f> <Right>
" Etc
inoremap <silent> <C-k> <Esc>lc$
inoremap <silent> <C-e> <Esc>$a
inoremap <silent> <C-a> <Esc>^i
" VSurround alias
xmap s S

" Hilight
"------------------------------------
"tab文字も区別されずにハイライトされるので、区別したいときはTab文字の表示を別に設定する必要がある。
function! SOLSpaceHilight()
  syntax match SOLSpace "^\s\+" display containedin=ALL
  highlight SOLSpace term=underline ctermbg=darkblue
endf

"全角スペースをハイライトさせる。
function! JISX0208SpaceHilight()
  syntax match JISX0208Space "　" display containedin=ALL
  highlight JISX0208Space term=underline ctermbg=darkblue
endf

" ステータスラインの色
highlight StatusLine term=NONE cterm=NONE ctermfg=black ctermbg=white

" add filetypes
"-----------------------------------
au BufNewFile,BufRead *.pcss setf postcss

set list
set listchars=tab:\¦_,trail:-,nbsp:%,eol:↲

" eregex(検索、置換でRubyの正規表現が可能)
"----------------------------------------------------
nnoremap / /\v
nnoremap ? ?\v
nnoremap ,/ /
nnoremap ,? ?

" Tabs
"----------------------------------------------------
nnoremap <silent> tc :<C-u>tabnew<CR>:tabmove<CR>
nnoremap <silent> tk :<C-u>tabclose<CR>
nnoremap <silent> tn :<C-u>tabnext<CR>
nnoremap <silent> tp :<C-u>tabprevious<CR>

" jump
for n in range(1, 9)
  execute 'nnoremap <silent> t'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" Yanking
set viminfo+=!

" ESCの2回押しでハイライト消去
nnoremap <silent> <ESC><ESC> :<C-u>nohlsearch<CR><ESC>

" 行頭 -> 非空白行頭 -> 行末をローテートする
function! s:rotate_in_line()
    let c = col('.')

    if c == 1
        let cmd = '^'
    else
        let cmd = '$'
    endif

    execute "normal! ".cmd

    if c == col('.')
        if cmd == '^'
            normal! $
        else
            normal! 0
        endif
    endif
endfunction
nnoremap <silent>T :<C-u>call <SID>rotate_in_line()<CR>

" :AllMaps (定義されているキーマップを表示)
"----------------------------------------
command!
\  -nargs=* -complete=mapping
\  AllMaps
\  map <args> | map! <args> | lmap <args>

" 現在のバッファーのパスを表示
"----------------------------------------
nnoremap <silent>,fp :<C-u>echo expand("%:p")<CR>

" 現在のバッファーの相対パスをコピー
"----------------------------------------
command! CopyRelativePath
\ let @*=join(remove( split( expand( '%:p' ), "/" ), len( split( getcwd(), "/" ) ), -1 ), "/") | echo "copied"

" open tig
"----------------------------------------
nnoremap tig :<C-u>w<CR>:te tig<CR>

"----------------------------------------
" Terminal mode
"----------------------------------------
tnoremap <silent> <ESC> <C-\><C-n>

"----------------------------------------
" Plugins
"----------------------------------------

if &compatible
  set nocompatible
endif

" dein.vimのディレクトリ
let s:dein_dir = expand('~/.config/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let g:dein#install_log_filename = s:dein_dir . '/dein.log'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir) " なければgit clone
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " 管理するプラグインを記述したファイル
  let s:toml = '~/.config/nvim/.dein.toml'
  let s:lazy_toml = '~/.config/nvim/.dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install(['vimproc.vim'])
  call dein#install(['vimproc.vim'])
endif

if dein#check_install()
  call dein#install()
endif
filetype plugin indent on
syntax enable

" Qfreplace
"----------------------------------------
autocmd FileType qf nnoremap <silent> ,r :<C-u>Qfreplace<CR><ESC>

" matchit
"--------------------------------------------
source $VIMRUNTIME/macros/matchit.vim
let b:match_words = '<.*:>, <.+></.+>,<div.*>:</div>, (module\|class\|def\|begin\|do\|if\|unless\|case\)\>:\<\(elsif\|when\|rescue\)\>:\<\(else\|ensure\)\>:\<end\>'


"--------------------------------------------
" Configure filetype
"--------------------------------------------

" indent
"--------------------------------------------
set cinoptions+=:0
au BufNewFile,BufRead *.yml    set filetype=yaml tabstop=2 shiftwidth=2
au BufRead,BufNewFile *.groovy set filetype=groovy tabstop=4 shiftwidth=4 softtabstop=4
au BufRead,BufNewFile *.gradle set filetype=groovy tabstop=4 shiftwidth=4 softtabstop=4
au BufRead,BufNewFile *.json set filetype=json tabstop=2 shiftwidth=2 softtabstop=2
au BufRead,BufNewFile *.xml set filetype=xml tabstop=4 shiftwidth=4 softtabstop=4
au BufRead,BufNewFile *.toml set filetype=toml tabstop=2 shiftwidth=2 softtabstop=2
au BufRead,BufNewFile slack://* set filetype=slack

"--------------------------------------------
" Enable omni completion.
"--------------------------------------------
imap <Nul> <C-Space>
imap <C-Space> <C-x><C-o>

"--------------------------------------------
" Script
"--------------------------------------------

" Toggle window size 
"--------------------------------------------
let g:toggle_window_size = 0
function! ToggleWindowSize()
  if g:toggle_window_size == 1
    exec "normal \<C-w>="
    let g:toggle_window_size = 0
  else
    :resize
    :vertical resize
    let g:toggle_window_size = 1
  endif
endfunction
nnoremap M :call ToggleWindowSize()<CR>
