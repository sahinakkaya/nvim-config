return {
  {
    "christoomey/vim-tmux-navigator",
    keys = { "<C-l>", "<C-h>", "<C-j>", "<C-k>" },
    config = function()
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_no_wrap = 1
    end,
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
  }

}
