local status_ok, telescope = pcall(function()
  return require("telescope")
end)

local keymap = vim.keymap
local builtin = require("telescope.builtin")

if not status_ok then
  return
end

local function create_conventional_commit()
  local actions = require("telescope._extensions.conventional_commits.actions")
  local picker = require("telescope._extensions.conventional_commits.picker")

  -- if you use the picker directly you have to provide your theme manually
  picker({
    action = actions.prompt,
    include_body_and_footer = true,
  })
end
-- Keymaps Telescope
keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find the files." })
keymap.set("n", "<C-g>", builtin.git_status, { desc = "Find the git status." })
keymap.set("n", "<C-r>", builtin.buffers, { desc = "Show the buffers." })
keymap.set("n", "<C-b>", builtin.git_branches, { desc = "Show the git branches." })
keymap.set("n", "<C-s>", create_conventional_commit, { noremap = true, silent = true, desc = "Conventional Commits" })

telescope.setup({
  extensions = {
    conventional_commits = {
      theme = "dropdown",
      include_body_and_footer = true,
    },
  },
})

telescope.load_extension("conventional_commits")
telescope.load_extension("lazygit")
