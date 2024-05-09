local Hydra = require("hydra")
local gitsigns = require("gitsigns")
local dap = require("dap")
local dapui = require("dapui")
local hydras = {}

hydras.quickwors = Hydra({
	name = "Quick words",
	config = {
		color = "pink",
		hint = false,
	},
	mode = { "n", "x", "o" },
	body = ",",

	heads = {
		{ "W", "<Plug>(smartword-w)" },
		{ "B", "<Plug>(smartword-b)" },
		{ "E", "<Plug>(smartword-e)" },
		-- { "ge", "<Plug>(smartword-ge)" },
		{ "w", "<Plug>WordMotion_w" },
		{ "e", "<Plug>WordMotion_e" },
		{ "b", "<Plug>WordMotion_b" },
		{ "ge", "<Plug>WordMotion_ge" },
		{ "g", "<Plug>WordMotion_g" },
		{ "aw", "<Plug>WordMotion_aw", { mode = "o", exit = true } },
		{ "iw", "<Plug>WordMotion_iw", { mode = "o", exit = true } },
		{ "aW", "<Plug>WordMotion_aW", { mode = "o", exit = true } },
		{ "iW", "<Plug>WordMotion_iW", { mode = "o", exit = true } },
		-- { "<C-R><C-W>", "<Plug>WordMotion_<C-R><C-W>" },
		-- { "<C-R><C-A>", "<Plug>WordMotion_<C-R><C-A>" },
		{ "q", nil, { exit = true, nowait = true } },
		{ ",", nil, { nowait = true } },
		{ "<Esc>", nil, { exit = true, mode = "n" } },
	},
})

local draw_diagram_hint = [[
 Arrow^^^^^^   Select region with <C-v> 
 ^ ^ _K_ ^ ^   _f_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
]]

hydras.draw_diagram = Hydra({
	name = "Draw Diagram",
	hint = draw_diagram_hint,
	config = {
		color = "pink",
		hint = {
			border = "rounded",
		},
		on_enter = function()
			vim.o.virtualedit = "all"
			vim.cmd(":IndentBlanklineToggle")
			vim.cmd(":LspStop")
		end,
		on_exit = function()
			vim.cmd(":IndentBlanklineToggle")
			vim.cmd(":LspRestart")
		end,
	},
	mode = "n",
	heads = {
		{ "H", "<C-v>h:VBox<CR>" },
		{ "J", "<C-v>j:VBox<CR>" },
		{ "K", "<C-v>k:VBox<CR>" },
		{ "L", "<C-v>l:VBox<CR>" },
		{ "f", ":VBox<CR>", { mode = "v" } },
		{ "<Esc>", nil, { exit = true } },
		{ "q", nil, { exit = true, nowait = true, desc = "exit" } },
	},
})

local toggle_hint = [[
  ^ ^  Toggle    ^ ^
  ^
  _c_ Colors
  _h_ hlsearch
  _l_ LspLines
  ^
]]

hydras.toggle = Hydra({
	name = "Toggle",
	hint = toggle_hint,
	config = {
		color = "blue",
		hint = {
			border = "rounded",
			position = "middle",
		},
	},
	mode = { "n", "x" },
	heads = {
		{ "c", ":HexokinaseToggle<CR>" },
		{
			"h",
			function()
				vim.o.hlsearch = not vim.o.hlsearch
			end,
		},
		-- {
		-- 	"l",
		-- 	require("lsp_lines").toggle,
		-- },
		{ "q", nil, { exit = true } },
	},
})

local options_hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _h_ %{hlsearch} highlight search
  _i_ %{list} invisible characters
  _s_ %{spell} spell
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  ^
       ^^^^                _<Esc>_
]]

hydras.options = Hydra({
	name = "Options",
	hint = options_hint,
	config = {
		color = "blue",
		hint = {
			border = "rounded",
			position = "middle",
			funcs = {
				["hlsearch"] = function()
					if vim.o.hlsearch then
						return "[x]"
					else
						return "[ ]"
					end
				end,
			},
		},
	},
	mode = { "n", "x" },
	heads = {
		{
			"n",
			function()
				if vim.o.number == true then
					vim.o.number = false
				else
					vim.o.number = true
				end
			end,
			{ desc = "number" },
		},

		{
			"h",
			function()
				vim.o.hlsearch = not vim.o.hlsearch
			end,
		},
		{
			"r",
			function()
				if vim.o.relativenumber == true then
					vim.o.relativenumber = false
				else
					vim.o.number = true
					vim.o.relativenumber = true
				end
			end,
			{ desc = "relativenumber" },
		},
		{
			"v",
			function()
				if vim.o.virtualedit == "all" then
					vim.o.virtualedit = "block"
				else
					vim.o.virtualedit = "all"
				end
			end,
			{ desc = "virtualedit" },
		},
		{
			"i",
			function()
				if vim.o.list == true then
					vim.o.list = false
				else
					vim.o.list = true
				end
			end,
			{ desc = "show invisible" },
		},
		{
			"s",
			function()
				if vim.o.spell == true then
					vim.o.spell = false
				else
					vim.o.spell = true
				end
			end,
			{ exit = true, desc = "spell" },
		},
		{
			"w",
			function()
				if vim.o.wrap ~= true then
					vim.o.wrap = true
					-- Dealing with word wrap:
					-- If cursor is inside very long line in the file than wraps
					-- around several rows on the screen, then 'j' key moves you to
					-- the next line in the file, but not to the next row on the
					-- screen under your previous position as in other editors. These
					-- bindings fixes this.
					vim.keymap.set("n", "k", function()
						return vim.v.count > 0 and "k" or "gk"
					end, { expr = true, desc = "k or gk" })
					vim.keymap.set("n", "j", function()
						return vim.v.count > 0 and "j" or "gj"
					end, { expr = true, desc = "j or gj" })
				else
					vim.o.wrap = false
					vim.keymap.del("n", "k")
					vim.keymap.del("n", "j")
				end
			end,
			{ desc = "wrap" },
		},
		{
			"c",
			function()
				if vim.o.cursorline == true then
					vim.o.cursorline = false
				else
					vim.o.cursorline = true
				end
			end,
			{ desc = "cursor line" },
		},
		{ "<Esc>", nil, { exit = true } },
		{ "q", nil, { exit = true } },
	},
})

hydras.history = Hydra({
	name = "History",
	config = {
		color = "pink",
		hint = false, -- show it in status line

		on_enter = function()
			vim.cmd(":UndotreeShow")
		end,
		on_exit = function()
			vim.cmd(":UndotreeHide")
		end,
	},

	mode = { "n" },

	heads = {
		{ "h", "g-", { desc = "Go back in time" } },
		{ "l", "g+", { desc = "Go forward in time" } },
		{ "q", nil, { exit = true } },
	},
})

local githint = [[
 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _l_: blame line
 _K_: prev hunk   _u_: undo last stage   _p_: preview hunk   _L_: blame show full 
 _r_: reset hunk  _R_: reset buffer      _S_: stage buffer   ^ ^
 ^
 ^ ^              _<Enter>_: Fugitive              _q_: exit
]]

hydras.git = Hydra({
	name = "Git",
	hint = githint,
	config = {
		-- buffer = 0,
		color = "pink",
		hint = {
			border = "rounded",
		},
		on_enter = function()
			vim.cmd("mkview")
			vim.cmd("silent! %foldopen!")
			vim.bo.modifiable = false
			gitsigns.toggle_signs(true)
			gitsigns.toggle_linehl(true)
		end,
		on_exit = function()
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			vim.cmd("loadview")
			vim.api.nvim_win_set_cursor(0, cursor_pos)
			vim.cmd("normal zv")
			-- gitsigns.toggle_signs(false)
			gitsigns.toggle_linehl(false)
			gitsigns.toggle_deleted(false)
		end,
	},
	mode = { "n", "x" },
	heads = {
		{
			"J",
			function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gitsigns.next_hunk()
				end)
				return "<Ignore>"
			end,
			{ expr = true, desc = "next hunk" },
		},
		{
			"K",
			function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gitsigns.prev_hunk()
				end)
				return "<Ignore>"
			end,
			{ expr = true, desc = "prev hunk" },
		},
		{ "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "stage hunk" } },
		{ "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
		{ "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
		{ "p", gitsigns.preview_hunk, { desc = "preview hunk" } },
		{ "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
		{ "l", gitsigns.blame_line, { desc = "blame" } },
		{ "r", gitsigns.reset_hunk, { desc = "reset hunk" } },
		{ "R", gitsigns.reset_buffer, { desc = "reset hunk" } },
		{
			"L",
			function()
				gitsigns.blame_line({ full = true })
			end,
			{ desc = "blame show full" },
		},
		-- { '/', gitsigns.show, { exit = true, desc = 'show base file' } }, -- show the base of the file
		{ "<Enter>", "<CMD>Git<CR>", { exit = true, desc = "Fugitive" } },
		{ "q", nil, { exit = true, nowait = true, desc = "exit" } },
	},
})

local debug_hint = [[
   _t_  : Toggle breakpoint
   _T_  : Set conditional/hit breakpoint
 _<C-t>_: Clear all breakpoints

 _<CR>_ : Start debugging

   _q_  : exit
]]
hydras.debug = Hydra({
	name = "Debug",
	hint = debug_hint,
	config = {
		color = "pink",
		hint = {
			border = "rounded",
			position = "middle-right",
		},
	},
	mode = { "n" },
	heads = {
		{ "t", dap.toggle_breakpoint },
		{
			"T",
			function()
				vim.ui.input("Condition (leave empty to skip): ", function(condition)
					vim.ui.input("Hit condition (leave empty to skip): ", function(hit_cond)
						if condition == "" then
							condition = nil
						end
						if hit_cond == "" then
							hit_cond = nil
						end
						dap.set_breakpoint(condition, hit_cond)
					end)
				end)
			end,
		},
		{ "<C-t>", dap.clear_breakpoints },
		{
			"<CR>",
			dap.continue,
		},
		{
			"q",
			nil,
			{ exit = true, nowait = true, desc = "exit" },
		},
	},
})

local debug_hint2 = [[
   _t_  : Toggle breakpoint
   _T_  : Set conditional/hit breakpoint
   _L_  : Set log point
 _<C-t>_: Clear all breakpoints

   _c_  : Continue
   _C_  : Reverse continue
   _g_  : Go to line
 _<CR>_ : Run to cursor


   _n_  : Next
   _l_  : Step into
   _h_  : Step out
   _N_  : Step back
   _u_  : Up in stacktrace wo stepping
   _d_  : Down in stacktrace wo stepping
   _r_  : Restart frame

   _e_  : Evaluate expression
   _U_  : Toggle UI
   _q_  : Terminate debugging session
]]

hydras.debug2 = Hydra({
	name = "Debug 2",
	hint = debug_hint2,
	config = {
		color = "pink",
		hint = {
			border = "rounded",
			position = "middle-right",
		},
	},
	mode = { "n", "v" },
	heads = {
		{ "t", dap.toggle_breakpoint },
		{
			"L",
			function()
				vim.ui.input("Log point message: ", function(message)
					if message == "" then
						message = nil
					end
					dap.set_breakpoint(nil, nil, message)
				end)
			end,
		},
		{
			"T",
			function()
				vim.ui.input("Condition (leave empty to skip): ", function(condition)
					vim.ui.input("Hit condition (leave empty to skip): ", function(hit_cond)
						if condition == "" then
							condition = nil
						end
						if hit_cond == "" then
							hit_cond = nil
						end
						dap.set_breakpoint(condition, hit_cond)
					end)
				end)
			end,
		},
		{
			"<C-t>",
			dap.clear_breakpoints,
		},
		{ "g", dap.goto_ },
		{
			"q",
			function()
				dap.disconnect()
				-- Hydra.activate(hydras.debug)
			end,
		},
		{
			"e",
			dapui.eval,
		},
		{
			"K",
			dapui.eval,
		},
		{
			"c",
			dap.continue,
		},
		{
			"C",
			dap.reverse_continue,
		},
		{
			"<CR>",
			dap.run_to_cursor,
		},
		{ "n", dap.step_over },
		{ "l", dap.step_into },
		{ "h", dap.step_out },
		{ "N", dap.step_back },
		{ "u", dap.up },
		{ "d", dap.down },
		{ "U", dapui.toggle },
		{ "r", dap.restart_frame },
		{ "<Esc>", nil },
		-- {
		--   "Q",
		--   nil,
		--   { exit = true, nowait = true, desc = "exit" },
		-- },
	},
})

dap.listeners.after.event_initialized["hydra"] = function()
	Hydra.activate(hydras.debug2)
end

dap.listeners.after.event_terminated["hydra"] = function()
	Hydra.activate(hydras.debug)
end
-- dap.listeners.after.event_exited["hydra"] = function()
--   Hydra.activate(hydras.debug)
-- end

-- hydras.debug2.activate()
-- Hydra.activate(hydras.debug2)

return hydras
