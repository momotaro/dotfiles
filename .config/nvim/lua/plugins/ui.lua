return {
  -- Colorscheme
  {
    'kristijanhusak/vim-hybrid-material',
    config = function()
      vim.cmd('set background=dark')
      vim.cmd('colorscheme hybrid_material')
      vim.g.enable_bold_font = 1
    end,
  },

  -- Terminal
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

  -- LazyGit
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

      vim.api.nvim_set_keymap("n", ",,g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
    end,
  },

  -- Buffer Explorer
  {
    'jlanzarotta/bufexplorer',
    config = function()
      vim.keymap.set('n', ',be', '<Cmd>BufExplorer<CR>', { noremap = true })
      vim.keymap.set('n', ',bv', '<Cmd>BufExplorerVerticalSplit<CR>', { noremap = true })
      vim.keymap.set('n', ',bs', '<Cmd>BufExplorerSplit<CR>', { noremap = true })
    end,
  },

  -- Command Palette UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("notify").setup({
        top_down = false, -- 上から下(false)にすることで左下に積み上がる
      })
      require("noice").setup({
        presets = {
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
        redirect = {
          view = "popup",
          filter = {
            event = "msg_show",
            opts = { skip = true },
          },
        },
        routes = {
          {
            filter = {
              event = "notify",
              -- 特定の通知だけここに送ることも可能
            },
            view = "notify", -- notifyビューをminiビューに置き換える
            opts = { skip = false },
          },
        },
        notify = {
          view = "mini",
        },
        messages = {
          -- NOTE: If you enable messages, then the cmdline is enabled automatically.
          -- This is a current Neovim limitation.
          enabled = true, -- enables the Noice messages UI
          view = "notify", -- default view for messages
          view_error = "notify", -- view for errors
          view_warn = "notify", -- view for warnings
          view_history = "messages", -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          view = 'none',
        },
        views = {
          notify = {
            -- 通知の配置場所を設定
            position = {
              row = -1, -- 下端
            },
            -- 必要に応じてサイズ調整
            size = {
              width = "auto",
              height = "auto",
            },
          },
          cmdline_popup = {
            position = {
              row = 4,
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
              row = 8,
              col = "50%",
            },
            size = {
              width = 60,
              height = 6,
            },
            border = {
              style = "single",
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

  -- QuickFix
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      require('bqf').setup {
        auto_enable = true,
        func_map = {
          vsplit = '',
        },
      }
    end,
  },
  {
    'stevearc/quicker.nvim',
    ft = 'qf',
    config = function()
      require('quicker').setup ({})
    end,
  },

  -- File Explorer
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        view = {
          width = 30,
          side = 'left',
        },
        filters = {
          dotfiles = true,
          custom = { '.git', 'node_modules', '.cache' },
        },
        git = {
          enable = true,
          ignore = false,
        },
        renderer = {
          highlight_git = true,
          root_folder_modifier = ':t',
        }
      })

      local api = require "nvim-tree.api"
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      local function toggle_tree()
        api.tree.toggle({find_file = true})
      end

      vim.keymap.set('n', ',ex', toggle_tree, { noremap = true, silent = true })
      vim.keymap.set('n', ',ef', '<Cmd>NvimTreeFindFile<CR>', { noremap = true, silent = true })

      local function tab_new()
        api.node.open.tab()
        api.tree.open({find_file = true})
      end

      vim.keymap.set('n', 't', tab_new,  opts('Open: New Tab'))

      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function()
          local b =  vim.api.nvim_get_current_buf()

          local file_name = vim.api.nvim_buf_get_name(b)
          if string.find(file_name, 'git') ~= nil then
            return
          end

          local filetype = vim.api.nvim_buf_get_option(b, 'filetype')
          if filetype == 'gitcommit'then
            return
          end

          api.tree.open({find_file = true})
          vim.cmd('')
        end
      })
    end,
  },

  -- Status Line
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
          component_separators = { left = '', right = ''},
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
          },
        },
      }
    end,
  },
}
