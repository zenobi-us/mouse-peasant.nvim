-- customize mason plugins
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        "lua_ls",
        "tsserver",
        "rust_analyzer",
        "pyright",
        "gopls",
        "cssls",
        "denols",
        "dockerls",
        "docker_compose_language_service",
        "eslint",
        "graphql",
        "html",
        "jsonls",
        "marksman",
        "yamlls",
      },
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        "luacheck",
        "prettier",
        "stylua",
        "rustfmt",
        "eslint",
        "gitsigns",
        "gomodifytags",
        "refactoring",
        "shellcheck",
        "jsonlint",
        "markdownlint",
        "misspell",
        "proselint",
        "tsc",
        "yamllint",
        "hadolint",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = { "python" },
    },
  },
}
