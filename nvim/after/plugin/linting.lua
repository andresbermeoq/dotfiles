local status_ok, lint = pcall(function()
  return require("lint")
end)

if not status_ok then
  return
end

lint.linters_by_ft = {
  python = { "ruff", "pydocstyle" },
  zsh = { "zsh" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

vim.keymap.set("n", "<leader>l", function()
  lint.try_lint()
end, { desc = "Triger linting for current file." })
