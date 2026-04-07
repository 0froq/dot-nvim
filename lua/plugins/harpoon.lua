if vim.g.vscode then
  return {}
end

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local Harpoon = require('harpoon')
    local harpoon_extensions = require('harpoon.extensions')

    local useMap = require('useMap')

    Harpoon:extend(harpoon_extensions.builtins.highlight_current_file())

    Harpoon:setup()

    -- Harpoon mappings
    useMap.batch({
      mode = 'n',
      {
        -- Toggle harpoon buffer
        '<leader>tt',
        function()
          local marks = Harpoon:list().items
          local current_file_path = vim.fn.expand('%:p:.')
          for _, item in ipairs(marks) do
            if item.value == current_file_path then
              Harpoon:list():remove()
              return
            end
          end
          Harpoon:list():add()

          -- Refresh incline
          require('incline').refresh()
        end,
        'Harpoon buffer',
      },
      {
        -- Show harpoon list
        '<leader><leader><leader>',
        function()
          Harpoon.ui:toggle_quick_menu(Harpoon:list())
        end,
        'Harpoon list',
      }
    })
  end,
}
