vim.api.nvim_create_user_command("GcmhToggle", function()
	require("gcmh").toggle()
end, { desc = "Toggle Git Commit Message Helper" })
