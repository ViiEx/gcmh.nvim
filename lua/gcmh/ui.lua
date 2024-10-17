local M = {}

local function flattenTable(t)
	local result = {}

	for _, subTable in pairs(t) do
		for _, value in ipairs(subTable) do
			table.insert(result, value)
		end
	end

	return result
end

local function get_git_status_files()
	-- Run the git command and capture the output
	local handle = io.popen("git status --porcelain")
	-- Check nil
	if handle == nil then
		return nil
	end
	local result = handle:read("*a") -- Read all the output
	handle:close()

	-- Split the result into lines and categorize them as modified or untracked
	local files = {
		modified = {},
		untracked = {},
		staged = {},
	}

	for line in result:gmatch("[^\r\n]+") do
		local status_code = line:sub(1, 2) -- Get the first two characters which indicate the status
		local file_name = line:sub(4) -- File name starts at the 4th character

		if status_code == " M" or status_code == "M " then
			-- Files with 'M ' or ' M' are modified
			table.insert(files.modified, file_name)
		elseif status_code == "??" then
			-- Files with '??' are untracked
			table.insert(files.untracked, file_name)
		elseif status_code == "A " or status_code == " A" then
			table.insert(files.staged, file_name)
		end
	end

	return files
end

-- Stage files UI
M.stage_files = function()
	local files = get_git_status_files()
	if files == nil then
		return
	end

	local lines = {}

	local _files = flattenTable(files)

	for _, file in ipairs(_files) do
		table.insert(lines, { file, { " " } })
	end

	-- for _, file in ipairs(files.modified) do
	-- 	table.insert(lines, { file, "[M]" })
	-- end
	-- for _, file in ipairs(files.untracked) do
	-- 	table.insert(lines, { file, "[??]" })
	-- end

	return lines
end

return M
