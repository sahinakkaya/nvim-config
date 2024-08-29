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
  },
  event_handlers = {

    {
      event = "file_opened",
      handler = function(file_path)
        -- auto close
        -- vimc.cmd("Neotree close")
        -- OR
        require("neo-tree.command").execute({ action = "close" })
      end
    },

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
      ["<Left>"] = "noop",
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
    winbar = true,
    statusline = false,
    -- tabs_layout = "active",                                    -- string
    sources = {
      {
        source = "filesystem", -- string
        display_name = " 󰉓 Files " -- string | nil
      },
      {
        source = "buffers", -- string
        display_name = " 󰈚 Buffers " -- string | nil
      },
      {
        source = "git_status", -- string
        display_name = " 󰊢 Git " -- string | nil
      },
      {
        source = "diagnostics", -- string
        display_name = "  Diagnostics " -- string | nil
      },
      {
        source = "document_symbols", -- string
        -- display_name = "  " -- string | nil
      },
    }
  },
  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "diagnostics",
    "document_symbols"
  },
  filesystem = {
    components = {
      harpoon_index = function(config, node, _)
        local harpoon_list = require("harpoon"):list()
        local path = node:get_id()
        local harpoon_key = vim.uv.cwd()

        for i, item in ipairs(harpoon_list.items) do
          local value = item.value
          if string.sub(item.value, 1, 1) ~= "/" then
            value = harpoon_key .. "/" .. item.value
          end

          if value == path then
            vim.print(path)
            local keys = "asdfxxxxxx"

            return {
              text = string.format("-> %s", keys:sub(i, i)), -- <-- Add your favorite harpoon like arrow here
              highlight = config.highlight or "NeoTreeDirectoryIcon",
            }
          end
        end
        return {}
      end,
    },
    renderers = {
      file = {
        { "icon" },
        { "name",         use_git_status_colors = true },
        { "harpoon_index" }, --> This is what actually adds the component in where you want it
        { "diagnostics" },
        { "git_status",   highlight = "NeoTreeDimText" },
      },
    },

    hijack_netrw_behavior = "disabled",
    follow_current_file = {
      enabled = true,          -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
  },
})
