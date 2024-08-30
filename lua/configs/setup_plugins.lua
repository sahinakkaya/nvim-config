local M = {}

M._lsp_utils = {

  mkcaps = function(extra)
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

      -- capabilities.offsetEncoding = "utf-8"
    end

    ---@diagnostic disable-next-line: missing-fields
    capabilities.textDocument.semanticTokens = {
      augmentsSyntaxTokens = false,
    }

    return capabilities
  end,

  on_attach = function(client, bufnr)
    if client.name == 'ruff_lsp' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
    -- if client.server_capabilities.inlayHintProvider then
    --   print("yes")
    -- end
    vim.lsp.inlay_hint.enable(true, { 0 })

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gD', function() require("trouble").toggle("lsp_type_definitions") end, bufopts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gd', function() require("trouble").toggle("lsp_definitions") end, bufopts)
    vim.keymap.set('n', 'K', function() require("pretty_hover").hover() end, bufopts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, buf_opts)
    vim.keymap.set('n', 'gi', function() require("trouble").toggle("lsp_implementations") end, bufopts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gr', function() require("trouble").toggle("lsp_references") end, bufopts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<C-m>', vim.lsp.buf.signature_help, bufopts) -- because it confuses with enter
    -- vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
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
}

M.telescope = function()
  local sched_if_valid = function(buf, fn)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        fn()
      end
    end)
  end

  local mouse_scroll_up = function(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local actions = require("telescope.actions")
    local picker = action_state.get_current_picker(prompt_bufnr)

    local mouse_win = vim.fn.getmousepos().winid
    if picker.results_win == mouse_win then
      local win_info = vim.api.nvim_win_call(mouse_win, vim.fn.winsaveview)
      if win_info.topline > 1 then
        sched_if_valid(prompt_bufnr, function()
          -- picker:set_selection(vim.fn.getmousepos().line - 1)
          actions.results_scrolling_up(prompt_bufnr)
        end)
      end
      return ""
    elseif mouse_win == picker.preview_win then
      sched_if_valid(prompt_bufnr, function()
        actions.preview_scrolling_up(prompt_bufnr)
      end)
      return ""
    else
      return "<ScrollWheelUp>"
    end
  end
  -- You dont need to set any of these options. These are the default ones. Only
  -- the loading is important

  local home = os.getenv('HOME')
  local config = home .. '/.config/'
  local data = home .. '/.local/share/'

  local telescope = require("telescope")
  local trouble = require("trouble.sources.telescope")

  local project_actions = require("telescope._extensions.project.actions")
  telescope.setup {
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      -- path_display = { "smart" },
      mappings = {
        i = {
          -- map actions.which_key to <C-h> (default: <C-/>)
          -- actions.which_key shows the mappings for your picker,
          -- e.g. git_{create, delete, ...}_branch for the git_branches picker
          ["<m-t>"] = trouble.open,
          ["<scrollwheelup>"] = {
            mouse_scroll_up,
            type = "action",
            opts = { expr = true },
          },
          ["<C-h>"] = "which_key"
        },
        n = {
          ["<m-t>"] = trouble.open,
          ["q"] = "close",
        }
      }
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      colorscheme = {
        enable_preview = true,
        theme = "cursor",
      },
      find_files = {
        theme = "ivy",
        winblend = 10
      }
      -- picker_name = {
      --   picker_config_key = value,
      --   ...
      -- }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
    },
    extensions = {
      project = {
        -- sync_with_nvim_tree = true,
        on_project_selected = function(prompt_bufnr)
          project_actions.change_working_directory(prompt_bufnr, false)
          require("harpoon"):list():select(1)
        end,
      },
      fzf = {
        fuzzy = true,                   -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true,    -- override the file sorter
        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      frecency = {
        show_filter_column = false,
        -- db_safe_mode = false,
        sorter = telescope.extensions.fzf.native_fzf_sorter(),
        workspaces = {
          ["conf"]     = config,
          ["data"]     = data,
          ["projects"] = home .. '/Projects',
          ["wiki"]     = home .. '/vimwiki',
          ["scripts"]  = home .. '/scripts',
          ["etc"]      = "/etc"
        },
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          -- even more opts
        }

        -- pseudo code / specification for writing custom displays, like the one
        -- for "codeactions"
        -- specific_opts = {
        --   [kind] = {
        --     make_indexed = function(items) -> indexed_items, width,
        --     make_displayer = function(widths) -> displayer
        --     make_display = function(displayer) -> function(e)
        --     make_ordinal = function(e) -> string
        --   },
        --   -- for example to disable the custom builtin "codeactions" display
        --      do the following
        --   codeactions = false,
        -- }
      }
    }

  }
  -- To get fzf loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  telescope.load_extension('fzf')
  telescope.load_extension("ui-select")
  telescope.load_extension("frecency")
  telescope.load_extension("project")
  telescope.load_extension("file_browser")
  -- telescope.load_extension("notify")
end
M.neotree = function()
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

    auto_clean_after_session_restore = true,
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
        enabled = false,        -- This will find and focus the file in the active buffer every time
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
        position = "right",        -- OPTIONAL, this is the default value
        reveal_file = reveal_file, -- path to file or folder to reveal
        reveal_force_cwd = true,   -- change cwd without asking if needed
      })
    end,
    { desc = "Open neo-tree at current file or working directory" }
  );
end
M.scrollbar = function()
  -- local colors = require("tokyonight.colors").setup()
  -- require("scrollbar").setup({
  --     handle = {
  --         color = colors.fg_sidebar,
  --     },
  --     marks = {
  --         Search = { color = colors.orange },
  --         Error = { color = colors.error },
  --         Warn = { color = colors.warning },
  --         Info = { color = colors.info },
  --         Hint = { color = colors.hint },
  --         Misc = { color = colors.purple },
  --     }
  -- })
  local colors = require("kanagawa.colors").setup()

  require("scrollbar").setup({
    handle = {
      color = colors.theme.ui.bg_visual
    },
    marks = {
      Search = { color = colors.palette.lotusOrange },
      Error = { color = colors.theme.diag.error },
      Warn = { color = colors.theme.diag.warning },
      Info = { color = colors.theme.diag.info },
      Hint = { color = colors.theme.diag.hint },
      Misc = { color = colors.palette.waveAqua1 },
    }
  })

  require("scrollbar.handlers.search").setup({
    -- hlslens config overrides
  })
  require('gitsigns').setup({
    signcolumn = true,         -- Toggle with `:Gitsigns toggle_signs`
    numhl = true,              -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false,            -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false,         -- Toggle with `:Gitsigns toggle_word_diff`
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
      delay = 10,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    -- current_line_blame_formatter_opts = {
    --   relative_time = false,
    -- },
    status_formatter = function(status)
      local added, changed, removed = status.added, status.changed, status.removed
      local status_txt = {}
      if added and added > 0 then
        table.insert(status_txt, "" .. added)
      end
      if changed and changed > 0 then
        table.insert(status_txt, "" .. changed)
      end
      if removed and removed > 0 then
        table.insert(status_txt, "" .. removed)
      end
      return table.concat(status_txt, " ")
    end, -- Use default
  })
  require("scrollbar.handlers.gitsigns").setup()

  -- example: make gitsigns.nvim movement repeatable with ; and , keys.
  local gs = require("gitsigns")

  local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
  -- make sure forward function comes first
  local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
  -- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.

  vim.keymap.set({ "n", "x", "o" }, "]h", next_hunk_repeat, { desc = "Next git hunk" })
  vim.keymap.set({ "n", "x", "o" }, "[h", prev_hunk_repeat, { desc = "Prev git hunk" })
end


M.repeatable_moves = function()
  local N = {}
  local cp = require("copilot.panel")
  local gs = require("gitsigns")
  local dropbar_api = require('dropbar.api')
  local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
  -- make sure forward function comes first
  local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
  local next_suggestion, prev_suggestion = ts_repeat_move.make_repeatable_move_pair(cp.jump_next, cp.jump_prev)
  local next_context, prev_context = ts_repeat_move.make_repeatable_move_pair(dropbar_api.select_next_context,
    dropbar_api.goto_context_start)
  -- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.
  N.next_hunk = function()
    next_hunk_repeat()
  end
  N.prev_hunk = function()
    prev_hunk_repeat()
  end
  N.next_context = next_context
  N.prev_context = prev_context
  N.next_suggestion = next_suggestion
  N.prev_suggestion = prev_suggestion
  return N
end
M.which_key = function()
  local whichkey = require("which-key")

  local harpoon = function()
    return require("harpoon")
  end


  local hydra = require("hydra")
  local hydras = require("configs.initialize_hydras")
  local function activate_hydra(h)
    return function()
      hydra.activate(h)
    end
  end

  local function activate_debug_hydra()
    local session = require("dap").session()
    if session == nil then
      activate_hydra(hydras.debug)()
    else
      activate_hydra(hydras.debug2)()
    end
  end


  whichkey.setup({
    plugins = {
      marks = true,     -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- spelling = {
      --   enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      --   suggestions = 20, -- how many suggestions should be shown in the list?
      -- },
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      presets = {
        operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
        motions = true,      -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true,      -- default bindings on <c-w>
        nav = true,          -- misc bindings to work with windows
        z = true,            -- bindings for folds, spelling and others prefixed with z
        g = true,            -- bindings for prefixed with g
      },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above.
    -- doesn't work for some reason
    -- operators = {
    --   gc = "+Comments",
    -- },
    key_labels = {
      -- override the label used to display some keys. It doesn't effect WK in any other way.
      -- For example:
      ["<space>"] = "SPC",
      ["<CR>"] = "RET",
      ["<tab>"] = "TAB",
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>",   -- binding to scroll up inside the popup
    },
    window = {
      border = "rounded",       -- none, single, double, shadow
      position = "bottom",      -- bottom, top
      margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 },                                     -- min and max height of the columns
      width = { min = 20, max = 50 },                                     -- min and max width of the columns
      spacing = 3,                                                        -- spacing between columns
      align = "left",                                                     -- align columns left, center or right
    },
    ignore_missing = false,                                               -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", ":", ":", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true,                                                     -- show help message on the command line when the popup is visible
    triggers = "auto",                                                    -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for key maps that start with a native binding
      -- most people should not need to change this
      i = { "j", "k" },
      v = { "j", "k" },
      n = { "d", "y" } -- for modes.nvim to work properly
    },
  })

  local opts = {
    mode = "n",     -- NORMAL mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true,  -- use `nowait` when creating keymaps
  }




  local mappings = {
    ["<tab>"] = { "<C-^>", "which_key_ignore" },
    ["<space>"] = { ":Telescope frecency workspace=CWD<CR>", "Frecent files" },
    ["\\"] = { ":vnew<CR>", "which_key_ignore" },
    ["-"] = { ":new<CR>", "which_key_ignore" },
    a = { function() harpoon():list():add() end, "Harpoon add" },
    e = { ":Neotree toggle reveal right last<CR>", "which_key_ignore" },
    b = {
      name = "Buffers",
      b = {
        ":lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>",
        "Buffers",
      },
      c = { ":bd!<CR>", "Close Buffer" },
      d = {
        "<cmd>BufferLineSortByDirectory<cr>",
        "Sort by directory",
      },
      e = {
        "<cmd>BufferLineSortByExtension<cr>",
        "Sort by extension",
      },
      f = { "<cmd>Telescope buffers<cr>", "Find" },
      h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
      l = { "<cmd>BufferLineCloseRight<cr>", "Close all to the right" },
      n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
      o = { "<cmd>BufferLineCloseOthers<cr>", "Close all to the right" },
      j = { "<cmd>BufferLinePick<cr>", "Jump" },
      p = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
      ['.'] = { "<cmd>BufferLineMoveNext<cr>", "Move buffer" },
      [','] = { "<cmd>BufferLineMovePrev<cr>", "Move buffer" },
      ['>'] = { "<cmd>lua require'bufferline'.move_to(-1)<cr>", "Move buffer to last" },
      ['<'] = { "<cmd>lua require'bufferline'.move_to(1)<cr>", "Move buffer to last" },
      P = { "<cmd>BufferLineTogglePin<cr>", "Toggle pin" },
      q = { ":bd!<CR>", "Close Buffer" },
      x = { "<cmd>BufferLinePickClose<cr>", "Pick which buffer to close" },
    },

    ['>'] = { "<cmd>BufferLineMoveNext<cr>", "which_key_ignore" },
    ['<'] = { "<cmd>BufferLineMovePrev<cr>", "which_key_ignore" },
    ['1'] = { "<cmd>lua require'bufferline'.go_to(1)<cr>", "which_key_ignore" },
    ['2'] = { "<cmd>lua require'bufferline'.go_to(2)<cr>", "which_key_ignore" },
    ['3'] = { "<cmd>lua require'bufferline'.go_to(3)<cr>", "which_key_ignore" },
    ['4'] = { "<cmd>lua require'bufferline'.go_to(4)<cr>", "which_key_ignore" },
    ['5'] = { "<cmd>lua require'bufferline'.go_to(5)<cr>", "which_key_ignore" },
    ['6'] = { "<cmd>lua require'bufferline'.go_to(6)<cr>", "which_key_ignore" },
    ['7'] = { "<cmd>lua require'bufferline'.go_to(7)<cr>", "which_key_ignore" },
    ['8'] = { "<cmd>lua require'bufferline'.go_to(8)<cr>", "which_key_ignore" },
    ['9'] = { "<cmd>lua require'bufferline'.go_to(9)<cr>", "which_key_ignore" },
    ['0'] = { "<cmd>lua require'bufferline'.go_to(-1)<cr>", "which_key_ignore" },
    ['$'] = { "<cmd>lua require'bufferline'.go_to(-1)<cr>", "which_key_ignore" },

    c = {
      name = 'Context',
      h = { M.repeatable_moves().prev_context, "Go to context start" },
      l = { M.repeatable_moves().next_context, "Select next context" },
      p = { require('dropbar.api').pick, "Select next context" },
    },
    d = {
      name = "Debug",
      t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
      b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
      c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
      C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
      d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
      g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
      i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
      o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
      u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
      p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
      r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
      s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
      q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
      U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
    },
    u = { ":UndotreeToggle<CR>", "Toggle undotree" },
    f = {
      name = "Find",
      i = {
        name = "Inside",
        p = { ":Telescope frecency workspace=projects<CR>", "projects" },
        c = { ":Telescope frecency workspace=conf<CR>", ".config" },
        d = { ":Telescope frecency workspace=data<CR>", ".local/share" },
        w = { ":Telescope frecency workspace=wiki<CR>", "wiki" },
        s = { ":Telescope frecency workspace=scripts<CR>", "scripts" },
      },
      b = { ":Telescope file_browser<CR>", "File browser" },
      -- f = { ":Telescope frecency workspace=CWD<CR>", "cwd" },
      c = { ":Telescope frecency workspace=conf<CR>", ".config" },
      d = { ":Telescope frecency workspace=data<CR>", ".local/share" },
      s = { ":Telescope frecency workspace=scripts<CR>", "scripts" },
      w = { ":Telescope frecency workspace=wiki<CR>", "wiki" },
      p = { ":Telescope project<CR>", "<Projects>" },
    },
    q = { require("sahinakkaya.util").smart_quit, "Smart quit" },



    g = {
      name = "Git",
      -- g = { require("plugin_configs.terminal").lazygit_toggle, "Lazygit" },
      g = { ":Git<CR>", "Fugitive" },
      j = { M.repeatable_moves().next_hunk, "Next Hunk" },

      d = { function()
        require("gitsigns").diffthis('~')
      end, "Diff this" },
      e = { require("gitsigns").toggle_deleted, "Toggle Deleted" },
      k = { M.repeatable_moves().prev_hunk, "Prev Hunk" },
      l = { require("gitsigns").toggle_current_line_blame, "Blame line" },
      b = { function()
        require("gitsigns").blame_line({ full = true })
      end, "Blame line full" },
      o = { require("gitsigns").show, "Open original" },
      p = { require("gitsigns").preview_hunk, "Preview" },
      P = { require("gitsigns").preview_hunk_inline, "Inline Preview" },
      q = { require("gitsigns").setqflist, "Quickfix List" },
      r = { require("gitsigns").reset_hunk, "Reset Hunk" },
      R = { require("gitsigns").reset_buffer, "Reset Buffer" },
      s = { require("gitsigns").stage_hunk, "Stage Hunk" },
      S = { require("gitsigns").stage_buffer, "Stage Buffer" },
      w = { require("gitsigns").toggle_word_diff, "Word diff" },
      O = { ":Telescope git_status<CR>", "Open changed file" },
      B = { ":Telescope git_branches<CR>", "Checkout branch" },
      c = { ":Telescope git_commits<CR>", "Checkout commit" },
      f = {
        "<cmd>Telescope git_bcommits<cr>",
        "Checkout commit(for current file)",
      },
    },
    h = {
      name = "Hydra",
      d = { activate_debug_hydra, "Debug" },
      g = { activate_hydra(hydras.git), "Git" },
      i = { activate_hydra(hydras.draw_diagram), "Draw diagram" },
      h = { activate_hydra(hydras.history), "History" },
      o = { activate_hydra(hydras.options), "Options" },
      t = { activate_hydra(hydras.toggle), "Toggle" },
      -- t = { ":TSContextToggle<CR>", "Toggle TSContext" },
    },
    H = { M.repeatable_moves().prev_context, "Prev context" },
    L = { M.repeatable_moves().next_context, "Next context" },

    j = {
      name = "Jump",
      ["<Space>"] = { function() harpoon():list():add() end, "Harpoon add" },
      a = { function() harpoon():list():select(1) end, "Harpoon a" },
      s = { function() harpoon():list():select(2) end, "Harpoon s" },
      d = { function() harpoon():list():select(3) end, "Harpoon d" },
      f = { function() harpoon():list():select(4) end, "Harpoon f" },
      j = { "<cmd>BufferLinePick<cr>", "Jump" },
      l = { function() harpoon().ui:toggle_quick_menu(harpoon():list()) end, "Harpoon list" },
    },
    l = {
      name = "LSP",
      a = { vim.lsp.buf.code_action, "Code Action" },
      c = { vim.lsp.codelens.run, "CodeLens Action" },
      d = { vim.lsp.buf.definition, "Go to definition" },
      D = { vim.lsp.buf.declaration, "Go to declaration" },
      f = { function() vim.lsp.buf.format { async = true } end, "Format" },
      I = { function()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
        vim.lsp.inlay_hint.enable(not enabled)
      end, "Toggle inlay hints" },
      i = { vim.lsp.buf.implementation, "Go to implementation" },
      h = { function() require("pretty_hover").hover() end, "Hover info" },
      H = { vim.lsp.buf.signature_help, "Signature help" },
      n = { ":LspInfo<CR>", "Info" },
      j = { vim.diagnostic.goto_next, "Next Diagnostic" },
      k = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
      -- vim.lsp.buf.references, "Go to references"},
      l = {
        name = "Workspace",
        w = { ":Telescope diagnostics<CR>", "Workspace Diagnostics" },
        s = {
          ":Telescope lsp_dynamic_workspace_symbols<CR>",
          "Dynamic Workspace Symbols",
        },
        p = { ":Lazy profile<CR>", "Lazy profile" },
      },
      q = { vim.diagnostic.setloclist, "Quickfix" },
      r = {
        name = "Refactor",
        n = { function() return ":IncRename " .. vim.fn.expand('<cword>') end, "Rename", expr = true },
        R = { function()
          require("sahinakkaya.util").rename({})
        end, "Rename with normal mode" },
        e = { ":lua require('refactoring').refactor('Extract Block')<CR>", "Extract block" },
        f = { ":lua require('refactoring').refactor('Extract Block To File')<CR>", "Extract block to file" },
        i = { ":lua require('refactoring').refactor('Inline Variable')<CR>", "Inline variable" },
        I = { ":lua require('refactoring').refactor('Inline Function')<CR>", "Inline function" },
        c = { function() require('refactoring').debug.cleanup() end, "Cleanup" },
        r = { function()
          require('refactoring').select_refactor()
        end, "Select refactor" },
      },

      v = { function() require('refactoring').debug.print_var({ below = true }) end, "Print var" },
      p = { function() require('refactoring').debug.printf({ below = true }) end, "Debug statement" },
      s = { vim.lsp.buf.signature_help, "Signature help" },
      w = {
        name = "Workspace",
        a = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
        r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
        l = { function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspace folders" },
      }
    },

    n = {
      name = "Notifications",
      d = { function() require('notify').dismiss({ pending = false, silent = false }) end, "Dismiss notifications" },
      -- n = { ":Fidget history<CR>", "Notifications" },
      n = { ":Telescope notify<CR>", "Notifications" },
    },
    m = { ":WindowsMaximize<CR>", "Toggle maximize" },

    s = {
      name = "Sessions | Search | Split",
      b = { ":Telescope git_branches<CR>", "Checkout branch" },
      c = { ":Telescope colorscheme<CR>", "Colorscheme" },
      C = { ":Telescope commands<CR>", "Commands" },
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      h = { ":Telescope help_tags<CR>", "Find Help" },
      H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
      k = { ":Telescope keymaps<CR>", "Keymaps" },
      m = { ":Telescope man_pages<CR>", "Man Pages" },
      -- n = { ":Fidget history<CR>", "Notifications" },
      n = { ":Telescope notify<CR>", "Notifications" },
      r = { ":Telescope oldfiles<CR>", "Open Recent File" },
      -- R = { ":Telescope registers<CR>", "Registers" },
      -- s = { ":Telescope projects<CR>", "Recent Projects" },
      t = { ":Telescope live_grep theme=ivy<CR>", "Find Text" },
      v = { ":vnew<CR>", "vsplit" },
      s = { ":new<CR>", "hsplit" },
      w = { ":lua require('mini.sessions').write('Session.vim')<CR>", "Write session" },
      l = { ":lua require('mini.sessions').select()<CR>", "List session" },
      R = { ":lua require('mini.sessions').read('Session.vim')<CR>", "Read session" },
    },
    o = {
      name = "Open Trouble",
      d = { function() require("trouble").toggle("document_diagnostics") end, "Document Diagnostics" },
      f = { function() require("trouble").toggle("lsp_definitions") end, "Lsp Definitions" },
      l = { function() require("trouble").toggle("loclist") end, "Location List" },
      i = { function() require("trouble").toggle("lsp_implementations") end, "Lsp Implementations" },
      r = { function() require("trouble").toggle("lsp_references") end, "Lsp References" },
      o = { function() require("trouble").toggle() end, "Trouble Toggle" },
      w = { function() require("trouble").toggle("workspace_diagnostics") end, "Workspace Diagnostics" },
      q = { function() require("trouble").toggle("quickfix") end, "Quickfix list" },
      -- n = { ":Fidget history<CR>", "Notifications" },
    },
    t = {
      name = "Toggle",
      n = { ":Telescope notify<CR>", "Notifications" },
    },

    w = {
      name = "windows",
      e = { ":WindowsEqualize<CR>", "Equalize windows" },
      h = { "<C-W>H", "Move window to far left" },
      l = { "<C-W>L", "Move window to far right" },
      j = { "<C-W>J", "Move window to very top" },
      k = { "<C-W>K", "Move window to very bottom" },
      K = { "<C-w>t<C-w>H", "Move window to very bottom" },

      m = { ":WindowsMaximize<CR>", "Toggle maximize" },
      ['\\'] = { ":WindowsMaximizeHorizontally<CR>", "Maximize horizontally" },
      ['|'] = { ":WindowsMaximizeHorizontally<CR>", "Maximize horizontally" },
      ['_'] = { ":WindowsMaximizeVertically<CR>", "Maximize vertically" },
      ['-'] = { ":WindowsMaximizeVertically<CR>", "Maximize vertically" },
      r = { ":lua require('smart-splits').start_resize_mode()<CR>", "Resize mode" },
      s = { "<C-W>x", "Swap with closest to right" },
      w = { "<C-W>r", "Rotate windows to down/right" },
      W = { "<C-W>R", "Rotate windows to up/left" },
    },
    -- w = {
    --   name = "windows",
    --   h = { "<C-W>H", "Move window to far left" },
    --   l = { "<C-W>L", "Move window to far right" },
    --   j = { "<C-W>J", "Move window to very top" },
    --   k = { "<C-W>K", "Move window to very bottom" },
    --   s = { "<C-W>x", "Swap with closest to right" },
    --   w = { "<C-W>r", "Rotate windows to down/right" },
    --   W = { "<C-W>R", "Rotate windows to up/left" },
    -- },
  }


  local vmappings = {
    l = {
      v = { function() require('refactoring').debug.print_var({ below = true }) end, "Print var" },
      r = {
        name = "Refactor",
        e = { function() require('refactoring').refactor('Extract Function') end, "Extract function" },
        f = {
          function() require('refactoring').refactor('Extract Function To File') end,
          "Extract function to file",
        },
        v = { function() require('refactoring').refactor('Extract Variable') end, "Extract variable" },
        i = { function() require('refactoring').refactor('Inline Variable') end, "Inline variable" },
        r = { function() require('telescope').extensions.refactoring.refactors() end, "Refactor" },
      },
    },
    d = {
      name = "Debug",
      e = { ":lua require('dapui').eval()<CR>", "Evaluate expression" },
    },
    g = {
      name = "Git",
      r = { function() require("gitsigns").reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "Reset Hunk" },
      s = { function() require("gitsigns").stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, "Stage Hunk" },
    },
  }

  local vopts = {
    mode = "v",     -- NORMAL mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true,  -- use `nowait` when creating keymaps
  }

  whichkey.register(mappings, opts)
  whichkey.register(vmappings, vopts)
end

M.noice = function()
  require("noice").setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      progress = {
        enabled = false,
      },
      signature = {
        auto_open = {
          enabled = false,
        },
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    notify = { enabled = true },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = false,        -- use a classic bottom cmdline for search
      command_palette = true,       -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true,            -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
  })

  -- lsp hover doc scrolling
  vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
    if not require("noice.lsp").scroll(4) then
      return "<c-f>"
    end
  end, { silent = true, expr = true })

  vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
    if not require("noice.lsp").scroll(-4) then
      return "<c-b>"
    end
  end, { silent = true, expr = true })
  -- local border_style = {
  --   left = { " ", "NoiceCmdlinePopupBorder" },
  --   right = { " ", "NoiceCmdlinePopupBorder" },
  --   top = { "▀", "NoiceCmdlinePopupBorder" },
  --   top_left = { "▀", "NoiceCmdlinePopupBorder" },
  --   top_right = { "▀", "NoiceCmdlinePopupBorder" },
  --   bottom = { "▄", "NoiceCmdlinePopupBorder" },
  --   bottom_left = { "▄", "NoiceCmdlinePopupBorder" },
  --   bottom_right = { "▄", "NoiceCmdlinePopupBorder" },
  -- }
  --
  -- local require = require("noice.util.lazy")
  --
  -- local Util = require("noice.util")
  -- local View = require("noice.view")
  --
  -- ---@class NoiceFidgetOptions
  -- ---@field timeout integer
  -- ---@field reverse? boolean
  -- local defaults = { timeout = 5000 }
  --
  -- ---@class FidgetView: NoiceView
  -- ---@field active table<number, NoiceMessage>
  -- ---@field super NoiceView
  -- ---@field handles table<number, ProgressHandle>
  -- ---@field timers table<number, uv_timer_t>
  -- ---@diagnostic disable-next-line: undefined-field
  -- local FidgetView = View:extend("MiniView")
  --
  -- function FidgetView:init(opts)
  --   FidgetView.super.init(self, opts)
  --   self.active = {}
  --   self.timers = {}
  --   self._instance = "view"
  --   self.handles = {}
  -- end
  --
  -- function FidgetView:update_options()
  --   self._opts = vim.tbl_deep_extend("force", defaults, self._opts)
  -- end
  --
  -- ---@param message NoiceMessage
  -- function FidgetView:can_hide(message)
  --   if message.opts.keep and message.opts.keep() then
  --     return false
  --   end
  --   return not Util.is_blocking()
  -- end
  --
  -- function FidgetView:autohide(id)
  --   if not self.timers[id] then
  --     self.timers[id] = vim.loop.new_timer()
  --   end
  --   self.timers[id]:start(self._opts.timeout, 0, function()
  --     if not self.active[id] then
  --       return
  --     end
  --     if not self:can_hide(self.active[id]) then
  --       return self:autohide(id)
  --     end
  --     self.active[id] = nil
  --     self.timers[id] = nil
  --     vim.schedule(function()
  --       self:update()
  --     end)
  --   end)
  -- end
  --
  -- function FidgetView:show()
  --   for _, message in ipairs(self._messages) do
  --     -- we already have debug info,
  --     -- so make sure we dont regen it in the child view
  --     message._debug = true
  --     self.active[message.id] = message
  --     self:autohide(message.id)
  --   end
  --   self:clear()
  --   self:update()
  -- end
  --
  -- function FidgetView:dismiss()
  --   self:clear()
  --   self.active = {}
  --   self:update()
  -- end
  --
  -- function FidgetView:update()
  --   ---@type NoiceMessage[]
  --   local active = vim.tbl_values(self.active)
  --   table.sort(
  --     active,
  --     ---@param a NoiceMessage
  --     ---@param b NoiceMessage
  --     function(a, b)
  --       local ret = a.id < b.id
  --       if self._opts.reverse then
  --         return not ret
  --       end
  --       return ret
  --     end
  --   )
  --   local seen = {}
  --   for _, message in pairs(active) do
  --     seen[message.id] = true
  --     if self.handles[message.id] then
  --       self.handles[message.id]:report({
  --         message = message:content(),
  --       })
  --     else
  --       self.handles[message.id] = require("fidget").progress.handle.create({
  --         title = message.level or "info",
  --         message = message:content(),
  --         lsp_client = {
  --           name = self._view_opts.title,
  --         },
  --       })
  --     end
  --   end
  --   for id, handle in pairs(self.handles) do
  --     if not seen[id] then
  --       handle:finish()
  --       self.handles[id] = nil
  --     end
  --   end
  -- end
  --
  -- function FidgetView:hide()
  --   for _, handle in pairs(self.handles) do
  --     handle:finish()
  --   end
  -- end
  --
  -- package.loaded["noice.view.backend.fidget"] = FidgetView
  --
  -- require("noice").setup({
  --   status = {
  --     -- progress = {
  --     --   event = "lsp",
  --     --   kind = "progress",
  --     -- },
  --   },
  --   presets = {
  --     long_message_to_split = true,
  --     inc_rename = true,
  --   },
  --   smart_move = {
  --     enabled = true,
  --   },
  --   views = {
  --     split = {
  --       win_options = {
  --         winhighlight = "Normal:Normal",
  --       },
  --     },
  --     mini = {
  --       win_options = {
  --         winblend = 0,
  --       },
  --     },
  --     cmdline_popup = {
  --       position = {
  --         row = "35%",
  --         col = "50%",
  --       },
  --       border = {
  --         style = border_style,
  --         padding = { 0, 0 },
  --       },
  --       win_options = {
  --         -- winblend = 100,
  --         winhighlight = {
  --           Normal = "NormalFloat",
  --           FloatBorder = "NormalBorder",
  --         },
  --         cursorline = false,
  --       },
  --       size = {
  --         width = "auto",
  --         height = "auto",
  --       },
  --     },
  --     hover = {
  --       border = {
  --         style = border_style,
  --         padding = { 0, 0 },
  --       },
  --     },
  --     popup = {
  --       border = {
  --         style = border_style,
  --         padding = { 0, 0 },
  --       },
  --       win_options = {
  --         winhighlight = {
  --           Normal = "NormalFloat",
  --           FloatBorder = "NormalFloatInv",
  --         },
  --       },
  --     },
  --     popupmenu = {
  --       relative = "editor",
  --       position = {
  --         row = "40%",
  --         col = "50%",
  --       },
  --       size = {
  --         width = 79,
  --         height = 10,
  --       },
  --       border = {
  --         style = border_style,
  --         padding = { 0, 0 },
  --       },
  --       win_options = {
  --         winhighlight = {
  --           Normal = "NormalFloat",
  --           FloatBorder = "NormalFloatInv",
  --         },
  --       },
  --     },
  --   },
  --   lsp = {
  --     --override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --     -- override = {
  --     --   ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --     --   ["vim.lsp.util.stylize_markdown"] = true,
  --     --   ["cmp.entry.get_documentation"] = true,
  --     -- },
  --     progress = {
  --       enabled = false,
  --       view = "mini",
  --     },
  --     signature = {
  --       enabled = true,
  --       auto_open = {
  --         enabled = true,
  --         trigger = true,
  --         throttle = 50,
  --       },
  --       opts = {},
  --     },
  --     hover = {
  --       enabled = true,
  --       border = {
  --         style = border_style,
  --         padding = { 0, 0 },
  --       },
  --     },
  --   },
  --   cmdline = {
  --     view = "cmdline_popup",
  --     format = {
  --       search_down = {
  --         view = "cmdline",
  --       },
  --       search_up = {
  --         view = "cmdline",
  --       },
  --       python = {
  --         pattern = { "^:%s*pyt?h?o?n?%s+", "^:%s*py?t?h?o?n%s*=%s*" },
  --         icon = "󰌠",
  --         lang = "python",
  --         title = " python ",
  --       },
  --       session = {
  --         pattern = { "^:Session%s+" },
  --         icon = "",
  --         lang = "vim",
  --         title = " session ",
  --       },
  --       git = {
  --         pattern = { "^:Gitsigns%s+", "^:Neogit%s+", "^:GitLink%s+" },
  --         icon = "",
  --         lang = "vim",
  --         title = " git ",
  --       },
  --     },
  --   },
  --   popupmenu = {
  --     enabled = true,
  --     backend = "nui",
  --   },
  --   messages = {
  --     enabled = true, -- enables the Noice messages UI
  --     view = "notify", -- default view for messages
  --     view_error = "notify", -- view for errors
  --     view_warn = "notify", -- view for warnings
  --     view_history = "messages", -- view for :messages
  --     view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  --   },
  --   notify = {
  --     enabled = false,
  --   },
  --   routes = {
  --     {
  --       filter = {
  --         any = {
  --           { find = "%d+L, %d+B written$" },
  --           { find = "^%d+ change[s]?; before #%d+" },
  --           { find = "^%d+ change[s]?; after #%d+" },
  --           { find = "^%-%-No lines in buffer%-%-$" },
  --         },
  --       },
  --       view = "mini",
  --       opts = {
  --         stop = true,
  --         skip = true,
  --       },
  --     },
  --   },
  -- })
end
M.notify = function()
  local notify = require("notify")
  notify.setup({
    render = "minimal",

    timeout = 2000,

    stages = "slide",
    -- stages = anim(Dir.TOP_DOWN),
  })


  vim.notify = function(msg, ...)
    if msg:match("warning: multiple different client offset_encodings") then
      return
    end

    notify(msg, ...)
  end
end
M.text_case = function()
  require("textcase").setup({})
  require("telescope").load_extension("textcase")
end

M.treesitter = function()
  local selection_modes = function(table)
    local modes = {
      -- ['@class.outer'] = '<c-v>', -- blockwise
      ['@parameter.outer'] = 'v',   -- charwise
      ['@class.outer'] = 'V',       -- linewise
      ['@conditional.outer'] = 'V', -- linewise
      ['@class.inner'] = 'V',
      ['@function.outer'] = vim.o.filetype == 'lua' and 'v' or 'V',
      ['@function.inner'] = vim.o.filetype == 'lua' and 'v' or 'V',
      ['@loop.outer'] = 'V',
      ['@loop.inner'] = 'V',
    }
    return modes[table['query_string']]
  end

  require 'nvim-treesitter.configs'.setup {
    -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
    auto_install = true,
    matchup = {
      enable = true, -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
      -- [options]
    },
    highlight = {
      enable = true,
      -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
      -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
      -- the name of the parser)
      -- list of language that will be disabled
      -- disable = { "c", "rust" },
      -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true

    },

    textobjects = {
      lsp_interop = {
        enable = true,
        border = 'none',
        floating_preview_opts = {},
        peek_definition_code = {
          ["gk"] = "@function.outer",
          ["gK"] = "@class.outer",
        },
      },
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          ["A"] = "@assignment.outer",
          -- ["iv"] = "@assignment.inner",
          -- ["ha"] = "@assignment.lhs",
          -- ["la"] = "@assignment.rhs",
          ["id"] = "@conditional.inner",
          ["ad"] = "@conditional.outer",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["a]"] = "@class.outer",
          ["i]"] = "@class.inner",
          ["il"] = "@loop.inner",
          ["al"] = "@loop.outer",
          ["ia"] = "@parameter.inner",
          ["aa"] = "@parameter.outer",
          ["ar"] = "@return.outer",
          ["ir"] = "@return.inner",
          ["ac"] = { query = "@call.outer", desc = "Outer part of function call" },
          ["ic"] = { query = "@call.inner", desc = "Inner part of function call" },
          -- You can optionally set descriptions to the mappings (used in the desc parameter of
          -- nvim_buf_set_keymap) which plugins like which-key display
          -- You can also use captures from other query groups like `locals.scm`
          -- ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        -- You can choose the select mode (default is charwise 'v')
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        -- TODO: change this to a functions which returns most sensible things based on filetype
        selection_modes = selection_modes
      },
      swap = {
        enable = true,
        swap_previous = {
          ["<leader>,"] = { query = "@parameter.inner", desc = "swap with previous parameter" },
        },
        swap_next = {
          ["<leader>."] = { query = "@parameter.inner", desc = "swap with next parameter" },
        },
      },

      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]v"] = { query = "@assignment.outer", desc = "Next assignment" },
          ["]f"] = { query = "@function.outer", desc = "Next function" },
          ["]]"] = { query = "@class.outer", desc = "Next class" },
          ["]l"] = { query = "@loop.outer", desc = "Next loop" },
          -- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
          ["]c"] = { query = "@call.outer", desc = "Next call" },
          ["]C"] = { query = "@call.inner", desc = "Next call" },
          ["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
          ["]r"] = "@return.inner",
        },
        goto_next_end = {
          ["]ev"] = { query = "@assignment.outer", desc = "Next assignment" },
          ["]ef"] = "@function.outer",
          ["]e]"] = "@class.outer",
          ["]el"] = { query = "@loop.outer", desc = "Next loop" },
          -- ["]es"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
          ["]ec"] = { query = "@call.outer", desc = "Next call" },
          ["]eC"] = { query = "@call.inner", desc = "Next call" },
          ["]ea"] = { query = "@parameter.inner", desc = "Next parameter" },
          ["]er"] = "@return.inner",
        },
        goto_previous_start = {
          ["[v"] = { query = "@assignment.outer", desc = "Previous assignment" },
          ["[f"] = { query = "@function.outer", desc = "Previous function" },
          ["[]"] = { query = "@class.outer", desc = "Previous class" },
          ["[l"] = { query = "@loop.outer", desc = "Previous loop" },
          -- ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
          ["[c"] = { query = "@call.outer", desc = "Previous call" },
          ["[C"] = { query = "@call.inner", desc = "Previous call" },
          ["[a"] = { query = "@parameter.inner", desc = "Previous parameter" },
          ["[r"] = "@return.inner",
        },
        goto_previous_end = {
          ["[ev"] = { query = "@assignment.outer", desc = "Previous assignment" },
          ["[ef"] = { query = "@function.outer", desc = "Previous function" },
          ["[e]"] = { query = "@class.outer", desc = "Previous class" },
          ["[el"] = { query = "@loop.outer", desc = "Previous loop" },
          -- ["[es"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
          ["[ec"] = { query = "@call.outer", desc = "Previous call" },
          ["[eC"] = { query = "@call.inner", desc = "Previous call" },
          ["[ea"] = { query = "@parameter.inner", desc = "Previous parameter" },
          ["[er"] = "@return.inner",
        },
        -- Below will go to either the start or the end, whichever is closer.
        -- Use if you want more granular movements
        -- Make it even more gradual by adding multiple queries and regex.
        goto_next = {
          ["]d"] = "@conditional.outer",
        },
        goto_previous = {
          ["[d"] = "@conditional.outer",
          ["[r"] = "@return.outer",
        }
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        scope_incremental = '<CR>',
        node_incremental = '<TAB>',
        node_decremental = '<BS>',
      },
    },
  }

  local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

  vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
  vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
  vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

  -- default config
  require("various-textobjs").setup {
    -- lines to seek forwards for "small" textobjs (mostly characterwise textobjs)
    -- set to 0 to only look in the current line
    lookForwardSmall = 5,

    -- lines to seek forwards for "big" textobjs (mostly linewise textobjs)
    lookForwardBig = 15,

    -- use suggested keymaps (see overview table in README)
    useDefaultKeymaps = true,

    -- disable only some default keymaps, e.g. { "ai", "ii" }
    disabledKeymaps = { "\\", "iq", "aq", "in", "an" },
  }


  vim.keymap.set({ "o" }, "ov", "<cmd>lua require('various-textobjs').value('outer')<CR>")

  vim.keymap.set({ "o" }, "ok", "<cmd>lua require('various-textobjs').key('outer')<CR>")

  vim.keymap.set("n", "dsi", function()
    -- select outer indentation
    require("various-textobjs").indentation("outer", vim.o.filetype == 'python' and 'inner' or "outer")

    -- plugin only switches to visual mode when a textobj has been found
    local indentationFound = vim.fn.mode():find("V")
    if not indentationFound then return end

    -- dedent indentation
    vim.cmd.normal { "<", bang = true }

    -- delete surrounding lines
    local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1]
    local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1]
    if vim.o.filetype ~= "python" then
      vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
    end
    vim.cmd(tostring(startBorderLn) .. " delete")
  end, { desc = "Delete Surrounding Indentation" })

  vim.keymap.set("n", "ysii", function()
    local startPos = vim.api.nvim_win_get_cursor(0)

    -- identify start- and end-border
    require("various-textobjs").indentation("outer", vim.o.filetype == 'python' and "inner" or 'outer')
    local indentationFound = vim.fn.mode():find("V")
    if not indentationFound then return end
    vim.cmd.normal { "V", bang = true } -- leave visual mode so the `'<` `'>` marks are set

    -- copy them into the + register
    local startLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
    local endLn = vim.api.nvim_buf_get_mark(0, ">")[1] - 1
    local startLine = vim.api.nvim_buf_get_lines(0, startLn, startLn + 1, false)[1]
    local endLine = vim.api.nvim_buf_get_lines(0, endLn, endLn + 1, false)[1]
    if vim.o.filetype == 'python' then
      vim.fn.setreg("+", startLine .. "\n")
    else
      vim.fn.setreg("+", startLine .. "\n" .. endLine .. "\n")
    end


    -- highlight yanked text: doesn't work for some reason
    local ns = vim.api.nvim_create_namespace("ysi")
    vim.highlight.range(0, ns, "IncSearch", { startLn, 0 }, { startLn, -1 })
    vim.highlight.range(0, ns, "IncSearch", { endLn, 0 }, { endLn, -1 })
    vim.defer_fn(function() vim.api.nvim_buf_clear_namespace(0, ns, 0, -1) end, 2000)

    -- restore cursor position
    vim.api.nvim_win_set_cursor(0, startPos)
  end, { desc = "Yank surrounding indentation" })

  local function openRepo()
    require("various-textobjs").anyQuote('inner')
    local repo = vim.fn.mode():find("v")
    if repo then
      vim.cmd.normal('"zy')
      local url = "https://github.com/" .. vim.fn.getreg("z")
      vim.ui.open(url)
      return true
    end
    return false
  end

  vim.keymap.set("n", "gX", openRepo, { desc = "Open Repository" })
  vim.keymap.set("n", "gx", function()
    require("various-textobjs").url()
    local foundURL = vim.fn.mode():find("v")

    if foundURL then
      vim.cmd.normal('"zy')
      local url = vim.fn.getreg("z")
      vim.ui.open(url)
    elseif not openRepo() then
      -- find all URLs in buffer
      local urlPattern = require("various-textobjs.charwise-textobjs").urlPattern
      local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
      local urls = {}
      for url in bufText:gmatch(urlPattern) do
        table.insert(urls, url)
      end
      if #urls == 0 then return end

      -- select one, use a plugin like dressing.nvim for nicer UI for
      -- `vim.ui.select`
      vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
        if choice then vim.ui.open(choice) end
      end)
    end
  end, { desc = "URL Opener" })
end

M.harpoon = function()
  local harpoon = require("harpoon")

  -- REQUIRED
  harpoon:setup()
  -- REQUIRED

  -- Toggle previous & next buffers stored within Harpoon list
  vim.keymap.set("n", "<Up>", function() harpoon:list():prev() end)
  vim.keymap.set("n", "<Down>", function() harpoon:list():next() end)
end

M.copilot = function()
  local cp = require("copilot")
  local cs = require("copilot.suggestion")
  vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#83a598" })
  vim.keymap.set("n", "gps", M.repeatable_moves().prev_suggestion)
  vim.keymap.set("n", "gns", M.repeatable_moves().next_suggestion)
  vim.keymap.set("i", "<C-f>", function()
    if cs.is_visible() then
      cs.accept_word()
    else
      vim.cmd [[normal! w]]
    end
  end, { noremap = true })
  cp.setup({
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = {
        -- jump_prev = false,
        -- jump_next = false,
        accept = "<CR>", -- clashing with nvim-treesitter related thing
        refresh = "gr",
        open = "<M-CR>"  -- doesn't work for some reason
      },
      layout = {
        position = "bottom", -- | top | left | right
        ratio = 0.4
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<C-;>",
        accept_word = false,
        accept_line = "<C-g>",
        next = "<M-n>",
        prev = "<M-p>",
        dismiss = "<C-c>",
      },
    },
    filetypes = {
      yaml = false,
      norg = false,
      markdown = false,
      help = false,
      gitcommit = true,
      gitrebase = true,
      hgcommit = false,
      svn = false,
      cvs = false,
      txt = false,
      ["."] = false,
    },
  })
end

M.comment = function()
  -- 🧠 💪 // Smart and powerful comment plugin for neovim. Supports treesitter, dot repeat, left-right/up-down motions, hooks, and more
  --
  require("Comment").setup(
    {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    }
  )
end

M.substitute = function()
  require("substitute").setup({
    on_substitute = require("yanky.integration").substitute(),
    yank_substituted_text = false,
    range = {
      prefix = "x",
      prompt_current_text = false,
      confirm = false,
      complete_word = false,
      motion1 = false,
      motion2 = false,
      suffix = "",
    },
    exchange = {
      motion = false,
      use_esc_to_cancel = true,
      preserve_cursor_position = true,
    },
  })

  vim.keymap.set("n", "x", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
  vim.keymap.set("n", "xx", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
  vim.keymap.set("n", "X", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })

  vim.keymap.set("n", "xc", require('substitute.exchange').operator, { noremap = true })
  vim.keymap.set("n", "xcc", require('substitute.exchange').line, { noremap = true })
  vim.keymap.set("n", "xcx", require('substitute.exchange').cancel, { noremap = true })
  vim.keymap.set("n", "xxx", require('substitute.exchange').cancel, { noremap = true })

  vim.keymap.set("x", "x", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
  vim.keymap.set("x", "X", require('substitute.exchange').visual, { noremap = true })
end

M.dial = function()
  local augend = require("dial.augend")

  require("dial.config").augends:register_group {
    default = {
      augend.integer.alias.decimal_int,
      augend.integer.alias.binary,
      augend.integer.alias.hex,
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%d/%m/%Y"],
      augend.semver.alias.semver,
      augend.constant.alias.bool,
      -- augend.constant.alias.alpha,
      -- augend.constant.alias.Alpha,


      augend.constant.new {
        elements = { 'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten' },
        word = false,
        cyclic = true,
      },

      augend.constant.new {
        elements = { "and", "or" },
        word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
        cyclic = true, -- "or" is incremented into "and".
      },
      augend.constant.new {
        elements = { "&&", "||" },
        word = false,
        cyclic = true,
      },

      augend.constant.new {
        elements = { 'left', 'right', 'top', 'bottom' },
        word = false,
        cyclic = true,
      },

      augend.constant.new {
        elements = { 'True', 'False' },
        word = true,
        cyclic = true,
      },

      augend.constant.new {
        elements = { 'yes', 'no' },
        word = true,
        cyclic = true,
      },
      augend.constant.new {
        elements = { 'enabled', 'disabled' },
        word = true,
        cyclic = true,
      },

      augend.constant.new {
        elements = { 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' },
        word = true,
        cyclic = true,
      },

      augend.constant.new {
        elements = {
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' },
        word = true,
        cyclic = true,
      },

    },
    typescript = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.constant.new { elements = { "let", "const" } },
    },

  }

  vim.keymap.set("n", "<C-a>", function()
    require("dial.map").manipulate("increment", "normal")
  end)
  vim.keymap.set("n", "<C-x>", function()
    require("dial.map").manipulate("decrement", "normal")
  end)
  vim.keymap.set("n", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gnormal")
  end)
  vim.keymap.set("n", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gnormal")
  end)
  vim.keymap.set("v", "<C-a>", function()
    require("dial.map").manipulate("increment", "visual")
  end)
  vim.keymap.set("v", "<C-x>", function()
    require("dial.map").manipulate("decrement", "visual")
  end)
  vim.keymap.set("v", "g<C-a>", function()
    require("dial.map").manipulate("increment", "gvisual")
  end)
  vim.keymap.set("v", "g<C-x>", function()
    require("dial.map").manipulate("decrement", "gvisual")
  end)


  vim.keymap.set("n", "+", function()
    require("dial.map").manipulate("increment", "normal")
  end)
  vim.keymap.set("n", "-", function()
    require("dial.map").manipulate("decrement", "normal")
  end)
  vim.keymap.set("n", "g+", function()
    require("dial.map").manipulate("increment", "gnormal")
  end)
  vim.keymap.set("n", "g-", function()
    require("dial.map").manipulate("decrement", "gnormal")
  end)
  vim.keymap.set("v", "+", function()
    require("dial.map").manipulate("increment", "visual")
  end)
  vim.keymap.set("v", "-", function()
    require("dial.map").manipulate("decrement", "visual")
  end)
  vim.keymap.set("v", "g+", function()
    require("dial.map").manipulate("increment", "gvisual")
  end)
  vim.keymap.set("v", "g-", function()
    require("dial.map").manipulate("decrement", "gvisual")
  end)
end

M.nvim_dap_python = function()
  require("dap-python").setup("~/.local/share/nvim/mason/bin/debugpy")
end

M.dapui = function()
  local dapui = require('dapui')
  dapui.setup()
  local dap = require("dap")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
  require("nvim-dap-virtual-text").setup()
end

M.leap = function()
  require("leap").add_default_mappings()
end

M.vim_easy_align = function()
  vim.cmd([[
      " Start interactive EasyAlign in visual mode (e.g. vipga)
      xmap ga <Plug>(EasyAlign)

      " Start interactive EasyAlign for a motion/text object (e.g. gaip)
      nmap ga <Plug>(EasyAlign)
      ]])
end

M.refactoring = function()
  require('refactoring').setup({
    prompt_func_return_type = {
      go = false,
      java = false,

      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    prompt_func_param_type = {
      go = false,
      java = false,

      cpp = false,
      c = false,
      h = false,
      hpp = false,
      cxx = false,
    },
    printf_statements = {},
    print_var_statements = {},
  })
end

M.lsp_config = function()
  local util = M._lsp_utils
  require("mason").setup()

  local capabilities = util.mkcaps(true)
  local on_attach = util.on_attach



  -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
  require("neodev").setup({
    -- add any options here, or leave empty to use the default settings
    library = {
      plugins = { "nvim-dap-ui", "trouble.nvim", "nvim-web-devicons",
        "telescope.nvim",
        "lazy.nvim" },
      types = true
    },
  })
  -- It's important that you set up neoconf.nvim BEFORE nvim-lspconfig.

  require("neoconf").setup({
    -- override any of the default settings here
  })
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
    pyright = function()
      require('lspconfig').pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              -- ignore = { '*' },
            },
          },
        },
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
  }
  )

  require('lspconfig').ruff_lsp.setup {
    on_attach = on_attach,
    init_options = {
      settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {},
        lint = {
          -- Disable all linters in favor of Pyright
          enable = false,
        },
      }
    }
  }
  -- required to trigger lspattach
  vim.api.nvim_exec_autocmds("FileType", {})
end
M.fidget = function()
  local fidget = require("fidget")

  fidget.setup({
    progress = {
      display = {
        overrides = {
          rust_analyzer = { name = "rust-analyzer" },
          lua_ls = { name = "lua-ls" },
        },
      },
    },
    notification = {
      override_vim_notify = false,

      window = {
        align = "top", -- How to align the notification window
      }
    }
  })
end

M.typescript_tools = function()
  local util = M._lsp_utils
  local capabilities = util.mkcaps(true)
  local on_attach = util.on_attach

  require("typescript-tools").setup {
    on_attach = on_attach,
    handlers = capabilities,
    settings = {
      -- spawn additional tsserver instance to calculate diagnostics on it
      separate_diagnostic_server = true,
      -- "change"|"insert_leave" determine when the client asks the server about diagnostic
      publish_diagnostic_on = "insert_leave",
      -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
      -- "remove_unused_imports"|"organize_imports") -- or string "all"
      -- to include all supported code actions
      -- specify commands exposed as code_actions
      expose_as_code_action = "all",
      -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
      -- not exists then standard path resolution strategy is applied
      tsserver_path = nil,
      -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
      -- (see 💅 `styled-components` support section)
      tsserver_plugins = {},
      -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
      -- memory limit in megabytes or "auto"(basically no limit)
      tsserver_max_memory = "auto",
      -- described below
      tsserver_format_options = {
        -- following two are example format options that i disabled because why not?
        -- allowIncompleteCompletions = false,
        -- allowRenameOfImportPath = false,
      },
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeCompletionsForModuleExports = true,
        quotePreference = "auto",

      },
      -- locale of all tsserver messages, supported locales you can find here:
      -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
      tsserver_locale = "en",
      -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      complete_function_calls = false,
      include_completions_with_insert_text = true,
      -- CodeLens
      -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
      -- possible values: ("off"|"all"|"implementations_only"|"references_only")
      -- TODO: test to see if this will slow down the server
      code_lens = "all",
      -- by default code lenses are displayed on all referencable values and for some of you it can
      -- be too much this option reduce count of them by removing member references from lenses
      disable_member_code_lens = true,
      -- JSXCloseTag
      -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-auto-tag,
      -- that maybe have a conflict if enable this feature. )
      jsx_close_tag = {
        -- TODO: test to see if this will improve things
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact", "typescript" },
      }
    },
  }
end

return M
