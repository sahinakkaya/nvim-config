local whichkey = require("which-key")

local harpoon = function()
  return require("harpoon")
end


local hydra = require("hydra")
local hydras = require("configs.ui.hydra_config")
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

local function repeatable_moves()
  local M = {}
  local gs = require("gitsigns")
  local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
  -- make sure forward function comes first
  local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
  -- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.
  M.next_hunk = function()
    next_hunk_repeat()
  end
  M.prev_hunk = function()
    prev_hunk_repeat()
  end
  return M
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
  ["<tab>"] = { "<C-^>", "Alternate file" },
  ["<space>"] = { ":Telescope frecency workspace=CWD<CR>", "Frecent files" },
  ["\\"] = { ":vnew<CR>", "vsplit" },
  ["-"] = { ":new<CR>", "hsplit" },
  a = { function() harpoon():list():add() end, "Harpoon add" },
  e = { ":Neotree toggle reveal right last<CR>", "Explorer" },

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
    f = { ":Telescope frecency workspace=CWD<CR>", "cwd" },
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
    j = { repeatable_moves().next_hunk, "Next Hunk" },

    d = { function()
      require("gitsigns").diffthis('~')
    end, "Diff this" },
    e = { require("gitsigns").toggle_deleted, "Toggle Deleted" },
    k = { repeatable_moves().prev_hunk, "Prev Hunk" },
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

  j = {
    name = "Jump",
    ["<Space>"] = { function() harpoon():list():append() end, "Harpoon add" },
    a = { function() harpoon():list():select(1) end, "Harpoon a" },
    s = { function() harpoon():list():select(2) end, "Harpoon s" },
    d = { function() harpoon():list():select(3) end, "Harpoon d" },
    f = { function() harpoon():list():select(4) end, "Harpoon f" },
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
      local enabled = vim.lsp.inlay_hint.is_enabled(0)
      vim.lsp.inlay_hint.enable(not enabled)
    end, "Toggle inlay hints" },
    i = { vim.lsp.buf.implementation, "Go to implementation" },
    h = { vim.lsp.buf.hover, "Hover info" },
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
      n = { ":IncRename ", "Rename" },
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
    n = { ":Fidget history<CR>", "Notifications" },
  },

  s = {
    name = "Search",
    b = { ":Telescope git_branches<CR>", "Checkout branch" },
    c = { ":Telescope colorscheme<CR>", "Colorscheme" },
    C = { ":Telescope commands<CR>", "Commands" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    h = { ":Telescope help_tags<CR>", "Find Help" },
    H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
    k = { ":Telescope keymaps<CR>", "Keymaps" },
    m = { ":Telescope man_pages<CR>", "Man Pages" },
    n = { ":Fidget history<CR>", "Notifications" },
    r = { ":Telescope oldfiles<CR>", "Open Recent File" },
    -- s = { ":Telescope projects<CR>", "Recent Projects" },
    R = { ":Telescope registers<CR>", "Registers" },
    t = { ":Telescope live_grep theme=ivy<CR>", "Find Text" },
    v = { ":vnew<CR>", "vsplit" },
    s = { ":new<CR>", "hsplit" },
  },
  t = {
    name = "Trouble",
    D = { ":DBUIToggle<CR>", "DBUI Toggle" },
    d = { function() require("trouble").toggle("document_diagnostics") end, "Document Diagnostics" },
    f = { function() require("trouble").toggle("lsp_definitions") end, "Lsp Definitions" },
    l = { function() require("trouble").toggle("loclist") end, "Location List" },
    i = { function() require("trouble").toggle("lsp_implementations") end, "Lsp Implementations" },
    r = { function() require("trouble").toggle("lsp_references") end, "Lsp References" },
    t = { function() require("trouble").toggle() end, "Trouble Toggle" },
    w = { function() require("trouble").toggle("workspace_diagnostics") end, "Workspace Diagnostics" },
    q = { function() require("trouble").toggle("quickfix") end, "Quickfix list" },
    n = { ":Fidget history<CR>", "Notifications" },
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
