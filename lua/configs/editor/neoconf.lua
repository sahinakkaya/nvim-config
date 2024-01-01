-- 💼 Neovim plugin to manage global and project-local settings 
--
--
-- ✨ Features
--
--     configure Neovim using JSON files (can have comments)
--         global settings: ~/.config/nvim/neoconf.json
--         local settings: ~/projects/foobar/.neoconf.json
--     live reload of your lsp settings
--     import existing settings from vscode, coc.nvim and nlsp-settings.nvim
--     auto-completion of all the settings in the Json config files
--     auto-completion of all LSP settings in your Neovim Lua config files
--     integrates with neodev.nvim. See .neoconf.json in this repo.

require("neoconf").setup({})
