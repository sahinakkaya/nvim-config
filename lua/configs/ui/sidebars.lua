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
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 10,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false,
  },
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

vim.keymap.set({ "n", "x", "o" }, "]h", next_hunk_repeat)
vim.keymap.set({ "n", "x", "o" }, "[h", prev_hunk_repeat)
