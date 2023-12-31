local Terminal = require("bufterm.terminal").Terminal
local term = require("bufterm.terminal")
local conf = require("bufterm.config")
local opts = require("bufterm.config").options
local augroup = require("bufterm.config").augroup
local utils = require("bufterm.utils")

if opts.save_native_terms then
	vim.api.nvim_create_autocmd("TermOpen", {
		group = augroup,
		-- schedule to get proper buffer options
		callback = vim.schedule_wrap(function(args)
			if vim.bo[args.buf].filetype == conf.filetype then
				-- check if current buffer is already configured to prevent duplicate
				return
			elseif not vim.bo[args.buf].buflisted then
				-- ignore buffers already unlisted (those may be not interactive ones)
				return
			end
			utils.log("Saving native terminal")
			-- create new Terminal object with scanned informations
			local ok, jobid = pcall(vim.fn.jobpid, vim.bo[args.buf].channel)
			if not ok then
				return
			end
			local _ = Terminal:new({
				bufnr = args.buf,
				jobid = jobid,
				termlisted = true,
			})
		end),
	})
end

local term_mode_var = "__terminal_mode"
local function set_mode(buf, mode)
	vim.b[buf][term_mode_var] = mode
end

local function get_mode(buf)
	return vim.b[buf][term_mode_var]
end

local function disable_insert(buf)
	vim.api.nvim_create_autocmd("TermEnter", {
		group = augroup,
		buffer = buf,
		callback = function()
			vim.cmd.stopinsert()
		end,
	})
end

vim.api.nvim_create_autocmd("TermClose", {
	group = augroup,
	callback = function(args)
		vim.schedule(function()
			if not vim.api.nvim_buf_is_loaded(args.buf) then
				return
			end
			if vim.b[args.buf].fallback_on_exit then
				local prev_buf = term.get_prev_buf(args.buf)
				if prev_buf and prev_buf ~= args.buf then
					vim.api.nvim_set_current_buf(prev_buf)
					-- HACK: hack from u/pysan3
					-- maybe `:h autocmd-nested` can be help?
					if get_mode(prev_buf) == "t" then
						vim.api.nvim_feedkeys("A", "n", false)
					end
				end
			end
			if vim.b[args.buf].auto_close then
				vim.api.nvim_buf_delete(args.buf, { force = true })
			else
				-- TODO: remove lock feature
				utils.log("locking terminal")
				vim.cmd.stopinsert()
				set_mode(args.buf, "n")
				disable_insert(args.buf)
			end
		end)
		vim.api.nvim_exec_autocmds("User", {
			pattern = "__BufTermClose",
			data = {
				buf = args.buf,
			},
		})
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = vim.schedule_wrap(function(args)
		if opts.start_in_insert then
			if args.buf == vim.api.nvim_get_current_buf() then
				utils.log("startinsert in TermOpen")
				vim.cmd.startinsert()
			end
			if opts.remember_mode then
				set_mode(args.buf, "t")
			end
		end
	end),
})
if opts.remember_mode then
	vim.api.nvim_create_autocmd("TermEnter", {
		group = augroup,
		callback = function(args)
			set_mode(args.buf, "t")
		end,
	})
	vim.api.nvim_create_autocmd("TermLeave", {
		group = augroup,
		callback = function(args)
			set_mode(args.buf, "n")
		end,
	})
	vim.api.nvim_create_autocmd("BufEnter", {
		group = augroup,
		pattern = "term://*",
		callback = vim.schedule_wrap(function(args)
			if args.buf ~= vim.api.nvim_get_current_buf() then
				return
			end
			if get_mode(args.buf) == "n" then
				utils.log("stopinsert  in BufEnter")
				vim.cmd.stopinsert()
			else
				utils.log("startinsert in BufEnter")
				vim.cmd.startinsert()
			end
		end),
	})
	vim.api.nvim_create_autocmd("ModeChanged", {
		group = augroup,
		pattern = "c:ntT",
		callback = vim.schedule_wrap(function(args)
			local new_buf = vim.api.nvim_get_current_buf()
			if args.buf ~= new_buf then
				-- re-enter terminal mode at that buffer
				-- to handle when user entered command line from terminal mode
				vim.api.nvim_exec_autocmds("TermEnter", {
					buffer = args.buf,
				})
				local is_new_term = vim.bo[new_buf].buftype == "terminal"
				-- if changed buffer is not terminal buffer, stopinsert
				if not is_new_term then
					vim.cmd.stopinsert()
				end
			end
		end),
	})
end
