vim.cmd.packadd("packer.nvim")

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")
  -- You can alias plugin names
  use({ "folke/tokyonight.nvim", as = "tokyonight" })
  -- Which Key
  use({ "folke/which-key.nvim" })
  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  ------ UI
  -- Dressing
  use({ "stevearc/dressing.nvim" })
  -- Treesiter
  use({ "nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" } })
  -- Neo Tree
  use({ "nvim-tree/nvim-tree.lua", requires = { "nvim-tree/nvim-web-devicons" } })
  -- LSP
  use({
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    requires = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  })
  -- Autocomplete CMP
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
    },
  })
  use({
    "folke/neodev.nvim",
  })
  -- Git
  use({
    "tpope/vim-fugitive",
    -- Conventional Commits
    "olacin/telescope-cc.nvim",
  })
  -- Indentation
  use({
    "lukas-reineke/indent-blankline.nvim",
  })
  -- Autopairs
  use({
    "windwp/nvim-autopairs",
    event = "InsertEnter",
  })
  -- Formatters
  use({
    "stevearc/conform.nvim",
    requires = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
  })
  -- Linters
  use({ "mfussenegger/nvim-lint" })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
  })
  -- GIT Blamer
  use({ "braxtons12/blame_line.nvim" })
  -- Git UI
  use({
    "kdheepak/lazygit.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })
  -- Noice
  use({ "folke/noice.nvim", requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } })
  -- Compiler
  use({ "Zeioth/compiler.nvim", requires = { "stevearc/overseer.nvim" } })
  -- Trouble
  use({ "folke/trouble.nvim" })
  -- Debug
  use("mfussenegger/nvim-dap-python")
  use({
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "theHamsta/nvim-dap-virtual-text" },
  })
end)
