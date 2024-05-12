local M = {}

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
    disabledKeymaps = { "gc", "\\", "iq", "aq", "in", "an" },
  }

  vim.keymap.set(
    { "o" },
    "gc",
    "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>"
  )


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

  local function openURL(url)
    local opener
    if vim.fn.has("macunix") == 1 then
      opener = "open"
    elseif vim.fn.has("linux") == 1 then
      opener = "xdg-open"
    elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
      opener = "start"
    end
    local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
    vim.fn.system(openCommand)
  end

  vim.keymap.set("n", "gx", function()
    require("various-textobjs").url()
    local foundURL = vim.fn.mode():find("v")
    if foundURL then
      vim.cmd.normal('"zy')
      local url = vim.fn.getreg("z")
      openURL(url)
    else
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
        if choice then openURL(choice) end
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
  require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      yaml = false,
      markdown = false,
      help = false,
      gitcommit = true,
      gitrebase = true,
      hgcommit = false,
      svn = false,
      cvs = false,
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
  local util = require("configs.lsp.util")
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

M.typescript_tools = function()
  require('configs.lsp.typescript-tools')
end

return M
