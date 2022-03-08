local define_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.cmd("augroup " .. group_name)
    vim.cmd [[autocmd!]]

    for _, def in pairs(definition) do
      local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
      vim.cmd(command)
    end

    vim.cmd "augroup END"
  end
end

local autocmds = {}

autocmds._general_settings = {
  {"BufReadPost", '*', 'normal `"'}, -- start where you left off

  {"BufReadPost", "quickfix", "nnoremap <buffer> j j"},
  {"BufReadPost", "quickfix", "nnoremap <buffer> k k"},
  -- safer version but needs investigating
  -- {"BufReadPost", '*', 'if line("\'"") > 0 && line("\'"") <= line("$") | execute "normal! g\'"" | endif'} 

  -- quickfix, help, man, lspinfo -> quit with q
  {"FileType", "qf,help,man,lspinfo", "nnoremap <silent> <buffer> q :close<CR> "},
  -- {"BufWrite,BufEnter,InsertLeave", "*", "vim.diag"},

  -- flash what is yanked
  {
    "TextYankPost", 
    "*", 
    "silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200}) "
  }, 
}

autocmds.packer_user_config= {
  -- reloads neovim whenever you save the plugins.lua file
  {"BufWritePost", "plugins.lua", "source <afile> | PackerSync"}
}

autocmds._toggle_relative_number = {
  {'InsertEnter', '*', ':setlocal norelativenumber'},
  {'InsertLeave', '*', ':setlocal relativenumber'}
}

autocmds._text_doc = {
  {
    "FileType", 
    "gitcommit,markdown,plaintex,text",
    "setlocal wrap | setlocal spell"
  },
}

autocmds.custom = {
  {
    'FileType', 
    'nasm,asm,java', 
    'setlocal | setlocal tabstop=4 | setlocal shiftwidth=4 | setlocal expandtab'
  },

  -- {"FileType", "java", "setlocal shiftwidth=4 softtabstop=4 expandtab"},

  {'BufWinEnter', '~/scripts/*,*.sh', 'if &ft == "" | setlocal ft=sh | endif'},
  {'BufWritePost', '*', 'if &ft == "sh" | silent! execute "!chmod +x %" | endif'}
}

autocmds._auto_resize = {
  -- will cause split windows to be resized evenly if main window is resized
  { "VimResized", "*", "tabdo wincmd =" },
}

autocmds._formatoptions = {
  -- who knows what it does. stole it from lvim :D
  {
    "BufWinEnter,BufRead,BufNewFile",
    "*",
    "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
  },
}

autocmds._cursorline = {
  {'VimEnter,WinEnter,BufWinEnter', '*', 'setlocal cursorline'},
  {'WinLeave', '*', 'setlocal nocursorline'}
}



define_augroups(autocmds)

-- enable transparent mode, from lvim 
-- https://github.com/LunarVim/LunarVim/blob/rolling/lua/lvim/core/autocmds.lua

-- vim.cmd "au ColorScheme * hi Normal ctermbg=none guibg=none"
-- vim.cmd "au ColorScheme * hi SignColumn ctermbg=none guibg=none"
-- vim.cmd "au ColorScheme * hi NormalNC ctermbg=none guibg=none"
-- vim.cmd "au ColorScheme * hi MsgArea ctermbg=none guibg=none"
-- vim.cmd "au ColorScheme * hi TelescopeBorder ctermbg=none guibg=none"
-- vim.cmd "au ColorScheme * hi NvimTreeNormal ctermbg=none guibg=none"
-- vim.cmd "au ColorScheme * hi EndOfBuffer ctermbg=none guibg=none"
-- vim.cmd "let &fcs='eob: '"
vim.cmd [[ 

augroup linea
    autocmd!
    autocmd InsertEnter * highlight CursorLine ctermbg=17
    autocmd InsertLeave * highlight CursorLine ctermbg=none
augroup END


]]
