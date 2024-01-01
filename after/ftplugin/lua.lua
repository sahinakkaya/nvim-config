-- Set options to open require with gf
vim.opt_local.include = [=[\v<((do|load)file|require)\s*\(?['"]\zs[^'"]+\ze['"]]=]
vim.opt_local.includeexpr = "v:lua.find_required_path(v:fname)"


local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_buf_set_keymap
keymap(0, 'n', 'gf', ":lua require('sahinakkaya.util').go_to_luafile()<CR>", opts)
