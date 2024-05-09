-- event_handlers = {
--   {
--     event = "neo_tree_window_before_open",
--     handler = function(args)
--   -- `winid`    = the |winid| of the window being opened or closed.
--   -- `tabid`    = id of the tab that the window is in.
--   -- `tabnr`    = (deprecated) number of the tab that the window is in.
--   -- `source`   = the name of the source that is in the window, such as "filesystem".
--   -- `position` = the position of the window, i.e. "left", "bottom", "right".
--       if args.source == "git_status" and args.position == "right" then
--         require('neo-tree.command').execute({
--           action = "focus", -- OPTIONAL, this is the default value
--           source = "git_status",
--           position = "bottom",
--         })
--       end
--     end
--   }
-- },

vim.fn.sign_define("DiagnosticSignError",
  { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
  { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
  { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
  { text = "󰌵", texthl = "DiagnosticSignHint" })

local focus = function(source)
  -- local position
  local command = require("neo-tree.command")
  -- if source =="diagnostics" then -- buggy. take a look at this
  --   command.execute({
  --     action = "close",
  --     position = "right",
  --   })
  --   position = "bottom"
  -- else
  --   command.execute({
  --     action = "close",
  --     position = "bottom",
  --   })
  --   position = "right"
  -- end
  command.execute({
    action = "focus",
    source = source,
    position = command._last.position,
  })
end
require("neo-tree").setup({
  commands = {
    focus_filesystem = function()
      focus("filesystem")
    end,
    focus_buffers = function()
      focus("buffers")
    end,
    focus_git_status = function()
      focus("git_status")
    end,
    focus_diagnostics = function()
      focus("diagnostics")
    end,
  },
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
  open_files_do_not_replace_types = { "terminal", "trouble", "qf", "help", "man", "fugitive" }, -- when opening files, do not use windows containing these filetypes or buftypes
  window = {
    mappings = {
      ["<C-x>"] = "open_split",
      ["<C-v>"] = "open_vsplit",
      ["<C-t>"] = "open_tabnew",
      ["gf"] = "focus_filesystem",
      ["gb"] = "focus_buffers",
      ["gG"] = "focus_git_status",
      -- ["gd"] = "focus_diagnostics",
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
    winbar = true,
    statusline = false,
    tabs_layout = "active",
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
      -- {
      --   source = "diagnostics", -- string
      --   display_name = " Diagnostics " -- string | nil
      -- },
    }
  },
  sources = {
    "filesystem",
    "buffers",
    "git_status",
    "diagnostics",
  },
  filesystem = {
    window = {
      mappings = {
        ["gh"] = "focus_git_status",
        ["<Left>"] = "focus_git_status",
        ["gl"] = "focus_buffers",
        ["<Right>"] = "focus_buffers",
      }
    },
    group_empty_dirs = true, -- when true, empty folders will be grouped together
    hijack_netrw_behavior = "open_current",
    filtered_items = {
      hide_by_name = {
        "node_modules", "__pycache__"
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        ".DS_Store",
      },
    },
    follow_current_file = {
      enabled = true,         -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    -- This will use the OS level file watchers to detect changes instead of relying on nvim autocmd events.
    use_libuv_file_watcher = true,
  },
  buffers = {
    window = {
      mappings = {
        ["gh"] = "focus_filesystem",
        ["<Left>"] = "focus_filesystem",
        ["gl"] = "focus_git_status",
        ["<Right>"] = "focus_git_status",
      }
    },
  },
  git_status = {
    window = {
      mappings = {
        ["gh"] = "focus_buffers",
        ["<Left>"] = "focus_buffers",
        ["gl"] = "focus_filesystem",
        ["<Right>"] = "focus_filesystem",
      }
    },
  },
  diagnostics = {
    window = {
      mappings = {
        ["gh"] = "focus_git_status",
        ["<Left>"] = "focus_git_status",
        ["gl"] = "focus_filesystem",
        ["<Right>"] = "focus_filesystem",
      }
    },
  },
})

vim.keymap.set('n', '-', function()
    local reveal_file = vim.fn.expand('%:p')
    if (reveal_file == '') then
      reveal_file = vim.fn.getcwd()
    else
      local f = io.open(reveal_file, "r")
      if (f) then
        f.close(f)
      else
        reveal_file = vim.fn.getcwd()
      end
    end
    require('neo-tree.command').execute({
      action = "focus",          -- OPTIONAL, this is the default value
      source = "filesystem",     -- OPTIONAL, this is the default value
      position = "right",         -- OPTIONAL, this is the default value
      reveal_file = reveal_file, -- path to file or folder to reveal
      reveal_force_cwd = true,   -- change cwd without asking if needed
    })
  end,
  { desc = "Open neo-tree at current file or working directory" }
);
