local n = require("nui-components")
local lines = require("gcmh.stage.ui").stage_files()

local M = {}

if not lines then
	local renderer = n.create_renderer({
		width = 60,
		height = 5,
	})
	renderer:render(
		n.paragraph({
			lines = "[close]",
			align = "right",
			is_focusable = false,
		}),
		n.paragraph({
			autofocus = true,
			lines = {
				n.line(n.text("0", "Boolean"), " ", n.text("Files found", "Italic")),
				n.line(n.text("Lines is nil", "String")),
			},
			align = "center",
		})
	)

	return
end

local renderer = n.create_renderer({
	width = 60,
	height = #lines + 4,
})

local function create_nodes()
	local nodes = {}

	for _, line in ipairs(lines) do
		table.insert(
			nodes,
			n.node({
				text = line,
				is_done = false,
			})
		)
	end

	return nodes
end

local body = function()
	return n.tree({
		autofocus = true,
		border_label = "Moddifed Files",
		data = create_nodes(),
		on_select = function(node, component)
			local tree = component:get_tree()
			node.is_done = not node.is_done
			tree:render()
		end,
		prepare_node = function(node, line, component)
			if node.is_done then
				line:append("[✔]", "String")
			else
				line:append("[ ]", "Comment")
			end
			line:append(" ")
			line:append(node.text)
			return line
		end,
	})
end

M.open = function()
	renderer:render(body)
end

return M
