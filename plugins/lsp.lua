return {
  -- {
  --   "ray-x/navigator.lua",
  --   event = "VeryLazy",
  --   dependencies = {
  --     { "ray-x/guihua.lua",                run = "cd lua/fzy && make" },
  --     "neovim/nvim-lspconfig",
  --     { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  --   },
  --   config = function()
  --     require("navigator").setup {
  --       mason = true,
  --     }
  --   end,
  -- },
  {
    "VidocqH/lsp-lens.nvim",
    event = "BufRead",
    opts = {
      sections = {
        definitions = false,
        references = true,
        implementation = false,
      },
    },
  },
}
