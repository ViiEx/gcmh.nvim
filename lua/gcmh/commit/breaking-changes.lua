local n = require("nui-components")

local M = {}

M.signal = n.create_signal({
	value = "",
})

M.breaking_changes_input = function()
	return n.text_input({
		autofocus = false,
		autoresize = false,
		size = 3,
		value = M.signal.value,
		-- border_label = "Breaking changes",
		placeholder = "Breaking changes",
		max_lines = 3,
	})
end

return M
