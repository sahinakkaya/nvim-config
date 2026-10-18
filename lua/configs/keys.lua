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

M.grug_far = {
  {
    "<leader>rr",
    function()
      require("grug-far").toggle_instance({
        instanceName = "find-and-replace",
        staticTitle = "Find and Replace",
      })
    end,
    desc = "Toggle find and replace",
  },
  {
    "<leader>rw",
    function()
      require("grug-far").open({
        prefills = { search = vim.fn.expand("<cword>") },
      })
    end,
    desc = "Current word",
  },
  {
    "<leader>rw",
    function()
      require("grug-far").open()
    end,
    mode = "x",
    desc = "Visual selection",
  },
  {
    "<leader>rf",
    function()
      local path = vim.fn.expand("%")
      if path == "" then
        vim.notify("Current buffer has no file path", vim.log.levels.WARN)
        return
      end

      require("grug-far").open({
        prefills = { paths = path },
      })
    end,
    mode = { "n", "x" },
    desc = "Current file",
  },
  {
    "<leader>ri",
    function()
      require("grug-far").open({
        visualSelectionUsage = "auto-detect",
      })
    end,
    mode = "x",
    desc = "Within selected range",
  },
  {
    "<leader>rs",
    function()
      local search = vim.fn.getreg("/")
      if search ~= "" and vim.startswith(search, "\\<") and vim.endswith(search, "\\>") then
        search = "\\b" .. search:sub(3, -3) .. "\\b"
      elseif search ~= "" and vim.startswith(search, "\\V") then
        search = search:sub(3)
      end

      local instance = require("grug-far").open({
        prefills = { search = search },
      })
      instance:when_ready(function()
        instance:goto_input("replacement")
      end)
    end,
    mode = { "n", "x" },
    desc = "Last search or selection",
  },
  {
    "<leader>rh",
    function()
      local grug = require("grug-far")
      local entry = grug.get_last_history_entry()
      local options = {}

      if entry then
        options.prefills = entry
        options.engine = entry.engine
        options.replacementInterpreter = entry.replacementInterpreter
      end

      grug.open(options)
    end,
    mode = { "n", "x" },
    desc = "Last history entry",
  },
  {
    "<leader>ra",
    function()
      require("grug-far").open({ engine = "astgrep" })
    end,
    mode = { "n", "x" },
    desc = "AST-grep",
  },
  {
    "<leader>rt",
    function()
      require("grug-far").open({ transient = true })
    end,
    mode = { "n", "x" },
    desc = "Transient search",
  },
}

M.nvim_dap_python = { "<leader>ds", "<leader>dt" }

M.vim_easy_align = {
  { "ga", mode = { "n", "v" } },
}


M.text_case = {
  "ga",
  { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
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

M.harpoon = { "<Up>", "<Down>", "<leader>j", "<leader>a" }

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
