local keymap = vim.keymap.set

-- Move in the visual mode using Ctrl down and up
keymap("n", "J", ":m .+1<CR>==")
keymap("n", "K", ":m .-2<CR>==")
