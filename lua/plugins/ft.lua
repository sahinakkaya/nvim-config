local home = os.getenv('HOME')
local config = home .. '/.config/'
local data = home .. '/.local/share/'

local keys = require("configs.keys")

return {
  -- filetype specific plugins
  {
    "tridactyl/vim-tridactyl",
    ft = "tridactyl"
  },
  {
    'vimwiki/vimwiki',
    ft = 'vimwiki',
    -- dependencies = {"3rd/image.nvim"}, -- image.nvim doesn't play well with vimwiki because there is no ts parser for vimwiki
    keys = keys.vimwiki,
  },
  {
    "tools-life/taskwiki",
    ft = "vimwiki",
    config = function()
      vim.g.taskwiki_taskrc_location = config .. 'task/taskrc'
      vim.g.taskwiki_data_location = data .. 'task'
    end
  },
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    cmd="Neorg",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.ui.calendar"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/notes",
              },
              default_workspace = "notes",
            },
          },
        },
      }

      vim.wo.foldlevel = 99
      vim.wo.conceallevel = 2
    end,
  },

  {
    "3rd/image.nvim",
    ft = { "markdown" },
    config = function()
      -- Example for configuring Neovim to load user-installed installed Lua rocks:
      package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
      package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
      require("image").setup({ editor_only_render_when_focused = true, window_overlap_clear_enabled = true, tmux_show_only_in_active_window = true })
    end
  }, -- Optional image support in preview window: See `# Preview Mode` for more information
  {  -- syntax highlighting for kitty configuration
    "fladson/vim-kitty",
    ft = "kitty",
  }
}
