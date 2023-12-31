local M = {}

---@class BufTermTerminalConfig
---@field buflisted boolean
---@field fallback_on_exit boolean
---@field auto_close boolean

---@class BufTermConfig
---@field debug boolean
---@field save_native_terms boolean
---@field start_in_insert boolean
---@field remember_mode boolean
---@field enable_ctrl_w boolean
---@field terminal BufTermTerminalConfig
M.options = {
	debug = false,
	save_native_terms = true,
	start_in_insert = true,
	remember_mode = true,
	enable_ctrl_w = true,
	terminal = {
		buflisted = true,
		fallback_on_exit = true,
		auto_close = true,
	},
}

M.augroup = vim.api.nvim_create_augroup("BufTerm", {})
M.filetype = "BufTerm"

---setup bufterm plugin config
---@param opts? BufTermConfig
function M.set(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend("force", M.options, opts)
end

return M
