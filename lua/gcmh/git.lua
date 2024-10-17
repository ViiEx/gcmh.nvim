local M = {}
local uv = vim.loop

-- Execute a git command and capture the output
local function git_cmd(cmd_args, callback)
	local stdout = uv.new_pipe(false)
	local stderr = uv.new_pipe(false)
	local handle

	local output = ""
	local error_output = ""

	handle = uv.spawn("git", { args = cmd_args, stdio = { nil, stdout, stderr } }, function()
		stdout:close()
		stderr:close()
		handle:close()
		vim.schedule(function()
			callback(output, error_output)
		end)
	end)

	stdout:read_start(function(err, data)
		assert(not err, err)
		if data then
			output = output .. data
		end
	end)

	stderr:read_start(function(err, data)
		assert(not err, err)
		if data then
			error_output = error_output .. data
		end
	end)
end

-- Get the list of modified files
function M.get_modified_files(callback)
	git_cmd({ "status", "--porcelain" }, function(output, err)
		if err ~= "" then
			vim.notify("Git Error: " .. err, vim.log.levels.ERROR)
			return
		end

		local files = {}
		for line in output:gmatch("[^\r\n]+") do
			local status, file = line:match("^(..)%s(.+)$")
			if status and file then
				table.insert(files, { status = status, file = file })
			end
		end
		callback(files)
	end)
end

-- Stage a file
function M.stage_file(file, callback)
	git_cmd({ "add", file }, function(_, err)
		if err ~= "" then
			vim.schedule(function()
				vim.notify("Git Error: " .. err, vim.log.levels.ERROR)
			end)
		end
		if callback then
			callback()
		end
	end)
end

-- Unstage a file
function M.unstage_file(file, callback)
	git_cmd({ "reset", file }, function(_, err)
		if err ~= "" then
			vim.schedule(function()
				vim.notify("Git Error: " .. err, vim.log.levels.ERROR)
			end)
		end
		if callback then
			callback()
		end
	end)
end

-- Commit changes
function M.commit(message, callback)
	git_cmd({ "commit", "-F", "-" }, function(_, err)
		if err ~= "" then
			vim.notify("Git Error: " .. err, vim.log.levels.ERROR)
		end
		if callback then
			callback()
		end
	end)
end

return M
