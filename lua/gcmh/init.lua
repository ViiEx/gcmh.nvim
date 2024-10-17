local M = {}
local api = vim.api

local state = require("gcmh.state")
local layout = require("gcmh.layout")
local extmarks = require("volt")
local utils = require("gcmh.utils")

state.ns = api.nvim_create_namespace("Gcmh")

M.setup = function(opts)
	state.config = vim.tbl_deep_extend("force", state.config, opts or {})
end

M.open = function()
	state.buf = api.nvim_create_buf(false, true)

	extmarks.gen_data({
		{ buf = state.buf, layout = layout, xpad = 1, ns = state.ns },
	})

	state.win = api.nvim_open_win(state.buf, true, utils.gen_winconfig())
	api.nvim_win_set_hl_ns(state.win, state.ns)
	vim.wo[state.win].winhighlight = "FloatBorder:Comment"

	extmarks.run(state.buf, { h = 40, w = 80 })
	vim.bo[state.buf].ft = "Gcmh"

	state.on_key = vim.on_key(function(_, char)
		-- If pressed space then stage/unstage the file
		if char == " " then
			local line = api.nvim_get_current_line()
			local file = line:match("^(.*)%s+")
			if file then
				if state.staged_files[file] then
					state.staged_files[file] = nil
				else
					state.staged_files[file] = true
				end
				extmarks.redraw(state.buf, { h = 40, w = 80 })
			end
		end
	end)
end

M.close = function()
	state.staged_files = {}
	state.modified_files = {}
	vim.cmd("bd" .. state.buf)
	require("gcmh.state")[state.buf] = nil
	vim.on_key(nil, state.on_key)
end

M.toggle = function()
	if state.visible then
		M.close()
	else
		M.open()
	end

	state.visible = not state.visible
end

return M
