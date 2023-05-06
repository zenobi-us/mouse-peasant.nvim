-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
--
--
function close_buffers()
  local bufs = vim.fn.getbufinfo { buflisted = true }
  require("astronvim.utils.buffer").close(0)
  if require("astronvim.utils").is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
end

return {
  --
  --[[

  Insert Mode

  ]]
  i = {
    -- Saving
    ["<C-s>"] = { "<esc>:w<cr>a", desc = "Save file", noremap = true },
    -- close_buffers
    ["<C-w>"] = { function() close_buffers() end, desc = "Close buffer", noremap = true },

    --[[

    Editing

    ]]
    -- insert tab
    ["<Tab>"] = { "<C-t>", desc = "Insert tab", noremap = true },
    -- unindent
    ["<S-Tab>"] = { "<C-d>", desc = "Unindent", noremap = true },

    -- Undo / Redo
    ["<c-z>"] = { "<cmd>undo<cr>", desc = "Undo" },
    ["<C-S-z>"] = { "<cmd>redo<cr>", desc = "Redo" },

    -- Move line up and down
    ["<C-S-Down>"] = { "<cmd>:m+<CR>", noremap = true, desc = "Move line down" },
    ["<C-S-Up>"] = { "<cmd>:m-2<CR>", noremap = true, desc = "Move line up" },

    -- select all
    ["<C-a>"] = { "<esc>ggVG", noremap = true, desc = "Select all" },
    -- copy
    ["<C-c>"] = { "<esc>yy", noremap = true, desc = "Copy line" },
    -- cut
    ["<C-x>"] = { "<esc>dd", noremap = true, desc = "Cut line" },
    --paste
    ["<C-v>"] = { "<esc>p", noremap = true, desc = "Paste line below" },
  },

  --
  --[[

  Select Mode

  When ever a selection is made, the following keymaps will be available.

  Things you don't need to handle here:

  - tab indent/unindent: handled by options.opt.selectmode

  ]]
  s = {
    -- up/down exits select mode
    ["<C-w>"] = { function() close_buffers() end, desc = "Close buffer", noremap = true },

    -- Move line up and down while keeping selection
    -- ["<C-S-Up>"] = { "<C-O>:m '<-2<CR>gv", noremap = true, desc = "Move line up" },
    -- Move line up and down while keeping selection
    -- ["<C-S-Down>"] = { "<C-O>:m '>+1<CR>gv=gv", noremap = true, desc = "Move line down" },

    ["<C-S-Up>"] = {
      "<C-O>:MoveBlock(1)<CR>",
    },
    ["<C-S-Down>"] = {
      "<C-O>:MoveBlock(-1)<CR>",
    },

    ["<C-c>"] = {
      "<C-o>yy",
      noremap = true,
      desc = "Copy lines",
    },
    ["<C-x>"] = {
      "<C-o>dd",
      noremap = true,
      desc = "Cut selection",
    },
    ["<C-v>"] = {
      "<C-o>p",
      noremap = true,
      desc = "Paste over selection",
    },
    ["<c-z>"] = { "<C-O>u", desc = "Undo" },
    ["<C-S-z>"] = { "<C-r>", desc = "Redo" },
  },
  --
  --[[

  Normal Mode

  ]]
  n = {
    -- reset
    ["<S-Up>"] = false,
    ["<S-Down>"] = false,
    -- mappings seen under group name "Buffer"
    ["<C-n>"] = { "<cmd>tabnew<cr>", desc = "New tab" },

    ["<leader>e"] = false,
    -- remap open folder to ctrl + b
    ["<C-b>"] = { ":Neotree toggle<cr>", desc = "Open folder" },

    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- close_buffers
    ["<C-w>"] = { function() close_buffers() end, desc = "Close buffer", noremap = true },

    ["<leader>v"] = { name = "Windows" },
    -- new vertical split
    ["<leader>vv"] = { "<cmd>vsplit<cr>", desc = "New vertical split" },
    -- new horizontal split
    ["<leader>vh"] = { "<cmd>split<cr>", desc = "New horizontal split" },
    -- close current split
    ["<leader>vc"] = { "<cmd>close<cr>", desc = "Close current split" },
    ["<leader>s"] = false,
    --
    --[[

    Editing

    ]]
    --select all
    ["<C-a>"] = { "ggVG", noremap = true, desc = "Select all" },
    ["<C-v>"] = { "p", desc = "Paste line below", noremap = true },
    ["<C-x>"] = { "dd", desc = "Cut line", noremap = true },
    ["<c-d>"] = { "<cmd> copy . <CR>", desc = "Clone Line" },
    ["<c-K>"] = { "dd", desc = "Delete line" },
    ["<c-X>"] = { '<C-u>call setreg("+", getline(".")) | normal dd<CR>', desc = "Cut line" },
    ["<c-z>"] = { "u", desc = "Undo" },
    ["<C-S-z>"] = { "<C-r>", desc = "Redo" },
    ["<C-S-Up>"] = { ":m-2<CR>==", noremap = true, desc = "Move line up" },
    ["<C-S-Down>"] = { ":m+<CR>==", noremap = true, desc = "Move line down" },
    --
    --[[

    Command Palette

    ]]

    ["<C-p>"] = { "<cmd>:Telescope keymaps<cr>", desc = "Toggle commands" },
    ["<C-s>"] = { ":w!<cr>", desc = "Save File", noremap = true }, -- change description but the same command
    --
    --[[

    Movement

    ]]
    -- ctrl + left and right move between words
    ["<C-Left>"] = { "b", desc = "Move to beginning of word" },
    ["<C-Right>"] = { "w", desc = "Move to end of word" },
    -- When at the end of a line, pressing Right arrow key moves to the start of th next line
    -- ["<Right>"] = { "<expr> j (col('.') == col('$') ? 'j0' : 'j')", desc = "Move to start of next line" },
    -- ["<Left>"] = { "<expr> h (col('.') == 1 ? 'k$' : 'h')", desc = "Move to end of previous line" },
    --[[

    LSP

    ]]
    -- Go back to previous buffer after having used LSP goto definition
    ["<leader>lb"] = { "<c-o>", desc = "Go back" },
    --
    --[[

    Find / Replace

    ]]
    ["<leader>fsw"] = { "<cmd>lua require('spectre').open()<cr>", desc = "Search word" },
    ["<leader>fsp"] = { "<cmd>lua require('spectre').open_visual()<cr>", desc = "Search visual" },
    ["<leader>fsr"] = { "<cmd>lua require('spectre').open_file_search()<cr>", desc = "Search file" },
    ["<leader>fsc"] = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", desc = "Search visual" },
    ["<leader>fss"] = { "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>", desc = "Search file" },

    ["<leader>r"] = { group = "Run" },
    ["<leader>rm"] = { group = "Run Markdown" },
    -- load markdown preview on leader rmp
    ["<leader>rmp"] = { "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" },

    --
    --
    --[[

    Astro

    ]]
    -- astro group
    ["<leader>a"] = { name = "Astro" },
    -- resource config without quitting
    ["<leader>ac"] = { "<cmd>luafile $MYVIMRC<CR>", desc = "Resource config" },

    --[[
    --  Git
    --]]
    -- launch lazygit in a floating toggleterminal with the current file as the filter
    ["<leader>gf"] = {
      function() require("astronvim.utils").toggle_term_cmd("lazygit --filter=" .. vim.fn.expand "%:p") end,
      desc = "Git: show file history",
    },
  },
}
