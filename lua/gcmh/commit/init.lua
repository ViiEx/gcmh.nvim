local n = require("nui-components")
local create_selects = require("gcmh.commit.select-type").create_selects
local create_scope_input = require("gcmh.commit.scope").scope_input
local create_short_description_input = require("gcmh.commit.short-description").short_description_input
local create_long_description_input = require("gcmh.commit.long-description").long_description_input
local create_breaking_changes_input = require("gcmh.commit.breaking-changes").breaking_changes_input
local create_closed_issues = require("gcmh.commit.closed-issues").closed_issues

local selected_type = require("gcmh.commit.select-type").signal.get_value()
local scope = require("gcmh.commit.scope").signal.get_value()
local short_description = require("gcmh.commit.short-description").signal.get_value()
local long_description = require("gcmh.commit.long-description").signal.get_value()
local breaking_changes = require("gcmh.commit.breaking-changes").signal.get_value()
local closed_issues = require("gcmh.commit.closed-issues").signal.get_value()

local function on_commit()
	print("Commit")
	print(selected_type[1])
	print(scope[1])
	print(short_description[1])
	print(long_description[1])
	print(breaking_changes[1])
	print(closed_issues[1])
end

local M = {}

local renderer = n.create_renderer({
	width = 70,
	height = 30,
})

local body = function()
	return n.rows(
		n.columns(
			n.rows(
				n.gap(1),
				n.paragraph({
					lines = "Commit Type",
					align = "right",
					is_focusable = false,
				}),
				n.gap(2),
				n.paragraph({
					lines = "Scope",
					align = "right",
					is_focusable = false,
				}),
				n.gap(2),
				n.paragraph({
					lines = "Short Description",
					align = "right",
					is_focusable = false,
				}),
				n.gap(6),
				n.paragraph({
					lines = "Long Description",
					align = "right",
					is_focusable = false,
				}),
				n.gap(8),
				n.paragraph({
					lines = "Breaking Changes",
					align = "right",
					is_focusable = false,
				}),
				n.gap(3),
				n.paragraph({
					lines = "Closed Issues",
					align = "right",
					is_focusable = false,
				}),
				n.gap(1)
			),
			n.rows(
				{ flex = 3 },
				create_selects(),
				create_scope_input(),
				create_short_description_input(),
				create_long_description_input(),
				create_breaking_changes_input(),
				create_closed_issues()
			)
		),
		n.columns(
			{ flex = 1 },
			n.button({
				label = "Commit",
				global_press_key = "<S-CR>",
				on_press = function()
					on_commit()
				end,
			}),
			n.button({
				label = "Cancel",
				global_press_key = "<C-c>",
				on_press = function()
					-- do something on press
				end,
			})
		)
	)
end

M.open = function()
	renderer:render(body())
end

return M
