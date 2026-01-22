return {
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup()
  --     -- vim.cmd [[colorscheme catppuccin]]
  --
  --   end
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     contrast = "hard",
  --     background = { transparent = true },
  --   },
  -- },
  {
    'Fro-Q/oQ.nvim',
    dev = true,
    dir = '/Users/oQ/2_areas/development/themes/oq.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      style = 'dark',
      mono = {
        -- enabled = true,
        enabled = false,
        keep = {
          keyword = true,
          func = true,
          variable = true,
          number = true,
          boolean = true,
          float = true
        }
      }
    }
  },
}
