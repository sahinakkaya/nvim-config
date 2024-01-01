-- vim:fileencoding=utf-8:foldmethod=marker


vim.g.transparent_enabled = false
local fn = vim.fn
local home = os.getenv('HOME')
local config = home .. '/.config/'
local data = home .. '/.local/share/'
local nconf = fn.stdpath("config")

-- Options {{{
local options = {
  backup = true, -- creates a backup file
  backupdir = home .. '/.cache/nvim/backup',
  background = 'dark',

  undofile = true,      -- enable persistent undo
  swapfile = false,     -- creates a swapfile
  writebackup = false,  -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  termguicolors = true, -- set term gui colors (most terminals support this)
  mousemoveevent = true,

  spell = false,
  spelllang = 'en,tr',
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 2,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 1,                        -- default 0, so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  pumblend = 0,                            -- pop up menu transparency
  -- winblend = 10,
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  -- smartindent = true,                      -- make indenting smarter again
  splitbelow = false,                       -- force all horizontal splits to go below current window
  splitright = false,                       -- force all vertical splits to go to the right of current window
  timeoutlen = 500,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  updatetime = 300,                        -- faster completion (4000ms default)
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  cursorline = false,                      -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = true,                   -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = true,                             -- display lines in multiple lines
  scrolloff = 999,                         -- show at least n number of lines before after cursor
  sidescrolloff = 6,
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  foldmethod = "expr",
  foldlevelstart = 4,
  foldenable = false,
  foldexpr = "nvim_treesitter#foldexpr()",

  virtualedit = "block",
  inccommand = "split"

  -- foldclose = 'all',
  -- foldopen = 'all',

  -- mousescroll = "ver:1,hor:6"
}

vim.opt.shortmess:append "c"
vim.opt.whichwrap:append "<,>,[,]"
vim.opt.iskeyword:append "-"

for k, v in pairs(options) do
  vim.opt[k] = v
end


for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
  vim.opt.path:append(path .. '/lua')
end

-- vim.api.cmd('set formatoptions-=cro') -- TODO: this doesn't seem to work
--: }}}

-- {{{ Keymaps
local opts = { noremap = true, silent = true }

-- local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

keymap("n", vim.g.maplocalleader, "<cmd>lua require'which-key'.show('\\\\', {mode='n'})<cr>", opts)
keymap("n", "<C-s>", ":w | echo 'do not forget to remove me' | luafile %<CR>", opts)
-- keymap("n", ";", ":", {noremap=true})
-- keymap("n", ":", ";", {noremap=true})
-- keymap("v", ";", ":", {noremap=true})
-- keymap("v", ":", ";", {noremap=true})

keymap("n", "<leader>;", ":", {noremap=true})
keymap("v", "<leader>;", ":", {noremap=true})

-- Increment/decrement
keymap('n', '+', '<C-a>', opts)
keymap('n', '-', '<C-x>', opts)


-- Select all
keymap('n', '<C-a>', 'ggVG', opts)
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Go to the repo under cursor
-- Ex: press gr -> "sahinakkayadev/dotfiles"
-- for complete urls, press gx.
keymap("n", "gr",
  ':let url = "https://github.com/" . split(expand("<cWORD>"), "\\"")[0]  | exe "silent! ! xdg-open " . url | echo "Visit repo: " . url <CR>',
  opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)


-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
keymap('n', 'j', '(v:count == 0 ? "gj" : "j")',
  { noremap = true, expr = true, silent = true })
keymap('n', 'k', '(v:count == 0 ? "gk" : "k")',
  { noremap = true, expr = true, silent = true })


-- noremap gf :call CreateFile(expand("<cfile>"))<CR>
-- function! CreateFile(tfilename)
--
--     " complete filepath from the file where this is called
--     let newfilepath=expand('%:p:h') .'/'. expand(a:tfilename)
--
--     if filereadable(newfilepath)
--        echo "File already exists"
--        :norm gf
--     else
--         :execute "!touch ". expand(newfilepath)
--         echom "File created: ". expand(newfilepath)
--         :norm gf
--     endif
--
-- endfunction




-- Navigate buffers
keymap("n", "<Right>", ":bnext<CR>", opts)
keymap("n", "<Left>", ":bprevious<CR>", opts)


-- Insert --
keymap("i", "jk", "<ESC>", opts)
keymap("i", "JK", "<ESC>", opts)
-- keymap("i", "<ESC>", "<NOP>", opts) -- disable esc to get used to above mappings


-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)


-- Maintain the cursor position when yanking a visual selection
-- http://ddrscott.github.io/blog/2016/yank-without-jank/
keymap("v", 'y', 'myy`y', opts)
keymap("v", 'Y', 'myY`y', opts)

-- make . to work with visually selected lines
keymap("v", '.', ':normal . <CR>', opts)

-- if something is selected, delete it before pasting
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Example keybindings
keymap('n', '<A-n>', ':lua require("FTerm").toggle()<CR>', opts)
keymap('t', '<A-n>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', opts)


-- insert mode mappings
keymap("i", '<C-a>', '<C-o>^', opts)
keymap("i", '<C-e>', '<C-o>$', opts)
keymap("i", '<C-f>', '<C-o>w', opts)
keymap("i", '<C-b>', '<C-o>b', opts)
keymap("i", '<C-k>', '<C-o>d$', opts)
keymap("i", '<C-u>', '<C-o>d^', opts)
keymap("i", '<C-s>', '<c-g>u<Esc>[s1z=`]a<c-g>u', opts)

--: }}}

-- {{{ Autocommands
local M = {}
M.autocmds = {}


M.autocmds.general_settings = {
  { "FileType", "qf,help,man,lspinfo,fugitive,notify,checkhealth", "nnoremap <silent> <buffer> q :close<CR> " },
  -- {
  --   "TextYankPost",
  --   "*",
  --   "silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) ",
  --
  -- },-- flash what is yanked
}
M.autocmds.last_location = {
  {
    "BufReadPost",
    "*",
    callback = function()
      if fn.line("'\"") > 0 and fn.line("'\"") <= fn.line("$") then
        fn.setpos('.', fn.getpos("'\""))
        vim.api.nvim_feedkeys('zz', 'n', true)
      end
    end
  }, -- start where you left off
}

M.autocmds.auto_reload_config = { -- reload programs when their config changes
  { "BufWritePost", config .. "kitty/kitty.conf", "silent !kill -SIGUSR1 $(pgrep kitty)" },
  { "BufWritePost", config .. "tmux/tmux.conf",   "silent !tmux source-file ~/.config/tmux/tmux.conf" },
}


M.autocmds.filetype_specific = {
  {
    "FileType",
    "gitcommit,markdown,plaintex,text",
    "setlocal wrap | setlocal spell",
  },

  { "BufReadPost", "*.wiki", "set filetype=vimwiki" },
}


M.autocmds.cursorline = {
  { { "VimEnter", "WinEnter", "BufWinEnter", "BufEnter" }, "*", "setlocal cursorline" },
  { { "VimLeave", "WinLeave", "BufWinLeave", "BufLeave" }, "*", "setlocal nocursorline" },

  -- {"InsertLeave", "*", "highlight CursorLine guibg=#c4c8da"},
  -- {"InsertEnter", "*", "highlight CursorLine guibg=none"},
}

-- creates group if not exists, deletes group if it exists
function M.toggle_group(group_name, notify)
  local exists, autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group_name
  })
  if not exists or #autocmds == 0 then
    if notify then
      vim.notify(string.format("Group %s doesn't exist. Creating...", group_name))
    end
    local id = vim.api.nvim_create_augroup(group_name, {})
    for _, autocmd in pairs(M.autocmds[group_name]) do
      local event, pattern, command, callback = autocmd[1], autocmd[2], autocmd[3], autocmd.callback
      if callback == nil then
        vim.api.nvim_create_autocmd(event, { group = id, pattern = pattern, command = command })
      else
        vim.api.nvim_create_autocmd(event, { group = id, pattern = pattern, callback = callback })
      end
    end
  else
    if notify then
      vim.notify(string.format("Group %s exist. Deleting...", group_name))
    end
    vim.api.nvim_clear_autocmds({ group = group_name })
  end
end

function M.define_augroups(definitions)
  for group_name, _ in pairs(definitions) do
    M.toggle_group(group_name, false)
  end
end

M.define_augroups(M.autocmds)

-- }}}



local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    { import = "plugins" },
  },
  {
    defaults = {
      lazy = true,
    },
    install = {
      colorscheme = {"kanagawa", "tokyonight", "habamax" },
    },

    performance = {
      cache = {
        enabled = true,
      },
      reset_packpath = true,
      rtp = {
        reset = true,
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
          "man",
          "shada",
          "osc52",
        },
      },
    },
  })


