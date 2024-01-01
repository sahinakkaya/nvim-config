-- Supercharge your workflow and start tabbing out from parentheses, quotes, and similar contexts today.

return {
  "abecodes/tabout.nvim",
  lazy = true,
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  opts = {
    tabkey = "<Tab>",
    backwards_tabkey = "<S-Tab>",
    act_as_tab = true,
    ignore_beginning = true,
    act_as_shift_tab = false,
    default_tab = "",
    default_shift_tab = "",
  },
}
