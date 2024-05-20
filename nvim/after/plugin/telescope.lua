local status_ok, telescope = pcall(function ()
    return require'telescope'
end)

local keymap = vim.keymap
local builtin = require('telescope.builtin')
--local conventional_commits = telescope.extensions.conventional_commits.conventional_commits()

if not status_ok then
    return
end
-- Keymaps Telescope
keymap.set("n", "<C-p>", builtin.find_files, {})
keymap.set("n", "<C-g>", builtin.git_status, {})
keymap.set("n", "<C-r>", builtin.buffers, {})
keymap.set("n", "<C-b>", builtin.git_branches, {})


telescope.setup({
})
