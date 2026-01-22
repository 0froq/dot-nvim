local useMap = require('useMap')
if vim.g.vscode then
  return {}
end
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  lazy = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon')
    local harpoon_extensions = require('harpoon.extensions')

    harpoon:extend(harpoon_extensions.builtins.highlight_current_file())


    harpoon:setup()

    -- Harpoon mappings
    useMap.batch({
      mode = 'n',
      {
        -- Toggle harpoon buffer
        '<leader>tt',
        function()
          local marks = harpoon:list().items
          local current_file_path = vim.fn.expand('%:p:.')
          for _, item in ipairs(marks) do
            if item.value == current_file_path then
              harpoon:list():remove()
              return
            end
          end
          harpoon:list():add()

          -- Refresh incline
          require('incline').refresh()
        end,
        'Harpoon buffer',
      },
      {
        -- Show harpoon list
        '<leader>ft',
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        'Harpoon list',
      }
    })

    require('harpoon'):extend(require('harpoon.extensions').builtins.highlight_current_file())
  end,
}
