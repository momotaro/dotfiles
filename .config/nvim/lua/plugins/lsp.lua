return {
  -- Completion
  {
    'hrsh7th/nvim-cmp',
    config = function()
      vim.opt.pumheight = 10

      local cmp = require('cmp')
      cmp.setup({
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-e>'] = cmp.mapping.abort(),
          ['<ESC>'] = cmp.mapping.abort(),
          ['<C-f>'] = cmp.mapping.confirm({ select = true }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        enabled = function()
          return not vim.tbl_contains({"AgenticInput"}, vim.bo.filetype)
        end,
      })
    end
  },

  -- LSP
  {
    'hrsh7th/cmp-nvim-lsp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
          end,
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "Attach key mappings for LSP functionalities",
        callback = function ()
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation'})
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts, { desc = 'Show references' })
          vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, bufopts, { desc = 'Show references' })
          vim.keymap.set('n', 'ge', vim.diagnostic.open_float, bufopts, { desc = 'Show diagnostic' })
          vim.keymap.set('n', ',re', vim.lsp.buf.rename, bufopts, { desc = 'Rename' })
        end
      })

      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = {only = {"source.organizeImports"}}
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          vim.lsp.buf.format({async = false})
        end,
      })

      local ensure_installed = {
        'jsonls',
        'yamlls',
        'rust_analyzer',
        'ts_ls',
        'luau_lsp'
      }

      require 'mason'.setup()
      require 'mason-lspconfig'.setup {
        automatic_installation = true,
        ensure_installed = ensure_installed,
      }
      vim.lsp.enable(ensure_installed)

      vim.lsp.enable({'golangci-lint-langserver'})
      vim.lsp.enable({'gopls'})
    end
  },

  -- Completion Sources
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    tag = 'v0.9.3',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'go', 'lua', 'typescript', 'javascript', 'json', 'yaml', 'html', 'css', 'bash', 'python', 'markdown', 'scala' },
        highlight = {
          enable = true,
        },
      })
    end
  },

  -- Fuzzy Finder
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
}
