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
