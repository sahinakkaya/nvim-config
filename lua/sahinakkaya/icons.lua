local Icons = {}

local icons = { -- keeping these just in case. stolen from trouble
  folder_closed = " ",
  folder_open   = " ",
}

Icons.kinds = {
  -- Method = " ",
  Method        = "󰡱 ",
  Function      = "󰊕 ",
  -- Constructor = " ",
  Constructor   = " ",
  -- Field         = " ",
  Field         = " ",
  -- Variable      = " ",
  Variable      = "󰀫 ",
  Class         = " ",
  -- Property      = " ",
  Property      = " ",
  -- Interface     = " ",
  Interface     = " ",
  -- Enum          = " ",
  -- EnumMember    = " ",
  Enum          = " ",
  EnumMember    = " ",
  Reference     = " ",
  Struct        = " ",
  -- Struct        = "󰆼 ",
  -- Event         = " ",
  Event         = " ",
  Constant      = "󰏿 ",
  Keyword       = " ",

  -- Module        = "󰏗 ",
  Module        = " ",
  -- Package       = "󰏗 ",
  Package       = " ",
  -- Namespace     = "󰅩 ",
  Namespace     = "󰦮 ",

  Unit          = " ",
  Value         = "󰎠 ",
  -- String        = " ",
  String        = " ",
  Number        = "󰎠 ",
  -- Number        = "󰎠 ",
  -- Boolean       = " ",
  Boolean       = "󰨙 ",
  Array         = " ",
  Object        = " ",
  -- Key           = "󱕵 ",
  Key           = " ",
  Null          = " ",
  -- Null          = " ",

  Text          = " ",
  -- Snippet       = " ",
  Snippet = "",
  Color         = "󰏘 ",
  File          = "󰈮 ",
  Folder        = "󰉋 ",
  -- File          = " ",
  Operator      = " ",
  -- Operator      = " ",
  TypeParameter = " ",
  -- TypeParameter = " ",
  Copilot       = " ",
  Cody          = " ",
}

Icons.sources = {
  path = "",
  buffer = "",
  luasnip = "󱐌",
  latex_symbols = "",
  nvim_lua = "",
  nvim_lsp = ""
}

Icons.diagnostics = {
  errors = "󰞏", --
  warnings = "", -- "",--
  hints = "󱐌", --"󰮔", -- 󱐌
  info = "",
}
Icons.diagnostics.Error = Icons.diagnostics.errors
Icons.diagnostics.Warn = Icons.diagnostics.warnings
Icons.diagnostics.Hint = Icons.diagnostics.hints
Icons.diagnostics.Info = Icons.diagnostics.info

Icons.lsp = {
  action_hint = "",
}

Icons.git = {
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
}

Icons.dap = {
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

Icons.actions = {
  close_hexagon = "󰅜",
  close_round = "󰅙",
  close_outline = "󰅚",
  close = "󰅖",
  close_box = "󰅗",
}

Icons.menu = {
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

Icons.fold = {
  open = "",
  closed = "",
  fold_closed = " ",
  fold_open   = " ",
}

Icons.separators = {
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

Icons.blocks = {
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

Icons.misc = {
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

return Icons
