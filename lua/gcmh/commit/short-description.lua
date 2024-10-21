local n = require("nui-components")

local M = {}

M.signal = n.create_signal({
	value = "",
})

M.short_description_input = function()
	return n.text_input({
		autofocus = false,
		autoresize = false,
		size = 1,
		value = M.signal.value,
		-- border_label = "Short description",
		placeholder = "Short description",
		max_lines = 1,
	})
end

return M
