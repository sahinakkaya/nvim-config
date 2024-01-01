-- Built-in Textobjects
--     @assignment.inner
--     @assignment.lhs
--     @assignment.outer
--     @assignment.rhs
--     @attribute.inner
--     @attribute.outer
--     @block.inner
--     @block.outer
--     @call.inner
--     @call.outer
--     @class.inner
--     @class.outer
--     @comment.inner
--     @comment.outer
--     @conditional.inner
--     @conditional.outer
--     @frame.inner
--     @frame.outer
--     @function.inner
--     @function.outer
--     @loop.inner
--     @loop.outer
--     @number.inner
--     @parameter.inner
--     @parameter.outer
--     @regex.inner
--     @regex.outer
--     @return.inner
--     @return.outer
--     @scopename.inner
--     @statement.outer

---@diagnostic disable-next-line: missing-fields
require 'nvim-treesitter.configs'.setup {
  -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
  auto_install = true,

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
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        ["aa"] = "@assignment.outer",
        ["ia"] = "@assignment.inner",
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
        ["ip"] = "@parameter.inner",
        ["ap"] = "@parameter.outer",
        ["ig"] = "@parameter.inner",
        ["ag"] = "@parameter.outer",
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
      selection_modes = {
        -- ['@class.outer'] = '<c-v>', -- blockwise
        ['@parameter.outer'] = 'v', -- charwise
        ['@class.outer'] = 'V',   -- linewise
        ['@conditional.outer'] = 'V', -- linewise
        ['@class.inner'] = 'V',
        ['@function.outer'] = 'V',
        ['@function.inner'] = 'V',
        ['@loop.outer'] = 'V',
        ['@loop.inner'] = 'V',
      },
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
        ["]a"] = { query = "@assignment.outer", desc = "Next assignment" },
        ["]f"] = { query = "@function.outer", desc = "Next function" },
        ["]]"] = { query = "@class.outer", desc = "Next class" },
        ["]l"] = { query = "@loop.outer", desc = "Next loop" },
        -- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]c"] = { query = "@call.outer", desc = "Next call" },
        ["]C"] = { query = "@call.inner", desc = "Next call" },
        ["]g"] = { query = "@parameter.inner", desc = "Next parameter" },
        ["]r"] = "@return.inner",
      },
      goto_next_end = {
        ["]ea"] = { query = "@assignment.outer", desc = "Next assignment" },
        ["]ef"] = "@function.outer",
        ["]e]"] = "@class.outer",
        ["]el"] = { query = "@loop.outer", desc = "Next loop" },
        -- ["]es"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]ec"] = { query = "@call.outer", desc = "Next call" },
        ["]eC"] = { query = "@call.inner", desc = "Next call" },
        ["]eg"] = { query = "@parameter.inner", desc = "Next parameter" },
        ["]er"] = "@return.inner",
      },
      goto_previous_start = {
        ["[a"] = { query = "@assignment.outer", desc = "Previous assignment" },
        ["[f"] = { query = "@function.outer", desc = "Previous function" },
        ["[]"] = { query = "@class.outer", desc = "Previous class" },
        ["[l"] = { query = "@loop.outer", desc = "Previous loop" },
        -- ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
        ["[c"] = { query = "@call.outer", desc = "Previous call" },
        ["[C"] = { query = "@call.inner", desc = "Previous call" },
        ["[g"] = { query = "@parameter.inner", desc = "Previous parameter" },
        ["[r"] = "@return.inner",
      },
      goto_previous_end = {
        ["[ea"] = { query = "@assignment.outer", desc = "Previous assignment" },
        ["[ef"] = { query = "@function.outer", desc = "Previous function" },
        ["[e]"] = { query = "@class.outer", desc = "Previous class" },
        ["[el"] = { query = "@loop.outer", desc = "Previous loop" },
        -- ["[es"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
        ["[ec"] = { query = "@call.outer", desc = "Previous call" },
        ["[eC"] = { query = "@call.inner", desc = "Previous call" },
        ["[eg"] = { query = "@parameter.inner", desc = "Previous parameter" },
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
  --   textsubjects = { -- works in visual mode
  --     enable = true,
  --     prev_selection = ',', -- (Optional) keymap to select the previous selection
  --     keymaps = {
  --         ['<CR>'] = 'textsubjects-smart',
  --         [';'] = 'textsubjects-container-outer',
  --         ['i;'] = 'textsubjects-container-inner',
  --         ['i;'] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
  --     },
  --
  -- },
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
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

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
  disabledKeymaps = { "gc" },
}
