require("which-key").add({
  {
    "<localleader>",
    group = "Grug Far",
    mode = "n",
    buffer = 0,
  },
})

vim.keymap.set("n", "<leader>rF", function()
  local states = require("grug-far").get_instance(0):toggle_flags({ "--fixed-strings" })
  vim.notify("Fixed strings " .. (states[1] and "enabled" or "disabled"))
end, {
  buffer = true,
  desc = "Toggle fixed strings",
})

vim.keymap.set("n", "<leader>ro", function()
  local instance = require("grug-far").get_instance(0)
  instance:open_location()
  instance:close()
end, {
  buffer = true,
  desc = "Open result and close",
})

vim.keymap.set("n", "<leader>rI", function()
  require("grug-far").get_instance(0):goto_first_input()
end, {
  buffer = true,
  desc = "Go to first input",
})
