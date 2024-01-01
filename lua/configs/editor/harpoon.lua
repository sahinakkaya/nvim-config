local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<Up>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<Down>", function() harpoon:list():next() end)
