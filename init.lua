require("hkt456.plugins-setup")
require("hkt456.core.options")
require("hkt456.core.keymaps")
require("hkt456.core.colorscheme")
require("hkt456.plugins.comment")
require("hkt456.plugins.nvim-tree")
require("hkt456.plugins.lualine")
require("hkt456.plugins.telescope")
require("hkt456.plugins.nvim-cmp")
require("hkt456.plugins.lsp.mason")
require("hkt456.plugins.lsp.lspsaga")
require("hkt456.plugins.lsp.lspconfig")
require("hkt456.plugins.lsp.null-ls")
require("hkt456.plugins.autopairs")
require("hkt456.plugins.treesitter")
require("hkt456.plugins.gitsigns")
-- This is for terminal buffer
require("bufterm").setup({
	save_native_terms = true, -- integrate native terminals from `:terminal` command
	start_in_insert = true, -- start terminal in insert mode
	remember_mode = true, -- remember vi_mode of terminal buffer
	enable_ctrl_w = true, -- use <C-w> for window navigating in terminal mode (like vim8)
	terminal = { -- default terminal settings
		buflisted = false, -- whether to set 'buflisted' option
		termlisted = true, -- list terminal in termlist (similar to buflisted)
		fallback_on_exit = true, -- prevent auto-closing window on terminal exit
		auto_close = true, -- auto close buffer on terminal job ends
	},
})

-- This is for VimTex
-- This is necessary for VimTeX to load properly. The "indent" is optional.
-- Note that most plugin managers will do this automatically.
vim.cmd("filetype plugin indent on")

-- This enables Vim's and Neovim's syntax-related features. Without this, some
-- VimTeX features will not work (see ":help vimtex-requirements" for more
-- info).
vim.cmd("syntax enable")

-- Viewer options: One may configure the viewer either by specifying a built-in
-- viewer method:
vim.g.vimtex_view_method = "zathura"

-- Or with a generic interface:
vim.g.vimtex_view_general_viewer = "okular"
vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

-- VimTeX uses latexmk as the default compiler backend. If you use it, which is
-- strongly recommended, you probably don't need to configure anything. If you
-- want another compiler backend, you can change it as follows. The list of
-- supported backends and further explanation is provided in the documentation,
-- see ":help vimtex-compiler".
vim.g.vimtex_compiler_method = "latexrun"

-- Most VimTeX mappings rely on localleader, and this can be changed with the
-- following line. The default is usually fine and is the symbol "\".
vim.g.maplocalleader = ","
-- Define autocmds for the cpp filetype
vim.cmd([[
  autocmd FileType cpp nnoremap <buffer> <F5> :w <bar> !g++ -Wall -Wno-unused-result -std=c++17 -O2 % -o %:r && ./%:r < ./inp.txt <CR>
  autocmd FileType cpp nnoremap <buffer> <F6> :w <bar> !g++ -Wall -Wno-unused-result -std=c++17 -O2 % -o %:r && ./%:r <CR>
  autocmd filetype java nnoremap <F5> :w <bar> !javac % && java -enableassertions %:r <CR>
  autocmd BufNewFile  *.cpp 0r ~/.config/nvim/template/template.cpp 
  autocmd BufNewFile *.c 0r ~/.config/.nvim/template/template.c 
  autocmd filetype python nnoremap <F5> :w <bar> !python3 % < ./inp.txt <CR>
  autocmd filetype perl nnoremap <F5> :w <bar> !perl % <CR>
  autocmd filetype go nnoremap <F5> :w <bar> !go build % && ./%:r <CR>
]])
