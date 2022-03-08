local opts = { noremap = true, silent = true }

-- local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<C-s>", ":w | echo 'do not forget to remove me' | luafile %<CR>", opts)
keymap("n", ";", ":", {noremap=true})
keymap("n", ":", ";", {noremap=true})
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Go to the repo under cursor
-- Ex: press gX -> "Asocia/dotfiles"
-- for complete urls, press gx. 
keymap("n", "gX", ':let url = "https://github.com/" . split(expand("<cWORD>"), "\\"")[0]  | exe "silent! ! xdg-open " . url | echo "Visit repo: " . url <CR>', opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)


-- When text is wrapped, move by terminal rows, not lines, unless a count is provided
keymap('n', 'j', '(v:count == 0 ? "gj" : "j")',
                        {noremap = true, expr = true, silent = true})
keymap('n', 'k', '(v:count == 0 ? "gk" : "k")',
                        {noremap = true, expr = true, silent = true})



-- Navigate buffers
keymap("n", "<Right>", ":bnext<CR>", opts)
keymap("n", "<Left>", ":bprevious<CR>", opts)


-- Insert --
-- keymap("i", "jk", "<ESC>", opts)
-- does not make sense in colemak layout. can't find a reasonable one rn

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


-- insert mode mappings
keymap("i", '<C-a>', '<C-o>^', opts)
keymap("i", '<C-e>', '<C-o>$', opts)
keymap("i", '<C-f>', '<C-o>w', opts)
keymap("i", '<C-b>', '<C-o>b', opts)
keymap("i", '<C-k>', '<C-o>d$', opts)
keymap("i", '<C-u>', '<C-o>d^', opts)
keymap("i", '<C-s>', '<c-g>u<Esc>[s1z=`]a<c-g>u', opts)
