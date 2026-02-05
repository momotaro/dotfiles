return {
  -- Local vimrc
  {
    'embear/vim-localvimrc',
    config = function()
      vim.g.localvimrc_persistent = 2
    end,
  },

  -- Session
  {
    'tpope/vim-obsession',
    config = function()
      vim.keymap.set('n', ',S', ':mksession!<CR><ESC>', { noremap = true })
    end,
  },

  -- CamelCase Motion
  {
    'bkad/CamelCaseMotion',
    config = function()
      vim.keymap.set('n', 'w', '<Plug>CamelCaseMotion_w', { silent = true })
      vim.keymap.set('n', 'b', '<Plug>CamelCaseMotion_b', { silent = true })
      vim.keymap.set('n', 'e', '<Plug>CamelCaseMotion_e', { silent = true })
      vim.keymap.set('n', 'ge', '<Plug>CamelCaseMotion_ge', { silent = true })
    end,
  },

  -- Comment
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

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
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

  -- Alignment
  {
    'h1mesuke/vim-alignta',
    config = function()
      vim.keymap.set('x', 'al', ':Alignta<Space>', { noremap = true })
    end,
  },

  -- Smart Character
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

  -- Indent Scope
  {
    "echasnovski/mini.indentscope",
    config = function()
      require("mini.indentscope").setup({
        symbol = '▏',
      })
    end
  },

  -- Accelerated JK
  {
    "rhysd/accelerated-jk",
    config = function()
      vim.cmd([[
        nmap j <Plug>(accelerated_jk_gj)
        nmap k <Plug>(accelerated_jk_gk)
      ]])
    end
  },

  -- Close Tag
  {
    "alvan/vim-closetag",
    ft = { "html", "xml", "eruby", "html.twig", "riot" },
    config = function()
      vim.cmd([[
        let g:closetag_filenames = "*.html,*.xml,*.erb,*.tag"
      ]])
    end
  },

  -- Quick Run
  {
    "thinca/vim-quickrun",
    config = function()
      vim.cmd([[
        let g:quickrun_config = {'*': {'hook/time/enable': '1'},}
      ]])
    end
  },
}
