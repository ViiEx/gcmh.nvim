local M = {}

-- Function to center text
function M.center_text(text, width)
	local padding = math.floor((width - #text) / 2)
	return string.rep(" ", padding) .. text
end

-- Function to split string by lines
function M.split_lines(str)
	local t = {}
	for line in str:gmatch("[^\r\n]+") do
		table.insert(t, line)
	end
	return t
end

return M
