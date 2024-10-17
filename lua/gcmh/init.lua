local M = {}

function M.start()
	vim.api.nvim_set_hl(0, "Title", { fg = "#ffffff", bold = true })
	vim.api.nvim_set_hl(0, "Indicator", { fg = "#00ff00" })
	vim.api.nvim_set_hl(0, "Filename", { fg = "#ffffff" })

	vim.api.nvim_set_hl(0, "Title", { link = "Title" })
	vim.api.nvim_set_hl(0, "Indicator", { link = "Keyword" })
	vim.api.nvim_set_hl(0, "Filename", { link = "Normal" })

	local ui_stage = require("gcmh.ui_stage")
	local buf = vim.api.nvim_create_buf(false, true)
	print(buf)
	vim.api.nvim_set_current_buf(buf)
	ui_stage.show(buf)
end

return M
