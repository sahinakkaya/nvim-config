local opts = { noremap = true, silent = true }
vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', opts)
vim.api.nvim_buf_set_keymap(0, 'n', 'K', ':q<CR>', opts)
