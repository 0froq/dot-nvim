if vim.g.vscode then
  return {}
end

return {
  'saghen/blink.cmp',
  event = { 'BufReadPost', 'BufNewFile' },
  version = '1.*',
  dependencies = {
    { 'xzbdmw/colorful-menu.nvim', },
    { 'saghen/blink.compat' },
    { 'fang2hou/blink-copilot' },
    { 'Kaiser-Yang/blink-cmp-avante' },
    { 'jc-doyle/cmp-pandoc-references' },
    { 'nvim-mini/mini.snippets' },
  },
  config = function()
    require 'configs.blink'
  end,
}
