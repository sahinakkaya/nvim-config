local icons = require("sahinakkaya.icons")
vim.diagnostic.config(
  {
    jump = { float = true },
    signs = {

      text = {
        -- [vim.diagnostic.severity.ERROR] = "✘",
        -- [vim.diagnostic.severity.WARN] = "▲",
        -- [vim.diagnostic.severity.INFO] = "",
        -- [vim.diagnostic.severity.HINT] = "⚑",
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      }
    }
  }
)
