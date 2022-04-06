local whichkey = require("which-key")

whichkey.setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
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
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", ":", ":", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  ["/"] = { ":lua require('Comment.api').toggle_current_linewise()<CR>", "Comment" },
  -- ["a"] = { ":Alpha<CR>", "Alpha" },
  ["b"] = {
    name = "Buffer",
    b = {
    ":lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<CR>",
    "Buffers",
    },
    q = {":Bdelete<CR>", "Delete buffer"}
  },
  ["<tab>"] = { "<C-^>", "Alternate file" },
  -- ['r'] = { ':set invrelativenumber<CR>', 'Toggle relative number' },
  ['r'] = {
    name = "Rotate windows",
    ["h"] = { "<C-W>H", "Move window to far left" },
    ["l"] = { "<C-W>L", "Move window to far right" },
    ["j"] = { "<C-W>J", "Move window to very top" },
    ["k"] = { "<C-W>K", "Move window to very bottom" },
    ["r"] = { "<C-W>r", "Rotate windows to down/right" },
    ["R"] = { "<C-W>R", "Rotate windows to up/left" },
    ["s"] = { "<C-W>x", "Swap with closest to right" },

  },
  ['\\'] = {':vnew<CR>', 'vsplit'},
  ['-'] = {':new<CR>', 'hsplit'},
  ["e"] = { ":NvimTreeToggle<CR>", "Explorer" },
  ["w"] = { ":HopWord<CR>", "Hop word" },
  ["j"] = { ":HopLineStartAC<CR>", "Hop line" },
  ["k"] = { ":HopLineStartBC<CR>", "Hop line" },
  ["q"] = { ":q!<CR>", "Quit" },
  ["c"] = { ":Bdelete!<CR>", "Close Buffer" },
  ["h"] = { ":nohlsearch<CR>", "No Highlight" },
  ["f"] = {
    ":lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<CR>",
    "Find files",
  },
  ["F"] = { ":Telescope live_grep theme=ivy<CR>", "Find Text" },
  ["P"] = { ":lua require('telescope').extensions.projects.projects()<CR>", "Projects" },

  p = {
    name = "Packer",
    c = { ":PackerCompile<CR>", "Compile" },
    i = { ":PackerInstall<CR>", "Install" },
    s = { ":PackerSync<CR>", "Sync" },
    S = { ":PackerStatus<CR>", "Status" },
    u = { ":PackerUpdate<CR>", "Update" },
  },

  g = {
    name = "Git",
    g = { ":lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    j = { ":lua require 'gitsigns'.next_hunk()<CR>", "Next Hunk" },
    k = { ":lua require 'gitsigns'.prev_hunk()<CR>", "Prev Hunk" },
    l = { ":Gitsigns toggle_current_line_blame<CR>", "Toggle Git Blame" },
    p = { ":lua require 'gitsigns'.preview_hunk()<CR>", "Preview Hunk" },
    r = { ":lua require 'gitsigns'.reset_hunk()<CR>", "Reset Hunk" },
    R = { ":lua require 'gitsigns'.reset_buffer()<CR>", "Reset Buffer" },
    s = { ":lua require 'gitsigns'.stage_hunk()<CR>", "Stage Hunk" },
    u = {
      ":lua require 'gitsigns'.undo_stage_hunk()<CR>",
      "Undo Stage Hunk",
    },
    o = { ":Telescope git_status<CR>", "Open changed file" },
    b = { ":Telescope git_branches<CR>", "Checkout branch" },
    c = { ":Telescope git_commits<CR>", "Checkout commit" },
    d = {
      ":Gitsigns diffthis HEAD<CR>",
      "Diff",
    },
  },

  l = {
    name = "LSP",
    a = { ":lua vim.lsp.buf.code_action()<CR>", "Code Action" },
    d = {
      ":Telescope lsp_document_diagnostics<CR>",
      "Document Diagnostics",
    },
    w = {
      ":Telescope lsp_workspace_diagnostics<CR>",
      "Workspace Diagnostics",
    },
    f = { ":lua vim.lsp.buf.formatting()<CR>", "Format" },
    i = { ":LspInfo<CR>", "Info" },
    I = { ":LspInstallInfo<CR>", "Installer Info" },
    j = {
      ":lua vim.diagnostic.goto_next()<CR>",
      "Next Diagnostic",
    },
    k = {
      ":lua vim.diagnostic.goto_prev()<CR>",
      "Prev Diagnostic",
    },
    l = { ":lua vim.lsp.codelens.run()<CR>", "CodeLens Action" },
    q = { ":lua vim.lsp.diagnostic.set_loclist()<CR>", "Quickfix" },
    r = { ":lua vim.lsp.buf.rename()<CR>", "Rename" },
    s = { ":Telescope lsp_document_symbols<CR>", "Document Symbols" },
    S = {
      ":Telescope lsp_dynamic_workspace_symbols<CR>",
      "Workspace Symbols",
    },
  },
  s = {
    name = "Search",
    b = { ":Telescope git_branches<CR>", "Checkout branch" },
    c = { ":Telescope colorscheme<CR>", "Colorscheme" },
    h = { ":Telescope help_tags<CR>", "Find Help" },
    M = { ":Telescope man_pages<CR>", "Man Pages" },
    r = { ":Telescope oldfiles<CR>", "Open Recent File" },
    R = { ":Telescope registers<CR>", "Registers" },
    k = { ":Telescope keymaps<CR>", "Keymaps" },
    C = { ":Telescope commands<CR>", "Commands" },
  },

  t = {
    name = "Trouble",
    q = { ":Trouble quickfix<CR>", "Quickfix list" },
    l = { ":Trouble loclist<CR>", "Location List" },
    r = { ":Trouble lsp_references<CR>", "Lsp References" },
    d = { ":Trouble document_diagnostics<CR>", "Document Diagnostics" },
    w = { ":Trouble workspace_diagnostics<CR>", "Workspace Diagnostics" },
    t = { ":Trouble<CR>", "Trouble Toggle"},
  },
}

whichkey.register(mappings, opts)
