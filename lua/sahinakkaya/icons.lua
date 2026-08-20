local M             = {}

local icons         = { -- keeping these just in case. stolen from trouble
  folder_closed = " ",
  folder_open   = " ",
}

M.kinds             = {
  Array             = '󰅪 ',
  Boolean           = "󰨙 ",
  -- Boolean       = " ",
  -- Boolean           = ' ',
  BreakStatement    = '󰙧 ',
  Call              = '󰃷 ',
  CaseStatement     = '󱃙 ',
  Class             = " ",
  Cody              = " ",
  Color             = "󰏘 ",
  Constant          = "󰏿 ",
  -- Constructor       = " ",
  -- Constructor = " ",
  Constructor       = ' ',
  ContinueStatement = '→ ',
  Copilot           = ' ',
  Declaration       = '󰙠 ',
  Delete            = '󰩺 ',
  DoStatement       = '󰑖 ',
  -- Enum              = " ",
  -- Enum          = " ",
  Enum              = ' ',
  -- EnumMember        = " ",
  -- EnumMember    = " ",
  EnumMember        = ' ',
  -- Event             = " ",
  Event             = ' ',
  -- Event         = " ",
  -- Field         = " ",
  -- Field             = " ",
  Field             = ' ',
  -- File              = "󰈮 ",
  -- File          = " ",
  File              = '󰈔 ',
  Folder            = '󰉋 ',
  ForStatement      = '󰑖 ',
  Function          = '󰊕 ',
  H1Marker          = '󰉫 ', -- Used by markdown treesitter parser
  H2Marker          = '󰉬 ',
  H3Marker          = '󰉭 ',
  H4Marker          = '󰉮 ',
  H5Marker          = '󰉯 ',
  H6Marker          = '󰉰 ',
  Identifier        = '󰀫 ',
  IfStatement       = '󰇉 ',
  -- Interface         = " ",
  Interface         = ' ',
  -- Interface     = " ",
  -- Key           = "󱕵 ",
  Key               = " ",
  Keyword           = " ",
  Keyword           = '󰌋 ',
  List              = '󰅪 ',
  Log               = '󰦪 ',
  Lsp               = ' ',
  Macro             = '󰁌 ',
  MarkdownH1        = '󰉫 ', -- Used by builtin markdown source
  MarkdownH2        = '󰉬 ',
  MarkdownH3        = '󰉭 ',
  MarkdownH4        = '󰉮 ',
  MarkdownH5        = '󰉯 ',
  MarkdownH6        = '󰉰 ',
  Method            = "󰡱 ",
  -- Method            = '󰆧 ',
  -- Method = " ",
  -- Module        = "󰏗 ",
  Module            = " ",
  -- Module            = '󰏗 ',
  -- Namespace         = "󰦮 ",
  Namespace         = '󰅩 ',
  -- Namespace     = "󰅩 ",
  -- Null          = " ",
  -- Null              = " ",
  Null              = '󰢤 ',
  Number            = '󰎠 ',
  -- Object            = " ",
  Object            = '󰅩 ',
  Operator          = '󰆕 ',
  -- Operator      = " ",
  -- Package       = "󰏗 ",
  Package           = " ",
  -- Package           = '󰆦 ',
  Pair              = '󰅪 ',
  Property          = ' ',
  -- Property      = " ",
  Reference         = " ",
  -- Reference         = '󰦾 ',
  Regex             = ' ',
  Repeat            = '󰑖 ',
  Scope             = '󰅩 ',
  Snippet           = "",
  -- Snippet       = " ",
  -- Snippet           = '󰩫 ',
  Specifier         = '󰦪 ',
  Statement         = '󰅩 ',
  -- String            = '󰉾 ',
  String            = " ",
  -- String        = " ",
  -- Struct        = "󰆼 ",
  -- Struct            = " ",
  Struct            = ' ',
  SwitchStatement   = '󰺟 ',
  Terminal          = ' ',
  -- Text              = " ",
  Text              = ' ',
  Type              = ' ',
  TypeParameter     = " ",
  -- TypeParameter = " ",
  -- TypeParameter     = '󰆩 ',
  Unit              = ' ',
  Value             = '󰎠 ',
  Variable          = '󰀫 ',
  -- Variable      = " ",
  WhileStatement    = '󰑖 ',
}

M.sources           = {
  path = "",
  buffer = "",
  luasnip = "󱐌",
  latex_symbols = "",
  nvim_lua = "",
  nvim_lsp = "",
  cmdline = ""
}

M.diagnostics       = {
  -- errors = "", --
  -- warnings = "", -- "",--
  -- hints = "󱐌", --"󰮔", -- 󱐌
  -- info = "",

  -- errors = '󰅚 ', -- x000f015a
  -- warnings = '󰀪 ', -- x000f002a
  -- info = '󰋽 ', -- x000f02fd
  -- hints = '󰌶 ', -- x000f0336


  errors = " ",
  warnings = " ",
  info = " ",
  hints = "󰌵",

  BoldError = "",
  Error = "",
  BoldWarning = "",
  Warning = "",
  BoldInformation = "",
  Information = "",
  BoldQuestion = "",
  Question = "",
  BoldHint = "",
  Hint = "",
  Debug = "",
  Trace = "✎",
}
M.diagnostics.Error = M.diagnostics.errors
M.diagnostics.Warn  = M.diagnostics.warnings
M.diagnostics.Hint  = M.diagnostics.hints
M.diagnostics.Info  = M.diagnostics.info

M.lsp               = {
  action_hint = "",
}

M.git               = {
  diff = {
    added = "",
    modified = "󰆗",
    removed = "",
  },
  signs = {
    bar = "┃",
    untracked = "•",
  },
  branch = "",
  copilot = "",
  copilot_err = "",
  copilot_warn = "",

  LineAdded = "",
  LineModified = "",
  LineRemoved = "",
  File = {
    Added     = "✚",
    Deleted   = "✖",
    Modified  = "",
    Renamed   = "󰁕",
    -- Status type
    -- Untracked = "",
    Untracked = "?",
    Ignored   = "",
    Unstaged  = "󰄱",
    Staged    = "",
    Conflict  = "",
  },
  FileDeleted = "",
  FileIgnored = "◌",
  FileRenamed = "➜",
  FileStaged = "S",
  FileUnmerged = "",
  FileUnstaged = "",
  FileUntracked = "U",
  Diff = "",
  Repo = "",
  Octoface = "",
  Branch = "",
}

M.dap               = {
  breakpoint = {
    conditional = "",
    data = "",
    func = "",
    log = "",
    unsupported = "",
  },
  action = {
    continue = "",
    coverage = "",
    disconnect = "",
    line_by_line = "",
    pause = "",
    rerun = "",
    restart = "",
    restart_frame = "",
    reverse_continue = "",
    start = "",
    step_back = "",
    step_into = "",
    step_out = "",
    step_over = "",
    stop = "",
  },
  stackframe = "",
  stackframe_active = "",
  console = "",
}

M.actions           = {
  close_hexagon = "󰅜",
  close_round = "󰅙",
  close_outline = "󰅚",
  close = "󰅖",
  close_box = "󰅗",
}

M.menu              = {
  actions = {
    outline = {
      left = "󰨂",
      right = "󰨃",
      up = "󰚷",
      down = "󰚶",
      swap = "󰩥",
      filter = "󱃦",
    },
    filled = {
      up = "󰍠",
      down = "󰍝",
      left = "󰍞",
      right = "󰍟",
      swap = "󰩤",
      filter = "󱃥",
    },
  },
  hamburger = "󰍜",
  hamburger_open = "󰮫",
}

M.fold              = {
  open        = "",
  closed      = "",
  fold_closed = " ",
  fold_open   = " ",
}

M.separators        = {
  angle_quote = {
    left = "«",
    right = "»",
  },
  chevron = {
    left = "",
    right = "",
    down = "",
  },
  circle = {
    left = "",
    right = "",
  },
  arrow = {
    left = "",
    right = "",
  },
  slant = {
    left = "",
    right = "",
  },
  bar = {
    left = "⎸",
    right = "⎹",
  },
}

M.blocks            = {
  left = {
    "▏",
    "▎",
    "▍",
    "▌",
    "▋",
    "▊",
    "▉",
    "█",
  },
  right = {
    eighth = "▕",
    half = "▐",
    full = "█",
  },
}

M.misc              = {
  datetime = "󱛡 ",
  modified = "●",
  fold = "⮓",
  newline = "",
  circle = "",
  circle_filled = "",
  circle_slash = "",
  ellipse = "…",
  ellipse_dbl = "",
  kebab = "",
  tent = "⛺",
  comma = "󰸣",
  hook = "󰛢",
  hook_disabled = "󰛣",
}

return M
