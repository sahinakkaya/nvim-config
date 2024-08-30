local home = os.getenv('HOME')
local config = home .. '/.config/'
local data = home .. '/.local/share/'
local M = {}

M.dadbod_ui = function()
  -- Your DBUI configuration
  --
  vim.g.dbs = {
    -- dev= 'postgres://postgres:mypassword@localhost:5432/my-dev-db',
    -- staging= 'postgres://postgres:mypassword@localhost:5432/my-staging-db',
    -- wp= 'mysql://root@localhost/wp_awesome',
    --
    ["ehane-local"] = 'postgresql://admin:admin@postgres.development.orb.local:5432/ehane-local',
  }
  vim.g.db_ui_table_helpers = {
    postgresql = {
      Count = 'select count(*) from "{table}"'
    }
  }
  vim.g.db_ui_use_nerd_fonts = 1
  vim.g.db_ui_auto_execute_table_helpers = 0
end

M.task_wiki = function()
  vim.g.taskwiki_taskrc_location = config .. 'task/taskrc'
  vim.g.taskwiki_data_location = data .. 'task'
end


M.targets = function()
  -- edit targes mappings if required
  -- vim.cmd([[
  --     autocmd User targets#mappings#user call targets#mappings#extend({
  --   \ 'q': {},
  --   \ })
  -- ]])
end
return M
