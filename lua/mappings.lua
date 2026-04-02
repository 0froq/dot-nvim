-- Delete shit maps
-- vim.keymap.del('n', 'gra')
-- vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grr')
-- vim.keymap.del('n', 'grn')

local useMap = require('useMap')

useMap.nvmap({ 'j', '<Down>' }, 'gj', 'Down')
useMap.nvmap({ 'k', '<Up>' }, 'gk', 'Up')
useMap.nvmap('<Left>', 'h', 'Left')
useMap.nvmap('<Right>', 'l', 'Right')
useMap.nvmap('<PageUp>', '5kzz', 'Scroll up')
useMap.nvmap('<PageDown>', '5jzz', 'Scroll down')
useMap.nvmap('G', 'Gzz', { desc = 'Scroll to bottom', noremap = true, silent = true })

useMap.map({ 'n', 'v', 'x', 's', 'o' }, ';', ':', { noremap = true })

useMap.batch({
  mode = { 'i', 't' },
  { 'aa', '<ESC>',           'Escape insert mode' },
  { 'ww', '<ESC><cmd>w<cr>', 'Escape insert mode' },
  { 'zz', '<ESC>zza',        'Center'}
})

useMap.nmap('<leader>nh', '<cmd>noh<CR>', 'General clear highlights')

-- Show hover
useMap.nmap('K', function()
  vim.lsp.buf.hover({ border = 'single', max_width = 100, max_height = 25, focusable = true, source = true })
end, 'Hover')

--- Maximum current split
-- useMap.nmap('<leader><CR>', )

-- -- Notification
-- map("n", "<leader>N", snacks.notifier.show_history, "Show Notification History")
