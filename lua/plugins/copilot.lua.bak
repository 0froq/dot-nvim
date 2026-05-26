if vim.g.vscode then
  return {}
end

return {
  'github/copilot.vim',
  cmd = 'Copilot',
  event = 'BufWinEnter',
  config = function()
    vim.g.copilot_no_maps = true
    -- Block the normal Copilot suggestions
    local augroup = require('autocmds').augroup

    vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
      group = augroup 'github-copilot',
      callback = function(args)
        vim.fn['copilot#On' .. args.event]()
      end,
    })
    vim.fn['copilot#OnFileType']()
  end,
}
