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

M.spectre = {
  {'<leader>rr', '<cmd>lua require("spectre").toggle()<CR>',  desc = "Toggle Spectre"},
  {'<leader>rw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',  desc = "Search current word"},
  {'<leader>rw', '<esc><cmd>lua require("spectre").open_visual()<CR>', mode ="v",  desc = "Search current word"},
  {'<leader>rp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',  desc = "Search on current file"}
}

M.which_key = { {"<Leader>", mode = { "n", "v" }} }
M.vimwiki = { "<Space>ww" }
M.neoscroll = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'}


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
  { "s", mode = { "n", "v" } },
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
  { "lp",        function() require("yanky.textobj").last_put() end,                           mode = { "o", "x" },                                desc = "Last put text obj" },
}

return M
