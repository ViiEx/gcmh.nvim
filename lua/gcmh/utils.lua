local M = {}

local state = require("gcmh.state")

M.gen_winconfig = function()
	return {
		focusable = true,
		relative = "editor",
		style = "minimal",
		border = "single",
	}
end

return M
