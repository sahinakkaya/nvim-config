-- vim:fileencoding=utf-8
--

vim.env.PYENV_VERSION = vim.fn.system('pyenv version'):match('(%S+)%s+%(.-%)')

vim.g.transparent_enabled = false
local fn = vim.fn
local home = os.getenv('HOME')
local config = home .. '/.config/'
local data = home .. '/.local/share/'
local nconf = fn.stdpath("config")

local function get_output(cmd)
  local f = vim.fn.system(cmd)
  return string.lower(f:gsub("%s+", ""))
end

vim.g.python3_host_prog = home .. "/.pyenv/shims/python3"

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

keymap("n", "<leader>;", ":", { noremap = true })
keymap("v", "<leader>;", ":", { noremap = true })

-- Increment/decrement
keymap('n', '+', '<C-a>', opts)
keymap('n', '-', '<C-x>', opts)

-- substitute plugin overwrites x
vim.keymap.set("n", "<leader>x", "x", { noremap = true })

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


vim.keymap.set('x', 'is', '<Plug>(textobj-sandwich-query-i)')
vim.keymap.set('x', 'as', '<Plug>(textobj-sandwich-query-a)')
vim.keymap.set('o', 'is', '<Plug>(textobj-sandwich-query-i)')
vim.keymap.set('o', 'as', '<Plug>(textobj-sandwich-query-a)')

-- keymap("n", "j", "<NOP>", opts) -- disable j to get used to search with s
-- keymap("n", "k", "<NOP>", opts) -- disable k to get used to search with s

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
  { "BufWritePost", config .. "kitty/kitty.conf", "silent !kill -SIGUSR1 $(pgrep -f kitty)" },
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


local keys = require("configs.keys")
local options = require("configs.options")
local setup_plugins = require('configs.setup_plugins')
local init = require("configs.init")

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
    -- { import = "plugins" }, I have deleted the plugins folder, i don't need this now
    {
      "folke/neodev.nvim",
      { "folke/neoconf.nvim", cmd = "Neoconf" }, -- don't quite understand this
      {
        "numToStr/Comment.nvim",
        dependencies = { {
          "JoosepAlviste/nvim-ts-context-commentstring",
          lazy = false,
          config = function()
            vim.g.skip_ts_context_commentstring_module = true
            require('ts_context_commentstring').setup {}
          end
        }, },
        keys = keys.comment,
        config = setup_plugins.comment,
      },

      {
        "anuvyklack/windows.nvim",
        dependencies = {
          "anuvyklack/middleclass",
          "anuvyklack/animation.nvim",
        },
        cmd = { "WindowsMaximize", "WindowsMaximizeVertically", "WindowsMaximizeHorizontally", "WindowsEqualize" },
        config = function()
          vim.o.winwidth = 10
          vim.o.winminwidth = 10
          vim.o.equalalways = false
          require("windows").setup({
            autowidth = { --		       |windows.autowidth|
              enable = false,
              -- winwidth = 5, --		        |windows.winwidth|
              -- filetype = { --	      |windows.autowidth.filetype|
              --   help = 2,
              -- },
            },
            ignore = { --			  |windows.ignore|
              buftype = { "quickfix" },
              filetype = { "NvimTree", "neo-tree", "undotree", "gundo" },
            },
            animation = {
              enable = true,
              duration = 100,
              fps = 60,
              easing = "in_out_sine",
            },
          })
        end,
      },
      {
        "mrjones2014/smart-splits.nvim",
        config = function()
          require('smart-splits').setup({
            -- Ignored filetypes (only while resizing)
            ignored_filetypes = {
              'nofile',
              'quickfix',
              'prompt',
            },
            -- Ignored buffer types (only while resizing)
            ignored_buftypes = { 'NvimTree', 'neo-tree', 'undotree' },
            -- the default number of lines/columns to resize by at a time
            default_amount = 3,
            -- whether to wrap to opposite side when cursor is at an edge
            -- e.g. by default, moving left at the left edge will jump
            -- to the rightmost window, and vice versa, same for up/down.
            wrap_at_edge = 'split',
            -- when moving cursor between splits left or right,
            -- place the cursor on the same row of the *screen*
            -- regardless of line numbers. False by default.
            -- Can be overridden via function parameter, see Usage.
            move_cursor_same_row = false,
            -- resize mode options
            resize_mode = {
              -- key to exit persistent resize mode
              quit_key = '<ESC>',
              -- keys to use for moving in resize mode
              -- in order of left, down, up' right
              resize_keys = { 'h', 'j', 'k', 'l' },
              -- set to true to silence the notifications
              -- when entering/exiting persistent resize mode
              silent = false,
              -- must be functions, they will be executed when
              -- entering or exiting the resize mode
              hooks = {
                -- on_enter = function() vim.notify('Entering resize mode') end,
                -- on_leave = function() vim.notify('Exiting resize mode, bye') end
                on_enter = nil,
                on_leave = nil
              }
            },
            -- ignore these autocmd events (via :h eventignore) while processing
            -- smart-splits.nvim computations, which involve visiting different
            -- buffers and windows. These events will be ignored during processing,
            -- and un-ignored on completed. This only applies to resize events,
            -- not cursor movement events.
            ignored_events = {
              'BufEnter',
              'WinEnter',
            },
            -- enable or disable the tmux integration
            tmux_integration = false,
          })
        end,
      },
      {
        "soulis-1256/eagle.nvim",
        -- lazy = false,
        -- config = function()
        --   vim.o.mousemoveevent = true
        --   require("eagle").setup({})
        -- end
      },
      {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = "VeryLazy",
        init = function()
          vim.o.foldcolumn = '1' -- '0' is not bad
          vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
          vim.o.foldlevelstart = 99
          vim.o.foldenable = true
          vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
          vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
          vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        end,
        config = function()
          -- require('ufo').setup({
          --   provider_selector = function(bufnr, filetype, buftype)
          --     return { 'treesitter', 'indent' }
          --   end
          -- })
          local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = ("  %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
              local chunkText = chunk[1]
              local chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if targetWidth > curWidth + chunkWidth then
                table.insert(newVirtText, chunk)
              else
                chunkText = truncate(chunkText, targetWidth - curWidth)
                local hlGroup = chunk[2]
                table.insert(newVirtText, { chunkText, hlGroup })
                chunkWidth = vim.fn.strdisplaywidth(chunkText)
                -- str width returned from truncate() may less than 2nd argument, need padding
                if curWidth + chunkWidth < targetWidth then
                  suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                end
                break
              end
              curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "MoreMsg" })
            return newVirtText
          end
          require('ufo').setup({
            close_fold_kinds_for_ft = {
              default = { 'imports', 'comment' },
              json = { 'array' },
              c = { 'comment', 'region' }
            },
            fold_virt_text_handler = handler,
          })
        end
      },
      {
        "SmiteshP/nvim-navic",
        event = "VeryLazy",
        dependencies = "neovim/nvim-lspconfig",
        config = function()
          vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
          require("nvim-navic").setup { -- vscode like icons
            icons = {
              File = '  ',
              Module = '  ',
              Namespace = '  ',
              Package = '  ',
              Class = '  ',
              Method = '  ',
              Property = '  ',
              Field = '  ',
              Constructor = '  ',
              Enum = '  ',
              Interface = '  ',
              Function = '  ',
              Variable = '  ',
              Constant = '  ',
              String = '  ',
              Number = '  ',
              Boolean = '  ',
              Array = '  ',
              Object = '  ',
              Key = '  ',
              Null = '  ',
              EnumMember = '  ',
              Struct = '  ',
              Event = '  ',
              Operator = '  ',
              TypeParameter = '  '
            },

            highlight = true,
            separator = " > ",
            depth_limit = 0,
            depth_limit_indicator = "..",
            safe_output = true,
          }
        end,
      },


      -- Add/change/delete surrounding delimiter pairs with ease. Written with ❤️ in Lua.
      -- ✨ Features
      --     Add/delete/change surrounding pairs
      --         Function calls and HTML tags out-of-the-box
      --     Dot-repeat previous actions
      --     Set buffer-local mappings and surrounds
      --     Jump to the nearest surrounding pair for modification
      --     Use a single character as an alias for several text-objects
      --         E.g. q is aliased to `,',", so csqb replaces the nearest set of quotes with parentheses
      --     Surround using powerful pairs that depend on user input
      --     Modify custom surrounds
      --         First-class support for Vim motions, Lua patterns, and Tree-sitter nodes
      --     Highlight selections for visual feedback
      {
        "kylechui/nvim-surround",
        keys = keys.nvim_surround,
        opts = options.nvim_surround
      },
      {
        'akinsho/toggleterm.nvim',
        version = "*",
        lazy = false,
        config = function()
          require('configs.terminal')
        end
      },
      -- {"machakann/vim-sandwich"}
      -- {
      --   "windwp/nvim-autopairs",
      --   config = function()
      --     require("configs.editor.autopairs")
      --
      --   end,
      --   event = "InsertEnter",
      -- },
      {
        'altermo/ultimate-autopair.nvim',
        event = { 'InsertEnter', 'CmdlineEnter' },
        branch = 'v0.6', --recomended as each new version will have breaking changes
        opts = options.ultimate_pairs,
      },
      {
        "gbprod/substitute.nvim",
        keys = keys.substitute,
        config = setup_plugins.substitute,
      },
      {
        "monaqa/dial.nvim",
        keys = keys.dial,
        config = setup_plugins.dial,
      },

      {
        "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        build = ":TSUpdate",
        dependencies = {
          "nvim-treesitter/nvim-treesitter-textobjects",
          "chrisgrieser/nvim-various-textobjs",
          -- "theHamsta/nvim-treesitter-pairs",
          {
            'andymass/vim-matchup',
            init = function()
              -- may set any options here
              vim.g.matchup_matchparen_offscreen = { method = "popup" }
            end
          },
          -- "RRethy/nvim-treesitter-textsubjects", tested it, not worth using
          {
            "windwp/nvim-ts-autotag",
            config = function() require("nvim-ts-autotag").setup() end,
          }
        },
        config = setup_plugins.treesitter,
      },
      {
        "gbprod/yanky.nvim",
        opts = options.yanky,
        keys = keys.yanky,
      },
      {
        "Fildo7525/pretty_hover",
        event = "LspAttach",
      opts= {}
      },
      {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        keys = keys.harpoon,
        config = setup_plugins.harpoon,
        dependencies = { "nvim-lua/plenary.nvim" }
      },
      {
        'nvim-pack/nvim-spectre',
        cmd = "Spectre",
        keys = keys.spectre
      },
      {
        "johmsalas/text-case.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = setup_plugins.text_case,
        keys = keys.text_case,
      },
      { "tpope/vim-fugitive", cmd = { "G", "Git", "Gedit", "Gsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GRename", "GDelete", "GBrowse" } },
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = setup_plugins.copilot,
      },
      {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
          { 'tpope/vim-dadbod',                     lazy = true },
          { 'pbogut/vim-dadbod-ssh',                lazy = true,                      commit = "e4fbabb21a3d737510193c3d9f124a566e7f5910" },
          { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
        },
        cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
        init = init.dadbod_ui,
      },

      {
        "rcarriga/nvim-dap-ui",
        config = setup_plugins.dapui,
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", 'theHamsta/nvim-dap-virtual-text' }
      },
      {
        "mfussenegger/nvim-dap-python",
        keys = keys.nvim_dap_python,
        dependencies = { "mfussenegger/nvim-dap" },
        config = setup_plugins.nvim_dap_python,
      },

      {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        lazy = false,
        config = setup_plugins.leap,
      },
      {
        "junegunn/vim-easy-align",
        keys = keys.vim_easy_align,
        config = setup_plugins.vim_easy_align,
      },
      { "wellle/targets.vim",  init = init.targets, lazy = false }, -- aa --> around argument. i already have this with tree sitter. need to check later


      -- {
      --   "jay-babu/mason-nvim-dap.nvim",
      --   dependencies = {
      --     "williamboman/mason.nvim",
      --     "mfussenegger/nvim-dap",
      --   }
      -- }
      --
      --
      -- filetype specific plugins
      {
        "tridactyl/vim-tridactyl",
        ft = "tridactyl"
      },
      -- {
      -- 'vimwiki/vimwiki',
      -- ft = 'vimwiki',
      -- keys = keys.vimwiki,
      -- },
      {
        "tools-life/taskwiki",
        ft = "vimwiki",
        init = init.taskwiki
      },
      -- filetype specific plugins end
      -- lsp related plugins
      {
        "williamboman/mason.nvim",
        cmd = "Mason",
        dependencies = {
          "williamboman/mason-lspconfig.nvim",
          {
            'stevearc/dressing.nvim',
            opts = {},
          }
        },
      },
      {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = setup_plugins.lsp_config,

      },
      {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        config = setup_plugins.typescript_tools,
      },
      {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = options.trouble,
      },
      {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-treesitter/nvim-treesitter",
        },
        config = setup_plugins.refactoring,
      },
      -- lsp plugins end

      { "abecodes/tabout.nvim" },
      {
        "rebelot/kanagawa.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
          vim.o.background = get_output('cat $HOME/.theme')
          vim.cmd([[colorscheme kanagawa]])
        end,

      },
      {
        "folke/which-key.nvim",
        keys = keys.which_key,
        lazy = false, -- uncomment this line if you are facing a problem with frecency plugin. it inserts an A character if database is not up to date
        init = function()
          vim.o.timeout = true
          vim.o.timeoutlen = 500
        end,
        config = setup_plugins.which_key,
      },
      {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
          -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
          "MunifTanjim/nui.nvim",
          -- OPTIONAL:
          --   `nvim-notify` is only needed, if you want to use the notification view.
          --   If not available, we use `mini` as the fallback
          {
            "rcarriga/nvim-notify",
            config = setup_plugins.notify
          },
        },
        config = setup_plugins.noice,
      },
      {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        config = setup_plugins.fidget,
      },

      { -- i almost never use this. maybe i can delete it
        "petertriho/nvim-scrollbar",
        dependencies = {
          "kevinhwang91/nvim-hlslens",
          "lewis6991/gitsigns.nvim",
        },
        event = "VeryLazy",
        config = setup_plugins.scrollbar,
      },
      {
        "lewis6991/gitsigns.nvim",
        -- config = setup_plugins.scrollbar,
      },
      -- {"sindrets/diffview.nvim", lazy = false}, -- a confusing git diff plugin. need to check later

      {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
          "mrbjarksen/neo-tree-diagnostics.nvim",
          -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        cmd = "Neotree",
        config = setup_plugins.neotree,
      },

      -- {
      --   "3rd/image.nvim",
      --   -- ft = { "markdown", "vimwiki" },
      --   config = function()
      --     -- Example for configuring Neovim to load user-installed installed Lua rocks:
      --     package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
      --     package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
      --     require("image").setup({ editor_only_render_when_focused = true,  window_overlap_clear_enabled = true,tmux_show_only_in_active_window = true })
      --   end
      -- }, -- Optional image support in preview window: See `# Preview Mode` for more information
      {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        -- or, branch = '0.1.x',
        dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-telescope/telescope-ui-select.nvim',
          "nvim-treesitter/nvim-treesitter",
          "nvim-tree/nvim-web-devicons",
          "nvim-telescope/telescope-frecency.nvim",
          "nvim-telescope/telescope-file-browser.nvim",
          "nvim-telescope/telescope-project.nvim",
          {
            'nvim-telescope/telescope-fzf-native.nvim',
            build =
            'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
          }
        },
        -- event = "VeryLazy",
        config = setup_plugins.telescope,
      },
      { -- there is also integration with rainbow-delimiters. check read me if you want
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        opts = options.indent_blankline,
        main = "ibl",
      },
      {
        "hiphish/rainbow-delimiters.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        config = function()
          -- This module contains a number of default definitions
          local rainbow_delimiters = require 'rainbow-delimiters'

          vim.g.rainbow_delimiters = {
            strategy = {
              [''] = rainbow_delimiters.strategy['global'],
              vim = rainbow_delimiters.strategy['local'],
            },
            query = {
              [''] = 'rainbow-delimiters',
              lua = 'rainbow-blocks',
            },
            priority = {
              [''] = 110,
              lua = 210,
            },
            highlight = {
              'RainbowDelimiterRed',
              'RainbowDelimiterYellow',
              'RainbowDelimiterBlue',
              'RainbowDelimiterOrange',
              'RainbowDelimiterGreen',
              'RainbowDelimiterViolet',
              'RainbowDelimiterCyan',
            },
          }
        end
      },
      {
        'stevearc/oil.nvim',
        opts = {
          keymaps = {
            ["?"] = "actions.show_help",
          }
        },
        lazy = false,
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
      },
      {
        'NvChad/nvim-colorizer.lua',
        cmd = { "ColorizerAttachToBuffer", "ColorizerToggle" },
        config = function()
          require('colorizer').setup()
        end
      },
      {
        "karb94/neoscroll.nvim",
        keys = keys.neoscroll,
        config = function()
          require("neoscroll").setup()
        end
      },

      {
        "nvimtools/hydra.nvim",
        dependencies = {
          { "anuvyklack/vim-smartword" },
          {
            "chaoren/vim-wordmotion",
            init = function()
              vim.g.wordmotion_nomap = 1
              -- vim.g.wordmotion_prefix = ","
            end,
          }
        },
        keys = keys.hydra,
        config = function()
          require('hydra').setup {}
          require("configs.initialize_hydras")
        end,
      },
      {
        "smjonas/inc-rename.nvim",
        -- keys = { "<leader>rn", mode = "n"},
        lazy = false,
        config = function()
          require("inc_rename").setup()
        end,
      },
      {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "hrsh7th/cmp-nvim-lsp",
          -- {
          --   "zbirenbaum/copilot-cmp",
          --   config = function()
          --     require("copilot_cmp").setup()
          --   end
          -- },
          "saadparwaiz1/cmp_luasnip",
          {
            "L3MON4D3/LuaSnip",
            -- follow latest release.
            version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            -- install jsregexp (optional!).
            build = "make install_jsregexp",
            dependencies = { "rafamadriz/friendly-snippets" },
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
              local ls = require("luasnip")
              vim.keymap.set({ "i" }, "<C-j>", function()
                if ls.expand_or_jumpable() then
                  ls.expand_or_jump()
                end
              end, { silent = true })
              vim.keymap.set({ "i", "s" }, "<C-E>", function()
                if ls.choice_active() then
                  ls.change_choice(1)
                end
              end, { silent = true })
            end
          },
          -- "dmitmel/cmp-cmdline-history",
          -- "rcarriga/cmp-dap",
          "petertriho/cmp-git",
        },
        config = function()
          local cmp = require('cmp')
          local luasnip = require("luasnip")
          -- local cmp_select = { behavior = cmp.SelectBehavior.Select }


          local icons = require('sahinakkaya.icons')


          local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
          end



          -- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
          cmp.setup({
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            -- formatting = format,
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-2),
              ['<C-f>'] = cmp.mapping.scroll_docs(2),
              ['<C-n>'] = cmp.mapping.select_next_item(),
              ['<C-p>'] = cmp.mapping.select_prev_item(),
              ['<C-t>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items

              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.jumpable() then
                  luasnip.jump()
                  -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                  -- that way you will only jump inside the snippet region
                  -- elseif has_words_before() then
                  --   cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s", "c" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s", "c" }),
            }),

            formatting = {
              -- fields are "abbr", "kind", "menu"
              format = function(entry, vim_item)
                -- Kind icons
                -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                vim_item.kind = string.format("%s %s", icons.kinds[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind

                local function trim(text)
                  local max = 40
                  if text and text:len() > max then
                    text = text:sub(1, max) .. "..."
                  end
                  return text
                end

                vim_item.abbr = trim(vim_item.abbr)

                -- vim_item.menu = ({
                -- 	nvim_lsp = "[LSP]",
                -- 	luasnip = "[Snippet]",
                -- 	buffer = "[Buffer]",
                -- 	path = "[Path]",
                -- 	nvim_lua = "[Lua]",
                -- 	latex_symbols = "[Latex]",
                -- })[entry.source.name]

                local menu_name = icons.sources[entry.source.name] or ("[" .. entry.source.name .. "]")
                vim_item.menu = menu_name .. " "
                -- vim_item.menu = "via " .. menu_name
                -- local item = entry:get_completion_item()
                -- if item.detail then
                --   vim_item.menu = item.detail
                -- end
                return vim_item
              end,
            },
            sources = cmp.config.sources({
                { name = 'luasnip',  max_item_count = 40 },
                -- { name = "copilot",  group_index = 2 },
                { name = 'nvim_lsp', max_item_count = 40 },
                { name = 'path' }
              },
              {
                { name = 'buffer' },
              })
          })

          -- Set configuration for specific filetype.
          cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
              { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            }, {
              { name = 'buffer' },
            })
          })


          cmp.setup.filetype("harpoon", {
            sources = cmp.config.sources({
              { name = "path" },
            }),
            -- formatting = format,
          })

          -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
          })

          -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })

          require('tabout').setup {}
        end,
      },

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
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
        event = { 'User KittyScrollbackLaunch' },
        -- version = '*', -- latest stable version, may have breaking changes if major version changed
        -- version = '^4.0.0', -- pin major version, include fixes and features that do not have breaking changes
        config = function()
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
        end,
      },

      { "mbbill/undotree", cmd = { "UndotreeToggle", "UndotreeShow" } },
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
          vim.cmd 'Abolish retunr return'
          vim.cmd 'Abolish reutnr return'
          vim.cmd 'Abolish retrun return'
          vim.cmd 'Abolish improt import'
          vim.cmd 'Abolish ipmort import'
          vim.cmd 'Abolish impotr import'
          vim.cmd 'Abolish iopmrt import'
          vim.cmd 'Abolish iomprt import'
        end
      },
    }
  },
  {
    defaults = {
      lazy = true,
    },
    install = {
      colorscheme = { "kanagawa", "tokyonight", "habamax" },
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
          -- "netrwPlugin",
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
require("eagle").setup({
  -- override the default values found in config.lua
  close_on_cmd = false,
})

-- make sure mousemoveevent is enabled
vim.o.mousemoveevent = true
