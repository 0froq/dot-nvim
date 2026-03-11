return {
  'nvim-mini/mini-git',
  version = false,
  event = 'VimEnter',
  config = function()
    if vim.fn.systemlist('git rev-parse --is-inside-work-tree')[1] ~= 'true' then
      return
    end
    require 'mini.git'.setup()
  end
}
