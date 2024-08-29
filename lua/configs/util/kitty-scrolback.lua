require('kitty-scrollback').setup({
  {
    paste_window = { yank_register = 'a' },
  },

  callbacks = function()
    vim.keymap.set('n', '<C-a>', 'ggVG', {})
    vim.keymap.set({ 'n' }, 'q', '<Plug>(KsbCloseOrQuitAll)', {})
    vim.keymap.set({ 'n', 't', 'i' }, 'ZZ', '<Plug>(KsbQuitAll)', {})

    vim.keymap.set({ 'n' }, '<tab>', '<Plug>(KsbToggleFooter)', {})
    -- vim.keymap.set({ 'n', 'i' }, '<cr>', '<Plug>(KsbExecuteCmd)', {})
    -- vim.keymap.set({ 'n', 'i' }, '<c-v>', '<Plug>(KsbPasteCmd)', {})


    vim.keymap.set({ 'v' }, 'Y', '<Plug>(KsbVisualYankLine)', {})
    vim.keymap.set({ 'v' }, 'y', '<Plug>(KsbVisualYank)', {})
    vim.keymap.set({ 'n' }, 'Y', '<Plug>(KsbNormalYankEnd)', {})
    vim.keymap.set({ 'n' }, 'y', '<Plug>(KsbNormalYank)', {})
    vim.keymap.set({ 'n' }, 'yy', '<Plug>(KsbYankLine)', {})

    vim.keymap.set({ 'v' }, '<leader>Y', '"aY', {})
    vim.keymap.set({ 'v' }, '<leader>y', '"ay', {})
    vim.keymap.set({ 'n' }, '<leader>Y', '"ay$', {})
    vim.keymap.set({ 'n' }, '<leader>y', '"ay', {})
    vim.keymap.set({ 'n' }, '<leader>yy', '"ayy', {})
  end,
})
