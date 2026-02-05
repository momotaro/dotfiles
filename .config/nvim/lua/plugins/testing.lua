return {
  -- Neotest
  {
    'nvim-neotest/neotest',
    tag = 'v5.6.1',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-go',
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
            diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      require("neotest").setup({
        diagnostic = {
          enable = true
        },
        adapters = {
          require("neotest-go"),
        },
      })

      vim.keymap.set('n', ',ts', ':Neotest summary<CR>', { silent = true, noremap = true, desc = 'Show test summary' })
      vim.keymap.set('n', ',tt', ':lua require("neotest").run.run()<CR>', { desc = 'Run test' })
      vim.keymap.set('n', ',tc', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { desc = 'Run tests in current file' })
      vim.keymap.set('n', '<S-t><S-o>', ':Neotest output<CR>', { silent = true, noremap = true, desc = 'Show test output' })
    end,
  },

  -- Coverage
  {
    'andythigpen/nvim-coverage',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('coverage').setup({
        lang = {
          go = {
            coverage_file = vim.fn.getcwd() .. '/coverage.out',
          }
        }
      })
    end,
  }
}
