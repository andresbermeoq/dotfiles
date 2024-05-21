local status_ok, telescope = pcall(function()
  return require("telescope")
end)

local keymap = vim.keymap
local builtin = require("telescope.builtin")
--local conventional_commits = telescope.extensions.conventional_commits.conventional_commits()

if not status_ok then
  return
end

local function create_conventional_commit()
  local actions = require("telescope._extensions.conventional_commits.actions")
  local picker = require("telescope._extensions.conventional_commits.picker")
  local themes = require("telescope.themes")

  -- if you use the picker directly you have to provide your theme manually
  picker({
    action = actions.prompt,
    include_body_and_footer = true,
    -- theme = themes["get_ivy"]() -- ivy theme
  })
end
-- Keymaps Telescope
keymap.set("n", "<C-p>", builtin.find_files, {})
keymap.set("n", "<C-g>", builtin.git_status, {})
keymap.set("n", "<C-r>", builtin.buffers, {})
keymap.set("n", "<C-b>", builtin.git_branches, {})
keymap.set("n", "<C-s>", create_conventional_commit, { noremap = true, silent = true, desc = "Conventional Commits" })

telescope.setup({
  extensions = {
    conventional_commits = {
      theme = "dropdown",
      include_body_and_footer = false,
    },
  },
})

telescope.load_extension("conventional_commits")
