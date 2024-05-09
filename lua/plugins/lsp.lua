return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    cmd="Mason",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      {
        'stevearc/dressing.nvim',
        opts = {},
      }
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      require("configs.lsp.lspconfig")
    end,

  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft={"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"},
    config = function ()
      require('configs.lsp.typescript-tools')
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("configs.lsp.trouble")
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require('configs.lsp.refactoring')
    end,
  },


}
