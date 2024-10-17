local M = {}
local api = vim.api
local git = require("gcmh.git")
local volt = require("volt")
local utils = require("gcmh.utils")
local state = require("volt.state")
local draw = require("volt.draw")

-- Generate the layout for the staging UI
local function generate_layout(buf, files)
	local layout = {}
	local width = vim.api.nvim_win_get_width(0)

	-- Header Section
	table.insert(layout, {
		name = "header",
		lines = function(buf)
			local title = utils.center_text("Stage/Unstage Files", width)
			return {
				{ { "" } }, -- Empty line
				{ { title, "Title" } }, -- Centered title with highlight group 'Title'
				{ { "" } }, -- Empty line
			}
		end,
		highlights = {
			{ line = 2, hl_group = "Title" },
		},
	})

	-- Files Section
	local total_lines = 3 -- Adjust based on header lines

	if #files > 0 then
		local file_lines = {}
		local file_callbacks = {}
		for i, file in ipairs(files) do
			local status = file.status
			local filename = file.file
			local indicator = status:match("^%?%?") and "[ ]" or "[✓]"
			local line_mark = {
				{ " " }, -- Leading space
				{ indicator .. " ", "Indicator" }, -- Indicator with highlight
				{ filename, "Filename" }, -- Filename with highlight
			}
			table.insert(file_lines, line_mark)

			-- Store callbacks for click events
			local line_number = i + total_lines
			file_callbacks[line_number] = function()
				if indicator == "[ ]" then
					git.stage_file(filename, function()
						-- Update UI
						M.show()
					end)
				else
					git.unstage_file(filename, function()
						-- Update UI
						M.show()
					end)
				end
			end
		end

		table.insert(layout, {
			name = "files",
			lines = function(buf)
				return file_lines
			end,
			click = file_callbacks,
			highlights = {},
		})

		total_lines = total_lines + #file_lines
	else
		-- No Modified Files Section
		table.insert(layout, {
			name = "no_files",
			lines = function(buf)
				return {
					{ { "No modified files to stage." } },
				}
			end,
			highlights = {},
		})

		total_lines = total_lines + 1
	end

	-- Footer Section
	table.insert(layout, {
		name = "footer",
		lines = function(buf)
			return {
				{ { "" } },
				{ { "[Enter] Continue to Commit Message", "Comment" } },
				{ { "[q] Quit", "Comment" } },
			}
		end,
		highlights = {},
	})

	return layout
end

-- Display the staging UI

function M.show()
	git.get_modified_files(function(files)
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
				title = "Stage/Unstage Files",
				title_pos = "center",
			}
			local win = api.nvim_open_win(buf, true, opts)

			-- Generate the layout
			local layout = generate_layout(buf, files)

			-- Update state
			state[buf] = {
				layout = layout,
				buf = buf,
				clickables = {},
				hoverables = {},
				ids = {},
				xpad = 2, -- Padding for the UI elements
				ns = api.nvim_create_namespace("GcmhUI"), -- Namespace for highlights
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
			vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
			vim.api.nvim_set_option_value("filetype", "VoltWindow", { buf = buf })

			-- Key mappings
			vim.keymap.set("n", "<CR>", function()
				api.nvim_win_close(win, true) -- Close the current window
				require("gcmh.ui_commit").show()
			end, { buffer = buf })

			vim.keymap.set("n", "q", function()
				api.nvim_win_close(win, true)
			end, { buffer = buf })
		end)
	end)
end

return M
