return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- strip whitespace on save
      null_ls.builtins.formatting.trim_whitespace.with {
        filetypes = { "text", "sh", "zsh", "toml", "make", "conf", "tmux" },
      },

      -- Set a formatter for each file type
      --
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.rustfmt,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.goimports,
      null_ls.builtins.formatting.gofmt,

      -- null_ls.builtins.formatting.prettierd,
      null_ls.builtins.formatting.eslint_d,
      null_ls.builtins.diagnostics.eslint_d,
      null_ls.builtins.code_actions.eslint_d,

      null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.diagnostics.flake8,
      null_ls.builtins.diagnostics.misspell,
      null_ls.builtins.diagnostics.markdownlint,
      null_ls.builtins.diagnostics.luacheck.with {
        extra_args = { "--globals", "vim", "--std", "luajit" },
      },
    }
    return config -- return final config table
  end,
}
