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
}
