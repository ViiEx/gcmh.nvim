local n = require("nui-components")

local M = {}

M.signal = n.create_signal({
	value = "",
})

M.long_description_input = function()
	return n.text_input({
		autofocus = false,
		autoresize = false,
		size = 10,
		value = M.signal.value,
		-- border_label = "Long description",
		placeholder = "Long description",
		max_lines = 10,
	})
end

return M
