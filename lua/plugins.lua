local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end
-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- -- improve startup time
	-- use {
	--   "lewis6991/impatient.nvim",
	--   config = function() require("impatient").enable_profile() end
	-- }
	--

	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins

	--- colorschemes
	use({
		"folke/tokyonight.nvim",
		config = function()
			vim.g.tokyonight_style = "night"
			-- vim.g.tokyonight_transparent = true
			-- vim.g.tokyonight_hide_inactive_statusline = true
			vim.api.nvim_command("colorscheme tokyonight")
		end,
	})

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

	-- -- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			require("plugin_configs.telescope_config")
		end,
	})
	--
	-- -- Treesitter
	-- use {
	--   "nvim-treesitter/nvim-treesitter",
	--   run = ":TSUpdate",
	-- }
	-- use "JoosepAlviste/nvim-ts-context-commentstring"

	-- cmp plugins
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugin_configs.nvim_cmp")
		end,
	}) -- The completion plugin
	use("hrsh7th/cmp-nvim-lsp") -- lsp completions
	use({
		"hrsh7th/cmp-buffer", -- buffer completions
		requires = { "hrsh7th/nvim-cmp" },
	})
	use({
		"hrsh7th/cmp-cmdline", -- cmdline completions
		requires = { "hrsh7th/nvim-cmp" },
	})
	use({
		"hrsh7th/cmp-path", -- path completions
		requires = { "hrsh7th/nvim-cmp" },
	})
	use("saadparwaiz1/cmp_luasnip") -- snippet completions

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- custom plugins
  -- motion
  use {
    'phaazon/hop.nvim',
    event = 'BufRead',
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require('hop').setup({
        keys = 'dhnasoeifgqcrlwvjzpymkbxut',
        term_seq_bias = 1
      })
    end
  }

	-- Git
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("plugin_configs.git-signs")
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	use({
		"Asocia/vim-tmux-navigator",
		config = function()
			vim.g.tmux_navigator_disable_when_zoomed = 1
			vim.g.tmux_navigator_no_wrap = 0
		end,
	})
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		config = function()
			require("plugin_configs.nvimtree")
		end,
	})

	use({
		-- https://github.com/numToStr/Comment.nvim
		"numToStr/Comment.nvim",
		event = "BufRead",
		config = function()
			require("Comment").setup()
		end,
	})

	use({
		"folke/which-key.nvim",
		event = "BufRead",
		config = function()
			require("plugin_configs.whichkey")
		end,
	})

	use({
		-- https://github.com/machakann/vim-sandwich/issues/115#issuecomment-940869113
		"machakann/vim-sandwich",
		config = function()
			vim.api.nvim_command("runtime macros/sandwich/keymap/surround.vim")
		end,
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("plugin_configs.autopairs")
		end,
	})
	use({
		"monaqa/dial.nvim",
		event = "BufRead",
		config = function()
			require("plugin_configs.dial")
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
