return {
  {
    "MunsMan/kitty-navigator.nvim",
    build = function()
      vim.fn.system("cp navigate_kitty.py ~/.config/kitty")
      vim.fn.system("cp pass_keys.py ~/.config/kitty")
    end,
    keys = {
      { "<C-h>", function() require("kitty-navigator").navigateLeft() end,  desc = "Move left a Split",  mode = { "n" } },
      { "<C-j>", function() require("kitty-navigator").navigateDown() end,  desc = "Move down a Split",  mode = { "n" } },
      { "<C-k>", function() require("kitty-navigator").navigateUp() end,    desc = "Move up a Split",    mode = { "n" } },
      { "<C-l>", function() require("kitty-navigator").navigateRight() end, desc = "Move right a Split", mode = { "n" } }
    }
  },
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^4.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require('configs.util.kitty-scrolback')
    end,
  },

  { "mbbill/undotree",         cmd = { "UndotreeToggle", "UndotreeShow" } },
  {
    "tris203/hawtkeys.nvim",
    cmd = { "Hawtkeys", "HawtkeysAll", "HawtkeysDupes" },
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


}
