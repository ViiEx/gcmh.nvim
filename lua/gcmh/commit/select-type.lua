local n = require("nui-components")
local M = {}

-- Set neovim hightlight for NuiComponentsSelectOptionSelected same as FloatBorder
vim.api.nvim_set_hl(0, "NuiComponentsSelectOptionSelected", { link = "FloatBorder" })

M.signal = n.create_signal({
	selected = { "feat" },
})

M.create_selects = function()
	return n.select({
		-- border_label = "Select commit type",
		selected = M.signal.selected,
		data = {
			n.option("Feature", { id = "feat" }),
			n.option("Fix", { id = "fix" }),
			n.option("Docs", { id = "docs" }),
			n.option("Style", { id = "style" }),
			n.option("Refactor", { id = "refactor" }),
			n.option("Performance", { id = "perf" }),
			n.option("Test", { id = "test" }),
			n.option("Build", { id = "build" }),
			n.option("CI", { id = "ci" }),
			n.option("Chore", { id = "chore" }),
			n.option("Revert", { id = "revert" }),
		},
		multiselect = false,
		on_select = function(nodes)
			M.signal.selected = nodes
		end,
	})
end

return M
