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
    {"tpope/vim-fugitive", cmd={"G", "Git", "Gedit", "Gsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GRename", "GDelete", "GBrowse" }}
  }
}
