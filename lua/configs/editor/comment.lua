-- 🧠 💪 // Smart and powerful comment plugin for neovim. Supports treesitter, dot repeat, left-right/up-down motions, hooks, and more 
--
require("Comment").setup(
  {
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
  }
)
