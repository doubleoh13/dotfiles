return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  -- ft = "markdown",
  event = {
    "BufReadPre " .. vim.fn.expand "~" .. "/vault/*.md",
    "BufNewFile " .. vim.fn.expand "~" .. "/vault/*.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    ui = { enable = false },
    workspaces = {
      {
        name = "Vault",
        path = "~/vault",
        overrides = {
          notes_subdir = "notes",
          daily_notes = {
            folder = "daily_notes",
          },
          templates = {
            folder = "templates",
          },
        }
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    picker = {
      name = "telescope.nvim",
    },
    follow_url_func = function(url)
      vim.ui.open(url)
    end,
  }
}
