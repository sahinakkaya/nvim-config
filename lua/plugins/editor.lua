local keys = require("configs.keys")
return {
  "folke/neodev.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    keys = keys.comment,
    config = function()
      require("configs.editor.comment")
    end,
  },
  -- {
  --   -- https://github.com/machakann/vim-sandwich/issues/115#issuecomment-940869113
  --   "machakann/vim-sandwich",
  --   keys = {
  --     {"ds"},
  --     {"ys"},
  --     {"yS"},
  --     {"cs"},
  --     {"S", mode="v"},
  --   },
  --   config = function()
  --     vim.api.nvim_command("runtime macros/sandwich/keymap/surround.vim")
  -- vim.keymap.set('x', 'is', '<Plug>(textobj-sandwich-query-i)')
  -- vim.keymap.set('x', 'as', '<Plug>(textobj-sandwich-query-a)')
  -- vim.keymap.set('o', 'is', '<Plug>(textobj-sandwich-query-i)')
  -- vim.keymap.set('o', 'as', '<Plug>(textobj-sandwich-query-a)')
  --
  --   end,
  -- },


  -- Add/change/delete surrounding delimiter pairs with ease. Written with ❤️ in Lua.
  -- ✨ Features
  --     Add/delete/change surrounding pairs
  --         Function calls and HTML tags out-of-the-box
  --     Dot-repeat previous actions
  --     Set buffer-local mappings and surrounds
  --     Jump to the nearest surrounding pair for modification
  --     Use a single character as an alias for several text-objects
  --         E.g. q is aliased to `,',", so csqb replaces the nearest set of quotes with parentheses
  --     Surround using powerful pairs that depend on user input
  --     Modify custom surrounds
  --         First-class support for Vim motions, Lua patterns, and Tree-sitter nodes
  --     Highlight selections for visual feedback
  {
    "kylechui/nvim-surround",
    keys = keys.nvim_surround,
    opts = {}
  },
  -- {
  --   "windwp/nvim-autopairs",
  --   config = function()
  --     require("configs.editor.autopairs")
  --
  --   end,
  --   event = "InsertEnter",
  -- },
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6', --recomended as each new version will have breaking changes
    opts = {
      --Config goes here
    },
  },
  {
    "gbprod/substitute.nvim",
    keys = keys.substitute,
    config = function()
      require("configs.editor.substitute")
    end,
  },
  {
    "monaqa/dial.nvim",
    keys = keys.dial,
    config = function()
      require("configs.editor.dial")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "chrisgrieser/nvim-various-textobjs",
      "RRethy/nvim-treesitter-textsubjects",
      {
        "windwp/nvim-ts-autotag",
        config = function()
          require("nvim-ts-autotag").setup()
        end,
      }
    },
    config = function()
      require("configs.editor.treesitter")
    end

  },
  {
    "gbprod/yanky.nvim",
    -- dependencies = {
    --   { "kkharji/sqlite.lua" }
    -- },
    opts = {
      ring = { storage = "memory" },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 300,
      },
      textobj = {
        enabled = true,
      },
    },
    keys = keys.yanky,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = keys.harpoon,
    config = function()
      require("configs.editor.harpoon")
    end,
    dependencies = { { "nvim-lua/plenary.nvim" } }
  },
  {
    'nvim-pack/nvim-spectre',
    cmd = "Spectre",
    keys = keys.spectre
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    -- Author's Note: If default keymappings fail to register (possible config issue in my local setup),
    -- verify lazy loading functionality. On failure, disable lazy load and report issue
    -- lazy = false,
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga",
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
    },
  },
  { "tpope/vim-fugitive", cmd = { "G", "Git", "Gedit", "Gsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GRename", "GDelete", "GBrowse" } },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
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
    end,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'pbogut/vim-dadbod-ssh',                lazy = true,                      commit = "e4fbabb21a3d737510193c3d9f124a566e7f5910" },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      --
      vim.g.dbs = {
        -- dev= 'postgres://postgres:mypassword@localhost:5432/my-dev-db',
        -- staging= 'postgres://postgres:mypassword@localhost:5432/my-staging-db',
        -- wp= 'mysql://root@localhost/wp_awesome',
        --
        ["ehane-local"] = 'postgresql://admin:admin@postgres.development.orb.local:5432/ehane-local',
      }
      vim.g.db_ui_table_helpers = {
        postgresql = {
          Count = 'select count(*) from "{table}"'
        }
      }
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_auto_execute_table_helpers = 0
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    config = function()
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
    end,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", 'theHamsta/nvim-dap-virtual-text' }
  },
  {
    "mfussenegger/nvim-dap-python",
    keys = { "<leader>ds", "<leader>dt" },
    lazy = false,
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup("~/.local/share/nvim/mason/bin/debugpy")
    end,
  },

  {
    "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    lazy = false,
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", mode = { "n", "v" } },
    },
    config = function()
      vim.cmd([[
      " Start interactive EasyAlign in visual mode (e.g. vipga)
      xmap ga <Plug>(EasyAlign)

      " Start interactive EasyAlign for a motion/text object (e.g. gaip)
      nmap ga <Plug>(EasyAlign)
      ]])
    end,
  }
  -- { "wellle/targets.vim", lazy=false }, aa -> around argument. i already have this with tree sitter. need to check later


  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "mfussenegger/nvim-dap",
  --   }
  -- }
}
