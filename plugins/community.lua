return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.completion.copilot-lua-cmp" },

  -- editing
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },

  -- completions
  -- {
  --   -- import the copilot plugin
  --   -- further customize the options set by the community
  --   "copilot.lua",
  --   opts = {
  --     filetypes = {
  --       markdown = true,
  --       lua = true,
  --     },
  --     suggestion = {
  --       keymap = {
  --         accept = "<tab>",
  --         next = "<C-right>",
  --         prev = "<C-left>",
  --         dismiss = "<C/>",
  --       },
  --     },
  --   },
  -- },
}
