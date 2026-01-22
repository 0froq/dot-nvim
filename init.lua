---@diagnostic disable: undefined-global
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
  local repo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', repo, '--branch=stable', lazypath }
end

vim.opt.rtp:prepend(lazypath)

-- Leader Key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- load plugins (grouped imports)
require('lazy').setup({
  { 'nvim-treesitter/nvim-treesitter', branch = 'master', lazy = false, build = ':TSUpdate' },
  spec = { import = 'plugins' },
  defaults = { lazy = true },

  ui = {
    icons = {
      ft = '',
      lazy = '󰂠 ',
      loaded = '',
      not_loaded = '',
    },
    border = 'single',
  },
})

require 'autocmds'
require 'filetypes'
require 'options'
require 'lsp'

_G.Utils = require('utils')

vim.schedule(function()
  require 'mappings'
end)

vim.cmd [[colorscheme oq]]
