-- vim:fileencoding=utf-8:foldmethod=marker
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

-- }}}

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
    { import = "plugins" },
    {
      "folke/neodev.nvim",
      { "folke/neoconf.nvim", cmd = "Neoconf" }, -- don't quite understand this
      {
        "numToStr/Comment.nvim",
        dependencies = {
          "JoosepAlviste/nvim-ts-context-commentstring",
        },
        keys = keys.comment,
        config = setup_plugins.comment,
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
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        keys = keys.harpoon,
        config = setup_plugins.harpoon,
        dependencies = { { "nvim-lua/plenary.nvim" } }
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
        lazy = true, -- uncomment this line if you are facing a problem with telescope frecency extension
        init = function()
          vim.o.timeout = true
          vim.o.timeoutlen = 500
        end,
        config = function()
          require("configs.ui.whichkey")
        end,
      },
      {
        "folke/noice.nvim",
        event = "VeryLazy",
        config = function()
          require("configs.ui.noice")
        end,
        dependencies = {
          -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
          "MunifTanjim/nui.nvim",
          -- OPTIONAL:
          --   `nvim-notify` is only needed, if you want to use the notification view.
          --   If not available, we use `mini` as the fallback
          {
            "rcarriga/nvim-notify",
            config = function()
              require("configs.ui.notify")
            end
          },
        }
      },
      --  {
      -- 	"rcarriga/nvim-notify",
      --    event="VeryLazy",
      -- 	config = function()
      -- 		require("configs.ui.notify")
      -- 	end,
      -- },
      {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        config = function()
          require("configs.lsp.fidget")
        end,
      },

      {
        "petertriho/nvim-scrollbar",
        dependencies = {
          "kevinhwang91/nvim-hlslens",
          "lewis6991/gitsigns.nvim",
        },
        event = "VeryLazy",
        config = function()
          require("configs.ui.sidebars")
        end,
      },
      {
        "lewis6991/gitsigns.nvim",
        -- config = function ()
        --   require("configs.ui.sidebars")
        -- end
      },

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
        lazy = false,
        config = function()
          require("configs.ui.neotree")
        end,
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
        tag = '0.1.5',
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
        config = function()
          require("configs.ui.telescope")
        end
      },
      { -- there is also integration with rainbow-delimiters. check read me if you want
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        opts = {
          indent = {
            char = "│",
            tab_char = "│",
          },
          scope = { enabled = true },
          exclude = {
            filetypes = {
              "help",
              "alpha",
              "dashboard",
              "neo-tree",
              "Trouble",
              "trouble",
              "lazy",
              "mason",
              "notify",
              "toggleterm",
              "lazyterm",
            },
          },
        },
        main = "ibl",
      },
      {
        "hiphish/rainbow-delimiters.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "VeryLazy",
        config = function()
          require("configs.ui.rainbow-delimiters")
        end
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
          require("configs.ui.hydra_config")
        end,
      },
      {
        "smjonas/inc-rename.nvim",
        -- keys = { "<leader>rn", mode = "n"},
        lazy = false,
        config = function()
          require("inc_rename").setup()
        end,
      }
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
