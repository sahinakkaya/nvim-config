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
  },
})
-- Lua
-- vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
-- vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
-- vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
-- vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

vim.keymap.set("n", "x", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
vim.keymap.set("n", "xx", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
vim.keymap.set("n", "X", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
vim.keymap.set("x", "x", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
