local M = {}

--The keys property can be a string or string[] for simple normal-mode mappings,
--or it can be a LazyKeysSpec table with the following key-value pairs:
--     [1]: (string) lhs (required)
--     [2]: (string|fun()) rhs (optional)
--     mode: (string|string[]) mode (optional, defaults to "n")
--     ft: (string|string[]) filetype for buffer-local keymaps (optional)
--     any other option valid for vim.keymap.set
--
-- Key mappings will load the plugin the first time they get executed.
-- When [2] is nil, then the real mapping has to be created by the config() function.

M.comment = {
  { "gc", mode = { "n", "v" } },
  { "gb", mode = { "n", "v" } },
}

M.smartsplits = {
-- recommended mappings
-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
  -- {'<A-h>', function() require('smart-splits').resize_left() end},
  -- {'<A-j>', function() require('smart-splits').resize_down()  end},
  -- {'<A-k>', function() require('smart-splits').resize_up()  end},
  -- {'<A-l>', function() require('smart-splits').resize_right()  end},
-- moving between splits
  {'<C-h>', function() require('smart-splits').move_cursor_left() end, desc="Move to left window"},
  {'<C-j>', function() require('smart-splits').move_cursor_down() end, desc="Move to bottom window"},
  {'<C-k>', function() require('smart-splits').move_cursor_up() end, desc="Move to bottom window"},
  {'<C-l>', function() require('smart-splits').move_cursor_right() end, desc="Move to bottom window"},
-- swapping buffers between windows
  {'<leader>wh', function() require('smart-splits').swap_buf_left() end, desc="Swap buffer left"},
  {'<leader>wj', function() require('smart-splits').swap_buf_down() end, desc="Swap buffer bottom"},
  {'<leader>wk', function() require('smart-splits').swap_buf_up() end, desc="Swap buffer top"},
  {'<leader>wl', function() require('smart-splits').swap_buf_right() end, desc="Swap buffer right"},

  {'<leader>wr', function() require('smart-splits').start_resize_mode() end, desc="Start resizing mode"},
}

M.spectre = {
  {'<leader>rr', '<cmd>lua require("spectre").toggle()<CR>',  desc = "Toggle Spectre"},
  {'<leader>rw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',  desc = "Search current word"},
  {'<leader>rw', '<esc><cmd>lua require("spectre").open_visual()<CR>', mode ="v",  desc = "Search current word"},
  {'<leader>rp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',  desc = "Search on current file"}
}


M.nvim_dap_python = { "<leader>ds", "<leader>dt" }
M.vim_easy_align = {
  { "ga", mode = { "n", "v" } },
}
M.text_case = {
  "ga",
  { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
}

M.which_key = {
  { "<Leader>", mode = { "n", "v" } },
  { "z", mode = { "n", "v" } },
  { "y", mode = { "n", "v" } },
  { "c", mode = { "n", "v" } },
  { "g", mode = { "n", "v" } },
  { "d", mode = { "n", "v" } },
  { "]", mode = { "n", "v" } },
  { "[", mode = { "n", "v" } }
}
M.vimwiki = { "<Space>ww" }
M.neoscroll = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' }

M.hydra = { { "\\", mode = { "n", "x", "o" } }, { "<leader>h", mode = { "n", "x", "o" } } }

M.nvim_surround = { "ds", "ys", "yS", "cs", { "S", mode = "v" } }

M.dial = {
  { "+",      mode = { "n", "v" } },
  { "-",      mode = { "n", "v" } },
  { "g+",     mode = { "n", "v" } },
  { "g-",     mode = { "n", "v" } },
  { "<c-a>",  mode = { "n", "v" } },
  { "<c-x>",  mode = { "n", "v" } },
  { "g<c-a>", mode = { "n", "v" } },
  { "g<c-x>", mode = { "n", "v" } },
}

M.substitute = {
  { "x", "X",           mode = { "n", "v" } },
  { "X", mode = { "n" } },
}

M.harpoon = { "<Up>", "Down", "<leader>j", "<leader>a" }

M.yanky = {
  { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({}) end, desc = "Open Yank History" },
  { "y",         "<Plug>(YankyYank)",                                                          mode = { "n", "x" },                                desc = "Yank text" },
  { "p",         "<Plug>(YankyPutAfter)",                                                      mode = { "n", "x" },                                desc = "Put yanked text after cursor" },
  { "P",         "<Plug>(YankyPutBefore)",                                                     mode = { "n", "x" },                                desc = "Put yanked text before cursor" },
  { "gp",        "<Plug>(YankyGPutAfter)",                                                     mode = { "n", "x" },                                desc = "Put yanked text after selection" },
  { "gP",        "<Plug>(YankyGPutBefore)",                                                    mode = { "n", "x" },                                desc = "Put yanked text before selection" },
  { "<c-p>",     "<Plug>(YankyPreviousEntry)",                                                 desc = "Select previous entry through yank history" },
  { "<c-n>",     "<Plug>(YankyNextEntry)",                                                     desc = "Select next entry through yank history" },
  { "]p",        "<Plug>(YankyPutIndentAfterLinewise)",                                        desc = "Put indented after cursor (linewise)" },
  { "[p",        "<Plug>(YankyPutIndentBeforeLinewise)",                                       desc = "Put indented before cursor (linewise)" },
  { "]P",        "<Plug>(YankyPutIndentAfterLinewise)",                                        desc = "Put indented after cursor (linewise)" },
  { "[P",        "<Plug>(YankyPutIndentBeforeLinewise)",                                       desc = "Put indented before cursor (linewise)" },
  { ">p",        "<Plug>(YankyPutIndentAfterShiftRight)",                                      desc = "Put and indent right" },
  { "<p",        "<Plug>(YankyPutIndentAfterShiftLeft)",                                       desc = "Put and indent left" },
  { ">P",        "<Plug>(YankyPutIndentBeforeShiftRight)",                                     desc = "Put before and indent right" },
  { "<P",        "<Plug>(YankyPutIndentBeforeShiftLeft)",                                      desc = "Put before and indent left" },
  { "=p",        "<Plug>(YankyPutAfterFilter)",                                                desc = "Put after applying a filter" },
  { "=P",        "<Plug>(YankyPutBeforeFilter)",                                               desc = "Put before applying a filter" },
  { "P",         function() require("yanky.textobj").last_put() end,                           mode = { "o", "x" },                                desc = "Last put text obj" },
}

return M
