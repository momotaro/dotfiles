return {
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    config = function()
      require("copilot").setup({
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
          },
        },
        filetypes = {
          markdown = true,
          gitcommit = true,
          ['*'] = function()
            local fname = vim.fs.basename(vim.api.nvim_buf_get_name(0))
            local disable_patterns = { 'env', 'conf', 'local', 'private' }
            return vim.iter(disable_patterns):all(function(pattern)
              return not string.match(fname, pattern)
            end)
          end,
        },
        opts = {
          should_attach = function(bufnr, bufname)
            local filetype = vim.bo[bufnr].filetype

            if filetype == "AgenticInput" then
              return true
            end

            local default_should_attach = require("copilot.config.should_attach").default
            return default_should_attach(bufnr, bufname)
          end,
        },
      })
    end,
  },

  -- Agentic
  {
    "carlos-algms/agentic.nvim",
    opts = {
      provider = "claude-acp",
      session_restore = {
        storage_path = vim.fn.expand("~/workspace/.agentic/sessions"),
      },
      windows = {
        width = "60%",
        input = { height = 6, },
        code = { max_height = 15, win_opts = {} },
        files = { max_height = 5, win_opts = {} },
      },
      diff_preview = {
        enabled = true,
        layout = "inline",
        center_on_navigate_hunks = true,
      },
      keymaps = {
        submit = {
          "<C-Enter>",
          {
            "<C-s>",
            mode = { "i", "n", "v" },
          },
        },
        paste_image = {
          {
            "<localleader>p",
            mode = { "n" },
          },
          {
            "<C-v>",
            mode = { "i" },
          },
        },
        diff_preview = {
          next_hunk = "<C-n>",
          prev_hunk = "<C-p>",
        },
      },
    },
    keys = {
      {
        ",,at",
        function() require("agentic").toggle() end,
        mode = { "n", "v", "i" },
        desc = "Toggle Agentic Chat"
      },
      {
        ",,a@",
        function() require("agentic").add_selection_or_file_to_context() end,
        mode = { "n", "v" },
        desc = "Add file or selection to Agentic to Context"
      },
      {
        "<C-a><C-f>",
        function() require("agentic").add_file() end,
        mode = { "n", "v" },
        desc = "Add current file to context"
      },
      {
        "<C-a><C-s>",
        function() require("agentic").add_session() end,
        mode = { "n", "v" },
        desc = "Add visual session to context"
      },
      {
        ",,anew",
        function() require("agentic").new_session() end,
        mode = { "n", "v", "i" },
        desc = "New Agentic Session"
      },
      {
        ",,are",
        function()
            require("agentic").restore_session()
        end,
        desc = "Agentic Restore session",
        silent = true,
        mode = { "n", "v", "i" },
      },
      {
        ",,as",
        function() require("agentic").stop_generation() end,
        mode = { "n", "v", "i" },
        desc = "Stop Agentic Generation",
      },
    },
    config = function()
      require("agentic").open({ auto_add_to_context = false })
    end,
  },

  -- Translator
  {
    "voldikss/vim-translator",
    cmd = { "TranslateW", "TranslateW --target_lang=en" },
    keys = {
      { ",,t", "", desc = "Translate" },
      { ",,tj", "<cmd>TranslateW<CR>", mode = "n", desc = "Translate words into Japanese" },
      { ",,tj", ":'<,'>TranslateW<CR>", mode = "v", desc = "Translate lines into Japanese" },
      { ",,te", "<cmd>TranslateW --target_lang=en<CR>", mode = "n", desc = "Translate words into English" },
      { ",,te", ":'<,'>TranslateW --target_lang=en<CR>", mode = "v", desc = "Translate lines into English" },
      { ",,tr", "", desc = "Translate Replace" },
      { ",,trj", ":'<,'>TranslateR<CR>", mode = "v", desc = "Replace to Japanese" },
      {
        ",,trj",
        function()
          vim.api.nvim_feedkeys("^vg_", "n", false)
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(":TranslateR\n", "n", false)
          end, 100)
        end,
        mode = "n",
        desc = "Replace to Japanese",
      },
      { ",,tre", ":'<,'>TranslateR --target_lang=en<CR>", mode = "v", desc = "Replace to English" },
      {
        ",,tre",
        function()
          vim.api.nvim_feedkeys("^vg_", "n", false)
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(":TranslateR --target_lang=en\n", "n", false)
          end, 100)
        end,
        mode = "n",
        desc = "Replace to English",
      },
    },
    config = function()
      vim.g.translator_target_lang = "ja"
      vim.g.translator_default_engines = { "google" }
      vim.g.translator_history_enable = true
      vim.g.translator_window_type = "popup"
      vim.g.translator_window_max_width = 0.5
      vim.g.translator_window_max_height = 0.9
    end,
  },
}
