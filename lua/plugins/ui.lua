local function get_output(cmd)
  local f = vim.fn.system(cmd)
  return string.lower(f:gsub("%s+", ""))
end

local keys = require('configs.keys')


return {
  {
    "folke/tokyonight.nvim",
    lazy = true, -- make sure we load this during startup if it is your main colorscheme
    -- priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      -- require("plugin_configs.colorscheme")
      vim.o.background = get_output("darkman get")
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      -- require("plugin_configs.colorscheme")
      vim.o.background = get_output("darkman get")
      vim.cmd([[colorscheme kanagawa]])
    end,

  },
  {
    "folke/which-key.nvim",
    keys = keys.which_key,
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    config = function()
      require("configs.ui.whichkey")
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = function()
      require("configs.ui.noice")
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
    }
  },
  --  {
  -- 	"rcarriga/nvim-notify",
  --    event="VeryLazy",
  -- 	config = function()
  -- 		require("configs.ui.notify")
  -- 	end,
  -- },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = function()
      require("configs.lsp.fidget")
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("configs.ui.sidebars")
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    -- config = function ()
    --   require("configs.ui.sidebars")
    -- end
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "mrbjarksen/neo-tree-diagnostics.nvim",
      "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    cmd = "Neotree",
    config = function()
      require("configs.ui.neotree")
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    event = "BufEnter",
    tag = '0.1.5',
    -- or, branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      }
    },
    -- event = "VeryLazy",
    config = function()
      require("configs.ui.telescope")
    end
  },
  { -- there is also integration with rainbow-delimiters. check read me if you want
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = true },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    config = function()
      require("configs.ui.rainbow-delimiters")
    end
  },
  {
    'NvChad/nvim-colorizer.lua',
    ft = { "css", "scss" },
    cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
    config = function()
      require('colorizer').setup()
    end
  },
  {
    "karb94/neoscroll.nvim",
    keys = keys.neoscroll,
    config = function()
      require("neoscroll").setup()
    end
  },
  {
    "m4xshen/smartcolumn.nvim",
    lazy=false,
    opts = {}
  },
}
