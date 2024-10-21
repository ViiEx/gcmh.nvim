vim.api.nvim_create_user_command("GcmhToggle", function()
	require("gcmh").open_commit()
end, { desc = "Toggle Git Commit Message Helper" })
