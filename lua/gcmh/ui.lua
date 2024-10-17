local volt = require("volt")
local git = require("gcmh.git")

local M = {}

function M.show_file_staging_ui()
	local files = git.get_modified_files()
	if #files == 0 then
		print("No files to stage")
		return
	end

	-- Prepare items for the list
	local items = {}
	for _, f in ipairs(files) do
		table.insert(items, {
			text = string.format("[%s] %s", f.status, f.file),
			checked = f.status ~= "??", -- Assume staged if not untracked
			file = f.file,
		})
	end

	-- Create a list UI
	local list = volt.List
end
