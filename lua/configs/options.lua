M = {}

local home = os.getenv('HOME')

local options = {
  backup = true, -- creates a backup file
  backupdir = home .. '/.cache/nvim/backup',
  background = 'dark',

  undofile = true,      -- enable persistent undo
  swapfile = false,     -- creates a swapfile
  writebackup = false,  -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  termguicolors = true, -- set term gui colors (most terminals support this)
  mousemoveevent = true,

  spell = false,
  spelllang = 'en,tr',
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 1,                        -- default 0, so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  pumblend = 0,                            -- pop up menu transparency
  -- winblend = 10,
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  -- smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  timeoutlen = 500,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  updatetime = 300,                        -- faster completion (4000ms default)
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  cursorline = false,                      -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = true,                             -- display lines in multiple lines
  scrolloff = 999,                         -- show at least n number of lines before after cursor
  sidescrolloff = 6,
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  foldmethod = "expr",
  foldlevelstart = 4,
  foldenable = false,
  foldexpr = "nvim_treesitter#foldexpr()",
  fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
  foldcolumn = '1',

  virtualedit = "block",
  inccommand = "split"

  -- foldclose = 'all',
  -- foldopen = 'all',

  -- mousescroll = "ver:1,hor:6"
}

-- vim.api.cmd('set formatoptions-=cro') -- TODO: this doesn't seem to work

vim.opt.shortmess:append "c"
vim.opt.whichwrap:append "<,>,[,]"
vim.opt.iskeyword:append "-"

for k, v in pairs(options) do
  vim.opt[k] = v
end


for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
  vim.opt.path:append(path .. '/lua')
end

M.ultimate_pairs = {
  cmap = false,     --cmap stands for cmd-line map
  fastwarp = {      -- *ultimate-autopair-map-fastwarp-config*
    map = '<C-l>',  --string or table
    rmap = '<C-h>', --string or table
  },
}

M.nvim_surround = {
  aliases = {
    ["a"] = ">",
    -- ["b"] = ")",
    -- ["B"] = "}",
    -- ["r"] = "]",
    -- ["q"] = { '"', "'", "`" },
    ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
  },

}

M.troublev3 = {
  auto_close = false,   -- auto close when there are no items
  auto_open = false,    -- auto open when there are items
  auto_preview = true,  -- automatically open preview when on an item
  auto_jump = true,
  auto_refresh = true,  -- auto refresh when open
  focus = false,        -- Focus the window when opened
  restore = true,       -- restores the last location in the list when opening
  follow = true,        -- Follow the current item
  indent_guides = true, -- show indent guides
  max_items = 200,      -- limit number of items that can be displayed per section
  multiline = true,     -- render multi-line messages
  pinned = false,       -- When pinned, the opened trouble window will be bound to the current buffer
  ---@type trouble.Window.opts
  win = {},             -- window options for the results window. Can be a split or a floating window.
  -- Window options for the preview window. Can be a split, floating window,
  -- or `main` to show the preview in the main editor window.
  ---@type trouble.Window.opts
  preview = { type = "main" },
  -- Throttle/Debounce settings. Should usually not be changed.
  ---@type table<string, number|{ms:number, debounce?:boolean}>
  throttle = {
    refresh = 20,                            -- fetches new data when needed
    update = 10,                             -- updates the window
    render = 10,                             -- renders the window
    follow = 10,                             -- follows the current item
    preview = { ms = 100, debounce = true }, -- shows the preview for the current item
  },
  -- Key mappings can be set to the name of a builtin action,
  -- or you can define your own custom action.
  modes = {
    test = {
      mode = "diagnostics",
      desc = "diagnostics",
      preview = {
        type = "split",
        relative = "win",
        position = "right",
        size = 0.3,
      },
      -- preview = {
      --   type = "float",
      --   relative = "editor",
      --   border = "rounded",
      --   title = "Preview",
      --   title_pos = "center",
      --   position = { 0, -2 },
      --   size = { width = 0.3, height = 0.3 },
      --   zindex = 200,
      -- },
    },
    symbols = {
      desc = "document symbols",
      mode = "lsp_document_symbols",
      focus = true,
      win = { position = "right" },
      filter = {
        -- remove Package since luals uses it for control flow structures
        ["not"] = { ft = "lua", kind = "Package" },
        any = {
          -- all symbol kinds for help / markdown files
          ft = { "help", "markdown" },
          -- default set of symbol kinds
          kind = {
            "Class",
            "Constructor",
            "Enum",
            "Field",
            "Function",
            "Interface",
            "Method",
            "Module",
            "Namespace",
            "Package",
            "Property",
            "Struct",
            "Trait",
          },
        },
      },
    },
  },
}

M.trouble = {
  position = "bottom", -- position of the list can be: bottom, top, left, right
  height = 10, -- height of the trouble list when position is top or bottom
  width = 50, -- width of the list when position is left or right
  icons = true, -- use devicons for filenames
  mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
  fold_open = "", -- icon used for open folds
  fold_closed = "", -- icon used for closed folds
  group = true, -- group results by file
  padding = true, -- add an extra new line on top of the list
  cycle_results = true, -- cycle item list when reaching beginning or end of list
  action_keys = { -- key mappings for actions in the trouble list
    -- map to {} to remove a mapping, for example:
    -- close = {},
    close = "q",                                                                        -- close the list
    cancel = "<esc>",                                                                   -- cancel the preview and get back to your last window / buffer / cursor
    refresh = "r",                                                                      -- manually refresh
    jump = { "<cr>", "<tab>", "<2-leftmouse>" },                                        -- jump to the diagnostic or open / close folds
    open_split = { "<c-x>" },                                                           -- open buffer in new split
    open_vsplit = { "<c-v>" },                                                          -- open buffer in new vsplit
    open_tab = { "<c-t>" },                                                             -- open buffer in new tab
    jump_close = { "o" },                                                               -- jump to the diagnostic and close the list
    toggle_mode = "m",                                                                  -- toggle between "workspace" and "document" diagnostics mode
    switch_severity = "s",                                                              -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
    toggle_preview = "P",                                                               -- toggle auto_preview
    hover = "K",                                                                        -- opens a small popup with the full multiline message
    preview = "p",                                                                      -- preview the diagnostic location
    open_code_href = "c",                                                               -- if present, open a URI with more information about the diagnostic error
    close_folds = { "zM", "zm" },                                                       -- close all folds
    open_folds = { "zR", "zr" },                                                        -- open all folds
    toggle_fold = { "zA", "za" },                                                       -- toggle fold of current file
    previous = "k",                                                                     -- previous item
    next = "j",                                                                         -- next item
    help = "?"                                                                          -- help menu
  },
  multiline = true,                                                                     -- render multi-line messages
  indent_lines = true,                                                                  -- add an indent guide below the fold icons
  win_config = { border = "single" },                                                   -- window configuration for floating windows. See |nvim_open_win()|.
  auto_open = false,                                                                    -- automatically open the list when you have diagnostics
  auto_close = true,                                                                   -- automatically close the list when you have no diagnostics
  auto_preview = true,                                                                  -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
  auto_fold = false,                                                                    -- automatically fold a file trouble list at creation
  auto_jump = { "lsp_definitions" },                                                    -- for the given modes, automatically jump if there is only a single result
  include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions" }, -- for the given modes, include the declaration of the current symbol in the results
  signs = {
    -- icons / text used for a diagnostic
    error = "",
    warning = "",
    hint = "",
    information = "",
    other = "",
  },
  use_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client

}

M.yanky = {
  ring = { storage = "memory" },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 300,
  },
  textobj = {
    enabled = true,
  },
}

return M
