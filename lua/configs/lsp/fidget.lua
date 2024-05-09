local fidget = require("fidget")
fidget.setup({
  progress = {
    display = {
      overrides = {
        rust_analyzer = { name = "rust-analyzer" },
        lua_ls = { name = "lua-ls" },
      },
    },
  },
  notification = {
    override_vim_notify = false,

    window = {
      align = "top",           -- How to align the notification window
    }
  }
})
