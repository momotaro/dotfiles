return {
  -- Fugitive
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

  -- Git Gutter
  {
    'airblade/vim-gitgutter',
    config = function()
      vim.opt.signcolumn = 'yes'
      vim.keymap.set('n', ',gg', '<Cmd>GitGutterToggle<CR>', { silent = true, noremap = true })
      vim.keymap.set('n', ',gh', '<Cmd>GitGutterLineHighlightsToggle<CR>', { silent = true, noremap = true })
    end,
  },

  -- Git Blame
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%m-%d-%Y %H:%M:%S",
      virtual_text_column = 1,
    },
  },
}
