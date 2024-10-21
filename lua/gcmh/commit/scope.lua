local n = require("nui-components")

local M = {}

M.signal = n.create_signal({
	value = "",
})

M.scope_input = function()
	return n.text_input({
		autofocus = false,
		autoresize = false,
		size = 1,
		value = M.signal.value,
		-- border_label = "Scope",
		placeholder = "Optional scope",
		max_lines = 1,
	})
end

return M
