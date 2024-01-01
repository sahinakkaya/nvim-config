
local util = require("configs.lsp.util")
require("mason").setup()

local capabilities = util.mkcaps(true)
local on_attach = util.on_attach



-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("configs.editor.neodev")
require("mason-lspconfig").setup({
  -- ensure_installed = { "tsserver", "lua_ls", "pyright", "yamlls", "bashls" },
})


require("mason-lspconfig").setup_handlers({
  function(server_name)
    require('lspconfig')[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      -- root_dir = require("lspconfig.util").root_pattern(".git"),
    })
  end,
  clangd = function()
    require('lspconfig').clangd.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      -- root_dir = require("lspconfig.util").root_pattern(".git"),
      filetypes = { "c", "cpp", "h", "hpp" },
      offsetEncoding = { "utf-8" },
      client_encoding = "utf-8",
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
  tsserver = function()
    -- don't need this as we are using typescript-tools now.
    -- but we are still using tsserver bin from mason so don't delete it.
  --   require('lspconfig').tsserver.setup({
  --     capabilities = mkcaps(true),
  --     attach = on_attach,
  --     settings = {
  --       javascript = {
  --         inlayHints = {
  --           includeInlayEnumMemberValueHints = true,
  --           includeInlayFunctionLikeReturnTypeHints = true,
  --           includeInlayFunctionParameterTypeHints = true,
  --           includeInlayParameterNameHints = "all",   -- 'none' | 'literals' | 'all';
  --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --           includeInlayPropertyDeclarationTypeHints = true,
  --           includeInlayVariableTypeHints = true,
  --         },
  --       },
  --       typescript = {
  --         inlayHints = {
  --           includeInlayEnumMemberValueHints = true,
  --           includeInlayFunctionLikeReturnTypeHints = true,
  --           includeInlayFunctionParameterTypeHints = true,
  --           includeInlayParameterNameHints = "all",   -- 'none' | 'literals' | 'all';
  --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --           includeInlayPropertyDeclarationTypeHints = true,
  --           includeInlayVariableTypeHints = true,
  --         },
  --       },
  --     }
  --   })
  end
})

-- required to trigger lspattach
vim.api.nvim_exec_autocmds("FileType", {})
