-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { '*' },
  callback = function()
    vim.api.nvim_exec2('silent! normal! g`"zv', { output = false })
  end,
})

-- Big file
--vim.filetype.add {
--  pattern = {
--    [".*"] = {
--      function(path, buf)
--        if vim.bo[buf].filetype ~= "bigfile" and path and vim.fn.getfsize(path) > vim.g.bigfile_size then
--          vim.opt.cursorline = false
--          return "bigfile"
--        else
--          return nil
--        end
--      end,
--    },
--  },
-- }

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'bigfile',
  pattern = 'bigfile',
  callback = function(ev)
    vim.b.minianimate_disable = true
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ''
    end)
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_augroup('IrreplaceableWindows', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = 'IrreplaceableWindows',
  pattern = '*',
  callback = function()
    local filetypes = { 'OverseerList', 'neo-tree' }
    local buftypes = { 'nofile', 'terminal' }
    if vim.tbl_contains(buftypes, vim.bo.buftype) and vim.tbl_contains(filetypes, vim.bo.filetype) then
      vim.cmd 'set winfixbuf'
    end
  end,
})

vim.api.nvim_create_autocmd('ExitPre', {
  group = vim.api.nvim_create_augroup('Exit', { clear = true }),
  command = 'set guicursor=a:ver90',
  desc = 'Set cursor back to beam when leaving Neovim.',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format({ bufnr = args.buf })
  end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
--       callback = function(args)
--         vim.lsp.buf.code_action({
--           context = {
--             only = { "source.fixAll.eslint" },
--             bufnr = args.buf,
--             diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
--           },
--           apply = true,
--         })
--       end,
--     })


-- When leave, write a session
vim.api.nvim_create_autocmd('ExitPre', {
  -- If no files are open, don't write session
  callback = function(args)
    if #vim.fn.getbufinfo({ buflisted = 1 }) == 0 then
      return
    end
    require('mini.sessions').write('.session.vim')
  end
})

-- -- Limit buffer history to 5 buffers
-- vim.api.nvim_create_autocmd('BufAdd', {
--   callback = function()
--     -- Only count file buffers
--     local buflist = {}
--     for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
--       if vim.bo[buf.bufnr].buftype == '' then
--         table.insert(buflist, { bufnr = buf.bufnr, lastused = buf.lastused })
--       end
--     end
--     if #buflist > 5 then
--       -- Sort buffers by last used time
--       table.sort(buflist, function(a, b)
--         return a.lastused < b.lastused
--       end)
--       -- Delete the oldest buffers
--       for i = 1, #buflist - 5 do
--         vim.api.nvim_buf_delete(buflist[i].bufnr, { force = true })
--       end
--     end
--   end
-- })
