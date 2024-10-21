local n = require("nui-components")

local M = {}

M.signal = n.create_signal({
	value = "",
})

M.closed_issues = function()
	return n.text_input({
		autofocus = false,
		autoresize = false,
		size = 1,
		value = M.signal.value,
		-- border_label = "Closed issues",
		placeholder = "#1, #2, #3",
		max_lines = 1,
	})
end

return M
