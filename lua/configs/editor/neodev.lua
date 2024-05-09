  -- 💻 Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API. 
  --
  --
  -- ✨ Features
  --
  --     Automatically configures lua-language-server for your Neovim config, Neovim runtime and plugin directories
  --     Annotations for completion, hover and signatures of:
  --         Vim functions
  --         Neovim api functions
  --         vim.opt
  --         vim.loop
  --     properly configures the require path.
  --     adds all plugins in opt and start to the workspace so you get completion for all installed plugins
  --     properly configure the vim runtime
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
  library = { plugins = { "nvim-dap-ui" }, types = true },
})
