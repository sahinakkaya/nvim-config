
local util = require("configs.lsp.util")
require("mason").setup()

local capabilities = util.mkcaps(true)
local on_attach = util.on_attach



-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("configs.editor.neodev")
require("mason-lspconfig").setup({
  ensure_installed = { "tsserver", "lua_ls", "pyright", "yamlls", "bashls" },
})


require("mason-lspconfig").setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      -- root_dir = require("lspconfig.util").root_pattern(".git"),
    })
  end,
  lua_ls = function()
    require("lspconfig").lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          hint = {
            enable = false,
          },
        },
      },
    })
  end,
  bashls = function()
    require("lspconfig").bashls.setup({
      capabilities = util.mkcaps(false),
      attach = on_attach,
      filetypes = { "zsh", "sh", "bash" },
      -- root_dir = require("lspconfig.util").root_pattern(".git", ".zshrc"),
    })
  end,
  tsserver = function() end, -- i don't use mason's tsserver. typescript-tools is better. however, it needs tsserver installed by mason
})

require'lspconfig'.clangd.setup{
  capabilities = capabilities,
  on_attach=on_attach,
}
require('lspconfig').ruff_lsp.setup {
  on_attach = on_attach,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}
-- required to trigger lspattach
vim.api.nvim_exec_autocmds("FileType", {})
