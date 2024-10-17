local M = {
	modified_files = {},
	staged_files = {},

	default_commit_type = "feat",
	commit_types = {
		feat = "Features",
		fix = "Bug Fixes",
		docs = "Documentation",
		style = "Styles",
		refactor = "Code Refactoring",
		perf = "Performance Improvements",
		test = "Tests",
		build = "Builds",
		ci = "Continuous Integration",
		chore = "Chores",
		revert = "Reverts",
	},
	scope = "",
	shord_description = "",
	long_description = "",
	breaking_changes = "",
	closed_issues = "",
}

return M
