local augend = require("dial.augend")

require("dial.config").augends:register_group{
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


    augend.constant.new{
      elements = {'zero','one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten'},
      word = false,
      cyclic = true,
    },

    augend.constant.new{
      elements = {"and", "or"},
      word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
      cyclic = true,  -- "or" is incremented into "and".
    },
    augend.constant.new{
      elements = {"&&", "||"},
      word = false,
      cyclic = true,
    },

    augend.constant.new{
      elements = {'left', 'right', 'top', 'bottom'},
      word = false,
      cyclic = true,
    },

    augend.constant.new{
      elements = {'True', 'False'},
      word = true,
      cyclic = true,
    },

    augend.constant.new{
      elements = {'yes', 'no'},
      word = true,
      cyclic = true,
    },
    augend.constant.new{
      elements = {'enabled', 'disabled'},
      word = true,
      cyclic = true,
    },

    augend.constant.new{
      elements = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'},
      word = true,
      cyclic = true,
    },

    augend.constant.new{
      elements = {
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'},
      word = true,
      cyclic = true,
    },

  },
  typescript = {
    augend.integer.alias.decimal,
    augend.integer.alias.hex,
    augend.constant.new{ elements = {"let", "const"} },
  },

}
--
-- vim.api.nvim_set_keymap("n", "+", require("dial.map").inc_normal(), {noremap = true})
-- vim.api.nvim_set_keymap("n", "-", require("dial.map").dec_normal(), {noremap = true})
-- vim.api.nvim_set_keymap("v", "+", require("dial.map").inc_visual(), {noremap = true})
-- vim.api.nvim_set_keymap("v", "-", require("dial.map").dec_visual(), {noremap = true})
-- vim.api.nvim_set_keymap("v", "g+", require("dial.map").inc_gvisual(), {noremap = true})
-- vim.api.nvim_set_keymap("v", "g-", require("dial.map").dec_gvisual(), {noremap = true})

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
