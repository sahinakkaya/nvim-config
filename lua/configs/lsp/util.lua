local M = {}

M.mkcaps = function(extra)
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  if extra then
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }


    -- send actions with hover request
    capabilities.experimental = {
      hoverActions = true,
      hoverRange = true,
      serverStatusNotification = true,
      snippetTextEdit = true,
      codeActionGroup = true,
      ssr = true,
    }

    capabilities.textDocument.formatting = {
      dynamicRegistration = false,
    }

    -- capabilities.general.positionEncodings = { "utf-8" }

    capabilities.offsetEncoding = "utf-8"
  end

  ---@diagnostic disable-next-line: missing-fields
  capabilities.textDocument.semanticTokens = {
    augmentsSyntaxTokens = false,
  }

  return capabilities
end
M.on_attach = function(client, bufnr)
  if client.name == 'ruff_lsp' then
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end
  -- if client.server_capabilities.inlayHintProvider then
  --   print("yes")
  -- end
  vim.lsp.inlay_hint.enable(bufnr, true)

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gD', function() require("trouble").toggle("lsp_type_definitions") end, bufopts)
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gd', function() require("trouble").toggle("lsp_definitions") end, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, buf_opts)
  vim.keymap.set('n', 'gi', function() require("trouble").toggle("lsp_implementations") end, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', 'gr', function() require("trouble").toggle("lsp_references") end, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<C-m>', vim.lsp.buf.signature_help, bufopts)
  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end



return M
