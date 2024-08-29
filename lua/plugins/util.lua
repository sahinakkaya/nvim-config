local keys = require("configs.keys")
return {
  {
    -- "christoomey/vim-tmux-navigator", -- i quit using tmux, kitty ftw!
    -- 'knubie/vim-kitty-navigator',
    "mrjones2014/smart-splits.nvim",
    keys = keys.smartsplits,
    build = './kitty/install-kittens.bash',
    -- config = function()
    --   -- vim.g.tmux_navigator_disable_when_zoomed = 1
    --   -- vim.g.tmux_navigator_no_wrap = 1
    -- end,
    opts = {
      cursor_follows_swapped_bufs = true,
    }
  },

  { "mbbill/undotree", cmd = { "UndotreeToggle", "UndotreeShow" } },
  {
    "tris203/hawtkeys.nvim",
    cmd = {"Hawtkeys","HawtkeysAll", "HawtkeysDupes" },
    config = true,
  },
  {
    "tpope/vim-abolish",
    event = "InsertEnter",
    config = function()
      vim.cmd("Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}")
      vim.cmd 'Abolish cosnt const'
      vim.cmd 'Abolish conts const'
      vim.cmd 'Abolish reutrn return'
      vim.cmd 'Abolish reutnr return'
      vim.cmd 'Abolish retunr return'
      vim.cmd 'Abolish retrun return'
      vim.cmd 'Abolish improt import'
      vim.cmd 'Abolish ipmort import'
      vim.cmd 'Abolish impotr import'
      vim.cmd 'Abolish iopmrt import'
      vim.cmd 'Abolish iomprt import'
    end
  },
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^3.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("configs.util.kitty-scrolback")
    end,
  }

}
