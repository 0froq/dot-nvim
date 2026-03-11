if vim.g.vscode then
  return {}
end

return {
  'Daydreamer-riri/catalog-lens.nvim',
  ft = { 'json' },
  opts = function()
    return {}
  end,
}
