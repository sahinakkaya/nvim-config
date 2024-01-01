vim.fn.sign_define("DiagnosticSignError",
  { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
  { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
  { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
  { text = "󰌵", texthl = "DiagnosticSignHint" })
require("neo-tree").setup({
  default_component_configs = {
    symbols = {
      -- Change type
      added     = "✚",
      deleted   = "✖",
      modified  = "",
      renamed   = "󰁕",
      -- Status type
      untracked = "",
      ignored   = "",
      unstaged  = "󰄱",
      staged    = "",
      conflict  = "",
    }
  },
  modified = {
    symbol = "~",
    highlight = "NeoTreeModified",
  },

  close_if_last_window = true,
  window = {
    mappings = {
      ["<C-x>"] = "open_split",
      ["<C-v>"] = "open_vsplit",
      ["<C-t>"] = "open_tabnew",
      ["t"] = "noop",
      ["v"] = "noop",
      ["s"] = "noop",
      ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true },
      }
      -- ["/"] = "noop",
      -- ["i"] = {
      --   function(state)
      --     local node = state.tree:get_node()
      --     print(node.path)
      --   end,
      --   desc = "print path",
      -- },
    }
  },
  source_selector = {
    winbar = false,
  },
  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "diagnostics",
  },
  filesystem = {
    hijack_netrw_behavior = "disabled",
  },
})
