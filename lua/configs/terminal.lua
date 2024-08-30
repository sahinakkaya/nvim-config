M = {}
M.setup = function()
  require("toggleterm").setup{
    -- size can be a number or function which is passed the current terminal
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<M-CR>]],
    -- on_create = fun(t: Terminal), -- function to run when the terminal is first created
    -- on_open = fun(t: Terminal), -- function to run when the terminal opens
    -- on_close = fun(t: Terminal), -- function to run when the terminal closes
    -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
    -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
    -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    -- highlights = {
    --   -- highlights which map to a highlight group name and a table of it's values
    --   -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    --   Normal = {
    --     guibg = "<VALUE-HERE>",
    --   },
    --   NormalFloat = {
    --     link = 'Normal'
    --   },
    --   FloatBorder = {
    --     guifg = "<VALUE-HERE>",
    --     guibg = "<VALUE-HERE>",
    --   },
    -- },
    shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
    shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
    direction = --[[ 'vertical' | 'horizontal' | 'tab' | ]] 'float',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    auto_scroll = true, -- automatically scroll to the bottom on terminal output
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
      -- The border key is *almost* the same as 'nvim_open_win'
      -- see :h nvim_open_win for details on borders however
      -- the 'curved' border is a custom border type
      -- not natively supported but implemented in this plugin.
      border = --[[ 'single' | 'double' | 'shadow' | ]] 'curved', --[[ | ... other options supported by win open ]]
      -- like `size`, width and height can be a number or function which is passed the current terminal
      -- width = <value>,
      -- height = <value>,
      winblend = 0,

      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
    winbar = {
      enabled = false,
      name_formatter = function(term) --  term: Terminal
        return term.name
      end
    },
  }
  M.bind_keymaps()
end

--- Get current buffer size
---@return {width: number, height: number}
local function get_buf_size()
  local cbuf = vim.api.nvim_get_current_buf()
  local bufinfo = vim.tbl_filter(function(buf)
    return buf.bufnr == cbuf
  end, vim.fn.getwininfo(vim.api.nvim_get_current_win()))[1]
  if bufinfo == nil then
    return { width = -1, height = -1 }
  end
  return { width = bufinfo.width, height = bufinfo.height }
end

--- Get the dynamic terminal size in cells
---@param direction number
---@param size integer
---@return integer
local function get_dynamic_terminal_size(direction, size)
  size = size or 20
  if direction ~= "float" and tostring(size):find(".", 1, true) then
    size = math.min(size, 1.0)
    local buf_sizes = get_buf_size()
    local buf_size = direction == "horizontal" and buf_sizes.height or buf_sizes.width
    return buf_size * size
  else
    return size
  end
end


M.bind_keymaps = function()
  local keymaps = {
    { vim.o.shell, "<M-j>", "Horizontal Terminal", "horizontal", 0.3 },
    { vim.o.shell, "<M-h>", "Vertical Terminal", "vertical", 0.3 },
    { vim.o.shell, "<M-l>", "Vertical Terminal", "vertical", 0.3 },
    { vim.o.shell, "<M-f>", "Float Terminal", "float", nil },
  }
  for i, mapping in pairs(keymaps) do
    local opts = {
      cmd = mapping[1],
      keymap = mapping[2],
      label = mapping[3],
      direction = mapping[4],
      count = i + 100, -- NOTE: unable to consistently bind id/count <= 9, see #2146
      size = function()
        return get_dynamic_terminal_size(mapping[4], mapping[5])
      end,
    }

    M.add_exec(opts)
  end

  -- local opts = { noremap = true, silent = true }
  local opts = { noremap = true, silent = true }
  local term_mode_mappings = {
    -- Terminal window navigation
    ["<C-h>"] = "<Cmd>wincmd h<CR>",
    ["<C-j>"] = "<Cmd>wincmd j<CR>",
    ["<C-k>"] = "<Cmd>wincmd k<CR>",
    ["<C-l>"] = "<Cmd>wincmd l<CR>",
  }
  for k, v in pairs(term_mode_mappings) do
    local set_keymap = vim.api.nvim_set_keymap
    set_keymap('t', k, v, opts)
  end



end

M.add_exec = function(opts)
  local binary = opts.cmd:match "(%S+)"
  if vim.fn.executable(binary) ~= 1 then
    print("Skipping configuring executable " .. binary .. ". Please make sure it is installed properly.")
    return
  end

  vim.keymap.set({ "n", "t" }, opts.keymap, function()
    M._exec_toggle { cmd = opts.cmd, count = opts.count, direction = opts.direction, size = opts.size() }
  end, { desc = opts.label, noremap = true, silent = true })
end

M._exec_toggle = function(opts)
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new { cmd = opts.cmd, count = opts.count, direction = opts.direction }
  term:toggle(opts.size, opts.direction)
end

M.lazygit_toggle = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 100000,
      height = 100000,
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = 99,
  }
  lazygit:toggle()
end

return M
