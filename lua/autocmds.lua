-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
local M = {}

local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end

M.augroup = augroup

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = augroup 'highlight-yank',
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  group = augroup 'restore-cursor',
  desc = 'Restore cursor position',
  callback = function()
    vim.api.nvim_exec2('silent! normal! g`"zv', { output = false })
  end,
})

-- Big file
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'bigfile',
  pattern = { 'bigfile' },
  callback = function(ev)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ''
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  group = augroup 'terminal',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  group = augroup 'irreplaceabel-windows',
  callback = function()
    local filetypes = { 'OverseerList' }
    local buftypes = { 'nofile', 'terminal' }
    if vim.tbl_contains(buftypes, vim.bo.buftype) and vim.tbl_contains(filetypes, vim.bo.filetype) then
      vim.cmd 'set winfixbuf'
    end
  end,
})

vim.api.nvim_create_autocmd({ 'ExitPre' }, {
  group = augroup 'exit',
  command = 'set guicursor=a:ver90',
})

-- When leave, write a session
vim.api.nvim_create_autocmd({ 'ExitPre' }, {
  group = augroup 'session',
  -- If no files is opened, don't write session
  callback = function()
    if #vim.fn.getbufinfo({ buflisted = 1 }) == 0 then
      return
    end
    require('mini.sessions').write(
      '.session.vim',
      { force = true }
    )
  end
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'qf-right',
  pattern = 'qf',
  callback = function()
    vim.cmd('wincmd L')
    vim.cmd('vertical resize 60')
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'help-right',
  pattern = 'help',
  callback = function()
    vim.cmd('wincmd L')
    vim.cmd('vertical resize 80')
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

return M
