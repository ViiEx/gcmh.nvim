local M = {}
local api = vim.api
local git = require("gcmh.git")
local volt = require("volt")
local utils = require("gcmh.utils")
local state = require("volt.state")
local draw = require("volt.draw")

-- Commit types based on Conventional Commits
local commit_types = {
	"feat",
	"fix",
	"docs",
	"style",
	"refactor",
	"perf",
	"test",
	"chore",
}

local fields = {
	{ label = "Type:", name = "type", options = commit_types },
	{ label = "Scope (optional):", name = "scope" },
	{ label = "Short Description:", name = "short_desc" },
	{ label = "Long Description:", name = "long_desc" },
	{ label = "Breaking Changes:", name = "breaking_changes" },
	{ label = "Closes Issues:", name = "closes_issues" },
}

-- Function to collect input data
local function collect_input_from_buffer(buf)
	local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
	local inputs = {}
	local idx = 3 -- Starting index after header (which has 3 lines)

	for _, field in ipairs(fields) do
		-- Get the label line (we can skip it if necessary)
		idx = idx + 1
		-- Get the user's input from the next line
		idx = idx + 1
		inputs[field.name] = lines[idx] or ""
	end

	return inputs
end

local function process_commit(inputs)
	-- Existing logic to construct the commit message

	-- Construct the commit message
	local commit_msg = inputs.type
	if inputs.scope ~= "" then
		commit_msg = commit_msg .. "(" .. inputs.scope .. ")"
	end
	commit_msg = commit_msg .. ": " .. inputs.short_desc

	if inputs.long_desc ~= "" then
		commit_msg = commit_msg .. "\n\n" .. inputs.long_desc
	end

	if inputs.breaking_changes ~= "" then
		commit_msg = commit_msg .. "\n\nBREAKING CHANGE: " .. inputs.breaking_changes
	end

	if inputs.closes_issues ~= "" then
		commit_msg = commit_msg .. "\n\nCloses " .. inputs.closes_issues
	end

	-- Write commit message to a temporary file and perform git commit
	local tmpfile = vim.fn.tempname()
	local f = io.open(tmpfile, "w")
	f:write(commit_msg)
	f:close()

	git.commit(tmpfile, function()
		os.remove(tmpfile)
		vim.notify("Commit successful.")
	end)
end

-- Generate the layout for the commit message UI
local function generate_layout(buf)
	local layout = {}
	local width = vim.api.nvim_win_get_width(0)

	-- Header Section
	-- Header Section
	table.insert(layout, {
		name = "header",
		lines = function(buf)
			local title = utils.center_text("Craft Commit Message", width)
			return {
				{ { "" } },
				{ { title, "Title" } },
				{ { "" } },
			}
		end,
		highlights = {},
	})

	-- Input Fields
	local total_lines = 3

	for _, field in ipairs(fields) do
		table.insert(layout, {
			name = field.name,
			lines = function(buf)
				return {
					{ { field.label, "Statement" } },
					{ { "" } }, -- Placeholder for user input
				}
			end,
			highlights = {},
		})
		total_lines = total_lines + 2 -- Adjust for label and input line
	end

	-- Footer Section
	table.insert(layout, {
		name = "footer",
		lines = function(buf)
			return {
				{ { "" } },
				{ { "[Enter] Commit Changes", "Comment" } },
				{ { "[q] Quit", "Comment" } },
			}
		end,
		highlights = {},
	})

	return layout
end

-- Collect input from the user
function M.show()
	vim.schedule(function()
		-- Create a new buffer
		local buf = api.nvim_create_buf(false, true)
		-- Create a floating window
		local width = 60
		local height = 15
		local opts = {
			style = "minimal",
			relative = "editor",
			width = width,
			height = height,
			row = (vim.o.lines - height) / 2,
			col = (vim.o.columns - width) / 2,
			border = "rounded",
			title = "Craft Commit Message",
			title_pos = "center",
		}
		local win = api.nvim_open_win(buf, true, opts)

		-- Generate the layout
		local layout = generate_layout(buf)

		-- Update state
		state[buf] = {
			layout = layout,
			buf = buf,
			clickables = {},
			hoverables = {},
			ids = {},
			xpad = 2,
			ns = api.nvim_create_namespace("GcmhUI"),
		}

		-- Calculate total lines
		local total_lines = 0
		for _, section in ipairs(layout) do
			local lines = section.lines(buf)
			section.row = total_lines
			total_lines = total_lines + #lines
		end

		-- Set empty lines
		volt.set_empty_lines(buf, total_lines, width)

		-- Draw the UI
		volt.redraw(buf, "all")

		-- Set buffer options
		vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
		vim.api.nvim_set_option_value("filetype", "VoltWindow", { buf = buf })

		-- Move cursor to the first input field
		api.nvim_win_set_cursor(win, { 4, 0 }) -- Adjust line number as needed

		-- Enter insert mode
		vim.cmd("startinsert")

		-- Key mappings for navigation
		vim.keymap.set("i", "<Tab>", function()
			local pos = api.nvim_win_get_cursor(0)
			-- Move to the next input field
			api.nvim_win_set_cursor(0, { pos[1] + 2, 0 }) -- Skip label line
			-- Re-enter insert mode
			vim.cmd("startinsert")
		end, { buffer = buf })

		vim.keymap.set("i", "<S-Tab>", function()
			local pos = api.nvim_win_get_cursor(0)
			-- Move to the previous input field
			api.nvim_win_set_cursor(0, { pos[1] - 2, 0 }) -- Skip label line
			-- Re-enter insert mode
			vim.cmd("startinsert")
		end, { buffer = buf })

		-- Key mappings
		vim.keymap.set("n", "<CR>", function()
			local inputs = collect_input_from_buffer(buf)
			process_commit(inputs)
			api.nvim_win_close(win, true)
		end, { buffer = buf })

		vim.keymap.set("n", "q", function()
			api.nvim_win_close(win, true)
		end, { buffer = buf })
	end)
end

return M
