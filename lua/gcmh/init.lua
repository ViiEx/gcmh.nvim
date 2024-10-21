local M = {}

M.open_stage = function()
	require("gcmh.stage").open()
end

M.open_commit = function()
	require("gcmh.commit").open()
end

return M
