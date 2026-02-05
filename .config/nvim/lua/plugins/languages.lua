return {
  -- Japanese doc
  {
    'vim-jp/vimdoc-ja',
    ft = 'help',
    config = function()
      vim.opt.helplang = 'ja,en'
    end,
  },

  -- Markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown", "md", "AgenticChat" },
      latex = { enabled = false },
    }
  },

  -- Web
  {
    'jparise/vim-graphql',
    ft = { 'graphql', 'qql', 'Relay.QL', 'js' },
  },
  {
    'othree/html5.vim',
    ft = { 'html', 'php', 'riot' },
  },

  -- Linter & Formatter
  {
    'prettier/vim-prettier',
    build = 'npm install',
    ft = { 'javascript', 'jsx.javascript', 'javascriptreact', 'typescriptreact', 'typescript', 'typescript.tsx', 'vue', 'css', 'scss', 'json', 'markdown', 'ruby', 'rb' },
    config = function()
      vim.fn.execute[[
        " @formatアノテーションを持ったファイルの自動フォーマットを無効にする
        let g:prettier#autoformat = 0

        " Prettierのパースエラーをquickfixに表示しない
        let g:prettier#quickfix_enabled = 0

        autocmd BufWritePre *.js,*.jsx,*.ts,*tsx,*.vue,*.css,*.scss,*.json,*.md,*rb PrettierAsync
      ]]
    end,
  },

  -- Svelte
  {
    'evanleck/vim-svelte',
    ft = 'svelte',
  },

  -- Vue
  {
    'posva/vim-vue',
    ft = 'vue',
  },

  -- Ruby
  {
    'vim-ruby/vim-ruby',
    ft = { 'ruby', 'eruby' },
  },
  {
    'tpope/vim-endwise',
    event = 'InsertEnter',
    ft = 'ruby',
  },
  {
    'tpope/vim-bundler',
    ft = 'ruby',
  },
  {
    'tpope/vim-rails',
    ft = { 'ruby', 'eruby' },
    config = function()
      vim.fn.execute[[
        autocmd FileType ruby nnoremap <silent> ,a :<C-u>A<CR><ESC>
        autocmd FileType ruby nnoremap <silent> ,at :<C-u>AT<CR><ESC>
        autocmd FileType ruby nnoremap <silent> ,av :<C-u>AV<CR><ESC>
        autocmd FileType ruby nnoremap <silent> ,as :<C-u>AS<CR><ESC>

        let g:surround_{char2nr("-")} = "<% \r %>"
        let g:surround_{char2nr("=")} = "<%= \r %>"
      ]]
    end,
  },

  -- Haskell
  {
    'neovimhaskell/haskell-vim',
    ft = { 'haskell' },
  },
}
