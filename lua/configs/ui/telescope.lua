local sched_if_valid = function(buf, fn)
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(buf) then
      fn()
    end
  end)
end

local mouse_scroll_up = function(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local picker = action_state.get_current_picker(prompt_bufnr)

  local mouse_win = vim.fn.getmousepos().winid
  if picker.results_win == mouse_win then
    local win_info = vim.api.nvim_win_call(mouse_win, vim.fn.winsaveview)
    if win_info.topline > 1 then
      sched_if_valid(prompt_bufnr, function()
        -- picker:set_selection(vim.fn.getmousepos().line - 1)
        actions.results_scrolling_up(prompt_bufnr)
      end)
    end
    return ""
  elseif mouse_win == picker.preview_win then
    sched_if_valid(prompt_bufnr, function()
      actions.preview_scrolling_up(prompt_bufnr)
    end)
    return ""
  else
    return "<ScrollWheelUp>"
  end
end
-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important

local home = os.getenv('HOME')
local config = home .. '/.config/'
local data = home .. '/.local/share/'

local telescope = require("telescope")
local trouble = require("trouble.providers.telescope")
local project_actions = require("telescope._extensions.project.actions")
telescope.setup {
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    -- path_display = { "smart" },
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<m-t>"] = trouble.open_with_trouble,
        ["<scrollwheelup>"] = {
          mouse_scroll_up,
          type = "action",
          opts = { expr = true },
        },
        ["<C-h>"] = "which_key"
      },
      n = {
        ["<m-t>"] = trouble.open_with_trouble,
        ["q"] = "close",
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    colorscheme = {
      enable_preview = true,
      theme = "cursor",
    },
    find_files = {
      theme = "ivy",
      winblend = 10
    }
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    project = {
      -- sync_with_nvim_tree = true,
      on_project_selected = function(prompt_bufnr)
        project_actions.change_working_directory(prompt_bufnr, false)
        require("harpoon"):list():select(1)
      end,
    },
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    frecency = {
      show_filter_column = false,
      sorter = telescope.extensions.fzf.native_fzf_sorter(),
      workspaces = {
        ["conf"]     = config,
        ["data"]     = data,
        ["projects"] = home .. '/Projects',
        ["wiki"]     = home .. '/vimwiki',
        ["scripts"]     = home .. '/scripts',
        ["etc"]      = "/etc"
      },
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    }
  }

}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')
telescope.load_extension("ui-select")
-- telescope.load_extension("frecency")
telescope.load_extension("project")
telescope.load_extension("file_browser")
-- telescope.load_extension("notify")
