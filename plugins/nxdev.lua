return {
  'Equilibris/nx.nvim',
  event = "VeryLazy",
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require("nx").setup {}
  end
}
