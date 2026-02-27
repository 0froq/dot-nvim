-- Delete shit maps
-- vim.keymap.del('n', 'gra')
-- vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grr')
-- vim.keymap.del('n', 'grn')

useMap.nvmap({ 'j', '<Down>' }, 'gj', 'Down')
useMap.nvmap({ 'k', '<Up>' }, 'gk', 'Up')
useMap.nvmap('<Left>', 'h', 'Left')
useMap.nvmap('<Right>', 'l', 'Right')
useMap.nmap('<PageUp>', '5kzz', 'Scroll Up')
useMap.nmap('<PageDown>', '5jzz', 'Scroll Down')

useMap.map({ 'n', 'v', 'x', 's', 'o' }, ';', ':', { noremap = true })

useMap.batch({
  mode = { 'i', 't' },
  { 'aa', '<ESC>',           'Escape insert mode' },
  { 'ww', '<ESC><cmd>w<cr>', 'Escape insert mode' }
})

useMap.nmap('<leader>nh', '<cmd>noh<CR>', 'General clear highlights')

-- Show hover
useMap.nmap('K', function()
  vim.lsp.buf.hover({ border = 'single', max_width = 100, max_height = 25, focusable = true, source = true })
end, 'Hover')

-- -- Notification
-- map("n", "<leader>N", snacks.notifier.show_history, "Show Notification History")


-- Only when not in VS Code
if not vim.g.vscode then
  -- local duck = require("duck")
  -- map('n', '<leader>dd', function ()
  --   duck.hatch("🐈")
  -- end, "Duck!")
  -- map('n', '<leader>dk', duck.cook, "Cook!")
  -- map('n', '<leader>da', duck.cook_all, "Cook 'em all!")
end
