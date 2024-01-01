local M = {}

local _, builtin = pcall(require, "telescope.builtin")

function M.smart_quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
  if modified then
    vim.ui.input({
      prompt = "You have unsaved changes. What do you want to do? (w/q/a) ",
    }, function(input)
      if input == "q" then
        vim.cmd "q!"
      elseif input == "w" then
        vim.cmd "w"
        M.smart_quit()
      end
    end)
  else
    vim.cmd "q!"
  end
end

-- Smartly opens either git_files or find_files, depending on whether the working directory is
-- contained in a Git repo.
function M.find_project_files(opts)
  opts = opts or {}
  local ok = pcall(builtin.git_files, opts)

  if not ok then
    builtin.find_files(opts)
  end
end

function M.go_to_luafile()
  local filename = vim.fn.expand('<cfile>')
  filename = filename:gsub('%.', '/')
  local filepath = vim.fn.stdpath('config') .. '/lua/' .. filename .. '.lua'
  vim.schedule_wrap(vim.cmd('e ' .. filepath))
end

return M
