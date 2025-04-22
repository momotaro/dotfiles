return {
  -- 'Shougo/dein.vim', -- lazy.nvim manages itself

  'Shougo/context_filetype.vim',

  {
    'kristijanhusak/vim-hybrid-material',
    config = function()
      vim.cmd('set background=dark')
      vim.cmd('colorscheme hybrid_material')
      vim.g.enable_bold_font = 1
    end,
  },

  {
    'embear/vim-localvimrc',
    config = function()
      vim.g.localvimrc_persistent = 2
    end,
  },

  {
    'tpope/vim-obsession',
    config = function()
      vim.keymap.set('n', ',S', ':mksession!<CR><ESC>', { noremap = true })
    end,
  },

  {
    'Shougo/vimproc.vim',
    build = 'make',
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = 'float',
        size = 15,
        shell = '/bin/zsh',
        close_on_exit = true,
      })
    end
  },
  {
    "kdheepak/lazygit.nvim",
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        hidden = true
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap("n", ":G", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
    end,
  }, 
  {
    'jlanzarotta/bufexplorer',
    config = function()
      vim.keymap.set('n', ',be', '<Cmd>BufExplorer<CR>', { noremap = true })
      vim.keymap.set('n', ',bv', '<Cmd>BufExplorerVerticalSplit<CR>', { noremap = true })
      vim.keymap.set('n', ',bs', '<Cmd>BufExplorerSplit<CR>', { noremap = true })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        redirect = {
          view = "popup",
          filter = { event = "msg_show" },
        },
        notify = {
          view = "mini",
        },
        messages = {
          enabled = true, -- enables the Noice messages UI
          view = "mini", -- default view for messages
          view_error = "notify", -- default view for error messages
          view_warn = "notify", -- default view for warning messages
          view_history = "mini", -- view for :messages
          view_search = false, -- view for search count messages. Set to `false` to disable
        },
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
          view = 'mini',
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        views = {
          cmdline_popup = {
            position = {
              row = '50%',
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
          },
          popupmenu = {
            relative = "editor",
            position = {
              row = '50',
              col = "50%",
            },
            size = {
              width = 60,
              height = 50,
            },
            border = {
              style = "rounded",
              padding = { 0, 1 },
            },
            win_options = {
              winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
          },
        },
      })
    end,
  },

  {
    'bkad/CamelCaseMotion',
    config = function()
      vim.keymap.set('n', 'w', '<Plug>CamelCaseMotion_w', { silent = true })
      vim.keymap.set('n', 'b', '<Plug>CamelCaseMotion_b', { silent = true })
      vim.keymap.set('n', 'e', '<Plug>CamelCaseMotion_e', { silent = true })
      vim.keymap.set('n', 'ge', '<Plug>CamelCaseMotion_ge', { silent = true })
    end,
  },

  -- Code completion
  {
    'Shougo/neosnippet.vim',
    event = 'InsertCharPre',
    ft = 'snippet',
    dependencies = { 'Shougo/context_filetype.vim' },
    config = function()
      vim.g.neosnippet_snippets_directory = vim.fn.expand('~/.config/nvim/snippets')
      vim.g.neosnippet_enable_snipmate_compatibility = 1

      function _G.check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
      vim.keymap.set("i", "<C-n>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
      vim.keymap.set("i", "<C-p>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      vim.keymap.set("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      if vim.fn.has('conceal') == 1 then
        vim.opt.conceallevel = 2
        vim.opt.concealcursor = 'niv'
      end
    end,
  },

  'Shougo/neosnippet-snippets',

  {
    'neoclide/coc.nvim',
    lazy = false, -- coc.nvim は常時起動が推奨されます
    build = 'yarn && yarn build',
    config = function()
      vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', { silent = true })
      vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
      vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
      vim.keymap.set('n', 'gr', '<Plug>(coc-references)', { silent = true })
      vim.keymap.set('n', ',re', '<Plug>(coc-rename)', { silent = true })

      vim.api.nvim_create_autocmd('CursorHold', {
        pattern = '*',
        command = 'silent call CocActionAsync(\'highlight\')',
      })

      local function show_documentation()
        if vim.bo.filetype == 'vim' then
          vim.cmd('h ' .. vim.fn.expand('<cword>'))
        else
          vim.fn.CocAction('doHover')
        end
      end
      vim.keymap.set('n', 'K', show_documentation, { silent = true })

      vim.keymap.set('i', '<CR>', [[coc#pum#visible() ? coc#pum#confirm() : '<CR>']], { silent = true, expr = true })
      vim.keymap.set('i', '<C-f>', [[coc#pum#visible() ? coc#pum#confirm() : '<RIGHT>']], { silent = true, expr = true })

      vim.keymap.set('n', ',ex', '<Cmd>CocCommand explorer<CR>', { silent = true })
    end,
  },
  {
    'junegunn/fzf',
    build = './install.sh --all',
  },

  {
    'junegunn/fzf.vim',
    config = function()
      vim.keymap.set('n', 'ff', '<Cmd>GFiles<CR>', { noremap = true })
    end,
  },

  {
    'yuki-yano/fzf-preview.vim',
    branch = 'release/remote',
  },

  {
    'antoinemadec/coc-fzf',
    config = function()
      vim.keymap.set('n', 'cff', '<Cmd>CocFzfList<CR>', { noremap = true })
    end,
  },

  -- Lintter
  {
    'w0rp/ale',
    config = function()
      vim.g.ale_lint_on_enter = 1
      vim.g.ale_fix_on_save = 1
      vim.g.ale_lint_on_text_changed = 'never'
      vim.g.ale_set_loclist = 0
      vim.g.ale_set_quickfix = 0
      vim.g.ale_open_list = 0
      vim.g.ale_keep_list_window_open = 0
      vim.keymap.set('n', '<C-j>', '<Plug>(ale_next_wrap)', { silent = true })
      vim.keymap.set('n', '<C-k>', '<Plug>(ale_previous_wrap)', { silent = true })
      vim.g.ale_fixers = {}
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'material',
          component_separators = { left = '', right = ''},
          -- section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 5000,
            tabline = 1000,
            winbar = 1000,
          }
        },
      }
    end,
  },

  -- Git
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<Space>gd', '<Cmd>Gdiff<CR>', { noremap = true })
      vim.keymap.set('n', '<Space>gs', '<Cmd>Gstatus<CR><C-w>15+', { noremap = true })
      vim.keymap.set('n', '<Space>gl', '<Cmd>Glog<CR>', { noremap = true })
      vim.keymap.set('n', '<Space>ga', '<Cmd>Gwrite<CR>', { noremap = true })
      vim.keymap.set('n', '<Space>gc', '<Cmd>Gcommit<CR>', { noremap = true })
      vim.keymap.set('n', '<Space>gC', '<Cmd>Git commit --amend<CR>', { noremap = true })
      vim.keymap.set('n', '<Space>gb', '<Cmd>Gblame<CR>', { noremap = true })
    end,
  },

  {
    'airblade/vim-gitgutter',
    config = function()
      vim.opt.signcolumn = 'yes'
      vim.keymap.set('n', ',gg', '<Cmd>GitGutterToggle<CR>', { silent = true, noremap = true })
      vim.keymap.set('n', ',gh', '<Cmd>GitGutterLineHighlightsToggle<CR>', { silent = true, noremap = true })
    end,
  },

  -- Utils
  {
    'osyo-manga/vim-over',
    config = function()
      vim.keymap.set('n', '<Space>r', '<Cmd>OverCommandLine<CR>%s//g<Left><Left>', { silent = true, noremap = true })
      vim.keymap.set('v', '<Space>r', '<Cmd>OverCommandLine<CR>s//g<Left><Left>', { silent = true, noremap = true })
      vim.keymap.set('n', 'sub', '<Cmd>OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>', { silent = true, noremap = true })
    end,
  },

  {
    'vim-scripts/copypath.vim',
    config = function()
      vim.keymap.set('n', ',cp', '<Cmd>CopyPath<CR>', { silent = true, noremap = true })
      vim.keymap.set('n', ',cf', '<Cmd>CopyFileName<CR>', { silent = true, noremap = true })
    end,
  },

  {
    'scrooloose/nerdcommenter',
    config = function()
      vim.g.NERDCreateDefaultMappings = 0
      vim.g.NERDSpaceDelims = 1
      vim.keymap.set('n', ',c<Space>', '<Plug>NERDCommenterToggle', { noremap = true })
      vim.keymap.set('v', ',c<Space>', '<Plug>NERDCommenterToggle', { noremap = true })
      vim.keymap.set('v', ',cs', '<Plug>NERDCommenterSexy', { noremap = true })
    end,
  },
  'vim-scripts/AnsiEsc.vim',
  'vim-scripts/YankRing.vim',
  'vim-scripts/renamer.vim',
  'vim-scripts/grep.vim',
  'jiangmiao/auto-pairs',
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps  = {
          visual = "s",
          visual_line = "S",
        },
      })

    end
  },

  {
    'adelarsq/vim-matchit',
    dependencies = { 'tpope/vim-surround' }
  },
  {
    'h1mesuke/vim-alignta',
    config = function()
      vim.keymap.set('x', 'al', ':Alignta<Space>', { noremap = true })
    end,
  },

  {
    'kana/vim-fakeclip',
    config = function()
      vim.keymap.set('n', 'cyy', '<Home><Plug>(fakeclip-y)<End><ESC>', { silent = true, noremap = true })
      vim.keymap.set('n', 'cp', '"*p', { silent = true, noremap = true })
      vim.keymap.set('v', ',cy', '"*y', { silent = true, noremap = true })
    end,
  },
  {
    "kana/vim-smartchr",
    config = function()
      vim.cmd([[
        augroup MySmartchr
          autocmd!
          inoremap <buffer><expr> ? smartchr#one_of('?', ' ? ')
          inoremap <buffer><expr> : smartchr#one_of(':', '::', ' : ')

          autocmd FileType go inoremap <buffer><expr> : smartchr#one_of(':', ' := ', ' : ')

          " 演算子の間に空白を入れる
          autocmd FileType * inoremap <buffer><expr> < search('^#include\%#', 'bcn')? ' <': smartchr#one_of('<', ' << ', ' < ', '<<<')
          autocmd FileType * inoremap <buffer><expr> + smartchr#one_of(' + ', '++', '+')
          autocmd FileType * inoremap <buffer><expr> - smartchr#one_of('-', '--', ' - ')
          autocmd FileType * inoremap <buffer><expr> % smartchr#one_of(' % ', '%')
          autocmd FileType * inoremap <buffer><expr> * smartchr#one_of(' * ', '*')
          autocmd FileType * inoremap <buffer><expr> & smartchr#one_of('&', ' && ', ' & ')
          autocmd FileType * inoremap <buffer><expr> <Bar> smartchr#one_of('<Bar>', ' <Bar><Bar> ', ' <Bar> ')
          autocmd FileType * inoremap <buffer><expr> , smartchr#one_of(', ',',')

          " =の場合、単純な代入や比較演算子として入力する場合は前後にスペースをいれる。
          " 複合演算代入としての入力の場合は、直前のスペースを削除して=を入力
          autocmd FileType * inoremap <buffer><expr> =
            \ search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')?
            \ '<bs>= ' :
            \ search('\(*\<bar>!\)\%#', 'bcn')?
            \ '= ' : smartchr#one_of(' = ', ' == ', '=')

          " 下記の文字は連続して現れることがまれなので、二回続けて入力したら改行する
          autocmd FileType * inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')
          autocmd FileType * inoremap <buffer><expr> (<CR> smartchr#one_of('()<Left><cr><cr><Up><Tab>')

          " if文直後の(は自動で間に空白を入れる
          "inoremap <buffer><expr> ( search('\<\if\%#', 'bcn')? ' (  )': '('

          " アロー系演算子
          autocmd FileType * inoremap <buffer><expr> =~ smartchr#one_of(' =~ ')
          autocmd FileType * inoremap <buffer><expr> => smartchr#one_of(' => ')
          autocmd FileType * inoremap <buffer><expr> . smartchr#loop('.', '=>', '..', '...')

          "
          autocmd FileType ruby inoremap <buffer><expr> =
            \ search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
            \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
            \ : smartchr#one_of(' = ', ' == ', '=')

          " haml
          autocmd FileType haml inoremap <buffer><expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')?
            \ '<bs>= '
            \ : search('\(*\<bar>!\)\%#', 'bcn') ?
            \ '= '
            \ : smartchr#one_of('=', ' = ', ' == ')
          autocmd FileType haml inoremap <buffer><expr> => smartchr#one_of(' => ')
          autocmd FileType haml inoremap <buffer><expr> % smartchr#one_of('%', ' % ')

          " Reset
          "--------------------------------------------
          autocmd FileType eruby inoremap <buffer><expr> = ('=')
          autocmd FileType html inoremap <buffer><expr> = ('=')
          autocmd FileType slim inoremap <buffer><expr> = ('=')
            inoremap <buffer><expr> = ('=')
          autocmd FileType javascript,css inoremap <buffer><expr> * ('*')
        augroup END
      ]])
    end
  },
  {
    "echasnovski/mini.indentscope",
    config = function()
      require("mini.indentscope").setup({
        symbol = '▏',
      })
    end
  },
  {
    "rhysd/accelerated-jk",
    config = function()
      vim.cmd([[
        nmap j <Plug>(accelerated_jk_gj)
        nmap k <Plug>(accelerated_jk_gk)
      ]])
    end
  },
  {
    "alvan/vim-closetag",
    ft = { "html", "xml", "eruby", "html.twig", "riot" },
    config = function()
      vim.cmd([[
        let g:closetag_filenames = "*.html,*.xml,*.erb,*.tag"
      ]])
    end
  },
  {
    "jceb/vim-hier"
  },
  {
    "thinca/vim-quickrun",
    config = function()
      vim.cmd([[
        let g:quickrun_config = {'*': {'hook/time/enable': '1'},}
      ]])
    end
  },

  -- Langs
  -- Japanese doc
  {
    'vim-jp/vimdoc-ja',
    ft = 'help',
    config = function()
      vim.opt.helplang = 'ja,en'
    end,
  },

  -- Toml
  {
    'cespare/vim-toml',
    ft = 'toml',
  },

  -- JSON
  {
    'Shougo/unite.vim',
    ft = 'json',
  },

  -- Markdown
  {
    'tpope/vim-markdown',
    ft = { 'md', 'markdown' },
    config = function()
      vim.g.markdown_fenced_languages = { 'html', 'python', 'bash=sh' }
    end,
  },

  {
    'jxnblk/vim-mdx-js',
    ft = { 'markdown.mdx' },
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

  -- CSS
  {
    'hail2u/vim-css3-syntax',
    ft = 'css',
    config = function()
    end,
  },

  {
    'stephenway/postcss.vim',
    ft = 'postcss',
    config = function()
    end,
  },

  {
    'gcorne/vim-sass-lint',
    ft = { 'sass', 'scss' },
  },

  -- Javascript
  -- JS syntax
  {
    'othree/yajs.vim',
    dependencies = { 'w0rp/ale' },
    ft = { 'javascript', 'jsx', 'jsx.javascript' },
    config = function()
      vim.g.ale_fixers['javascript'] = { 'prettier-eslint' }
      -- vim.g.ale_javascript_prettier_use_local_config = 1
    end,
  },

  {
    'othree/es.next.syntax.vim',
    ft = { 'javascript', 'jsx', 'jsx.javascript' },
  },

  {
    'othree/javascript-libraries-syntax.vim',
    ft = { 'javascript', 'jsx', 'jsx.javascript' },
    config = function()
      vim.fn.execute[[
        function! EnableJavascript()
          " Setup used libraries
          let g:used_javascript_libs = 'jquery,underscore,react,flux,jasmine'
          let b:javascript_lib_use_jquery = 1
          let b:javascript_lib_use_underscore = 1
          let b:javascript_lib_use_react = 1
          let b:javascript_lib_use_flux = 1
          let b:javascript_lib_use_jasmine = 1
          let b:javascript_lib_use_vue = 1
        endfunction
        autocmd FileType javascript,jsx,jsx.javascript call EnableJavascript()
      ]]
    end,
  },

  {
    'MaxMEllon/vim-jsx-pretty',
    ft = { 'jsx', 'jsx.javascript' },
  },

  -- utils
  -- {
  --   'jason0x43/vim-js-indent',
  --   ft = { 'javascript', 'jsx', 'jsx.javascript' },
  --   config = function()
  --   end,
  -- },

  {
    'carlitux/deoplete-ternjs',
    ft = 'javascript',
  },

  -- Typescript
  {
    'leafgarland/typescript-vim',
    ft = { 'typescript', 'typescript.tsx' },
    config = function()
      vim.g.typescript_compiler_binary = 'tsc'
      vim.g.typescript_compiler_options = ''
      -- vim.g.typescript_indent_disable = 1
      -- vim.g.typescript_opfirst='\%([<>=,?^%|*/&]\|\([-:+]\)\1\@!\|!=\|in\%(stanceof\)\=\>\)'
    end,
  },

  -- {
  --   'aanari/vim-tsx-pretty',
  --   ft = { 'typescript', 'typescript.tsx' },
  -- },

  {
    'peitalin/vim-jsx-typescript',
    ft = { 'typescript', 'typescript.tsx' },
    dependencies = { 'leafgarland/typescript-vim' },
  },

  -- linter & formatter
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

  -- svelt
  {
    'evanleck/vim-svelte',
    ft = 'svelte',
  },

  -- vue
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

  --  AI
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.g.copilot_filetypes = { gitcommit = true }
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = "gemini-2.5-pro",
        timeout = 30000,
        temperature = 0,
        max_tokens = 4096,
      },
      mappings = {
        ask = ",,a",
        edit = ",,e",
        refresh = ",,r",
      }, 

      -- 動作設定
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = false,
        minimize_diff = true,
      },

      windows = {
        position = "right",
        wrap = true,
        width = 30,
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
        config = function()
require('nvim-treesitter.configs').setup({ highlight = { enable = true } })
        end,
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = { "VeryLazy" },
    lazy = false,
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      model = "gemini-2.5-pro",
      debug = true,
    },
    cofifg = function()
      require("copilot").setup({})
    end,
  },
}
