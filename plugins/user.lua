return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function() require("lsp_lines").setup() end,
  },

  {
    -- neotree.nvim
    -- https://github.com/nvim-neo-tree/neo-tree.nvim
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        "s1n7ax/nvim-window-picker",
        config = function()
          require("window-picker").setup {
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
            other_win_hl_color = "#e35e4f",
          }
        end,
      },
    },
    opts = {
      -- sources = {
      --   "filesystem",
      --   "buffers",
      --   "git_status",
      --   "document_symbols"
      -- },
      source_selector = {
        winbar = false,
        statusline = false,
      },
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function() vim.cmd "stopinsert" end,
        },
      },
    },
  },

  {
    -- toggleterm.nvim
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = "<c-\\>",
      hide_numbers = true,
      -- these two options will force the terminal to always be in insert mode
      start_in_insert = true,
      persist_mode = false,
    },
  },

  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
        module = "plenary",
      },
      {
        "nvim-lua/popup.nvim",
        module = "popup",
      },
    },
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = "markdown",
  },
}
