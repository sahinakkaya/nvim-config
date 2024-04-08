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

    capabilities.general.positionEncodings = { "utf-8" }

    capabilities.offsetEncoding = "utf-8"
  end

  ---@diagnostic disable-next-line: missing-fields
  capabilities.textDocument.semanticTokens = {
    augmentsSyntaxTokens = false,
  }

  return capabilities
end

M.on_attach = function(client, bufnr)
  -- if client.server_capabilities.inlayHintProvider then
  --   print("yes")
  -- end
    vim.lsp.inlay_hint.enable(bufnr, true)
  print('helloooo')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', ":Trouble lsp_type_definitions<CR>", bufopts)
  vim.keymap.set('n', 'gd', ":Trouble lsp_definitions<CR>", bufopts)
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', ":Trouble lsp_implementations<CR>", bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', ":Trouble lsp_references<CR>", bufopts)
  -- vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end



return M
