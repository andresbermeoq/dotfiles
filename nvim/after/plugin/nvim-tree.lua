local status_ok, nvim_tree, dressing = pcall(function()
  return require("nvim-tree"), require("dressing")
end)

if not status_ok then
  return
end

--Settings recommended
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

dressing.setup({})

nvim_tree.setup({
  view = {
    width = 35,
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
    icons = {
      webdev_colors = true,
      glyphs = {
        folder = {
          arrow_closed = "", -- arrow when folder is closed
          arrow_open = "", -- arrow when folder is open
        },
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    icons = { error = " ", warning = " ", hint = "󰌶 ", info = " " },
  },
  actions = {
    open_file = {
      window_picker = {
        enable = true,
      },
    },
  },
  filters = {
    custom = { ".DS_Store" },
  },
  git = {
    enable = true,
    timeout = 500,
    ignore = true,
  },
})

local keymap = vim.keymap

keymap.set("n", "<leader>a", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap.set("n", "<leader>f", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer" })
