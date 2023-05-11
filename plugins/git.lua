return {

  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    config = function() require("octo").setup() end,
  },
  {
    "TimUntersberger/neogit",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    opts = {
      integrations = {
        diffview = true,
      },
    },
  },
  {
    "tveskag/nvim-blame-line",
    event = "VeryLazy",
    run = function()
      -- vim.api.nvim_create_autocmd({ "BufEnter" }, {
      --
      --   command = "EnableBlameLine",
      -- })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function()
    end,
  },
  { "tpope/vim-fugitive", event = "VeryLazy" },
}
