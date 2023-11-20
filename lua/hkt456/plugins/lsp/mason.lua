local function setupMason()
	local mason_status, mason = pcall(require, "mason")
	if not mason_status then
		print("Error loading Mason:", mason)
		return
	end

	local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not mason_lspconfig_status then
		print("Error loading Mason-lspconfig:", mason_lspconfig)
		return
	end

	local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
	if not mason_null_ls_status then
		print("Error loading Mason-null-ls:", mason_null_ls)
		return
	end

	-- Setup Mason
	mason.setup()

	-- Setup mason-lspconfig
	mason_lspconfig.setup({
		ensure_installed = {
			"tsserver",
			"html",
			"cssls",
			"tailwindcss",
			"lua_ls",
			"emmet_ls",
			"rust_analyzer",
		},
		automatic_installation = true,
	})

	-- Setup mason-null-ls
	mason_null_ls.setup({
		ensure_installed = {
			"prettier",
			"stylua",
			"eslint_d",
		},
		automatic_installation = true,
	})
end

setupMason() -- Call the setup function
