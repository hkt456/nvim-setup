-- import gitsigns plugin safely
-- local setup, gitsigns = pcall(require, "gitsigns")
-- if not setup then
--   return
--   end
--
--   -- configure/enable gitsigns
--   gitsigns.setup()-- auto install packer if not installed
local cmp = require("cmp")

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- add list of plugins to install
return packer.startup(function(use)
	-- packer can manage itself
	use("wbthomason/packer.nvim")

	use("ellisonleao/gruvbox.nvim")

	use({ "catppuccin/nvim", as = "catppuccin" })

	use("nvim-lua/plenary.nvim") -- lua functions that many plugins use

	use("bluz71/vim-nightfly-guicolors") -- preferred colorscheme

	use("christoomey/vim-tmux-navigator") -- tmux & split window navigation

	use("szw/vim-maximizer") -- maximizes and restores current window

	-- essential plugins
	use("tpope/vim-surround") -- add, delete, change surroundings (it's awesome)
	use("inkarkat/vim-ReplaceWithRegister") -- replace with register contents using motion (gr + motion)

	-- commenting with gc
	use("numToStr/Comment.nvim")

	-- file explorer
	use("nvim-tree/nvim-tree.lua")

	-- vs-code like icons
	use("nvim-tree/nvim-web-devicons")

	-- statusline
	use("nvim-lualine/lualine.nvim")

	-- fuzzy finding w/ telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

	-- configuring lsp servers
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		requires = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	}) -- enhanced lsp uis
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

	-- formatting & linting
	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

	-- terminal window
	use({
		"boltlessengineer/bufterm.nvim",
		config = function()
			require("bufterm").setup()
		end,
	})
	-- Copilot
	use({ "github/copilot.vim" })
	--markdown
	use({ "iamcco/markdown-preview.nvim" })

	-- Rust
	use({
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	}, {
		"simrat39/rust-tools.nvim",
		ft = "rust",
		dependencies = "neovim/nvim-lspconfig",
		opts = function()
			return require("hkt456.plugins.rust-tools.lua")
		end,
		config = function()
			require("rust-tools").setup(_, opts)
		end,
	}, {
		"mfussenegger/nvim-dap",
		init = function()
			require("core.utils").load_mappings("dap")
		end,
	}, {
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			require("cmp").setup.buffer({
				sources = { { name = "crates" } },
			})
			crates.show()
			require("core.utils").load_mappings("crates")
		end,
	}, {
		"hrsh7th/nvim-cmp",
		opts = function()
			local M = require("plugins.configs.cmp")
			M.completion.completeopt = "menu,menuone,noselect"
			M.mapping["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = false,
			})
			table.insert(M.sources, { name = "crates" })
			return M
		end,
	})

	--LaTex
	use("lervag/vimtex")
	if packer_bootstrap then
		require("packer").sync()
	end
end)
