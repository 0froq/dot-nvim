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
      -- {
      --   -- Show harpoon list
      --   '<leader><leader>',
      --   function()
      --     harpoon.ui:toggle_quick_menu(harpoon:list())
      --   end,
      --   'Harpoon list',
      -- }
    })

    -- basic telescope configuration
    local conf = require('telescope.config').values

    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers').new({}, {
        prompt_title = 'Harpoon',
        finder = require('telescope.finders').new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    vim.keymap.set('n', '<C-e>', function() toggle_telescope(harpoon:list()) end,
      { desc = 'Open harpoon window' })

    require('harpoon'):extend(require('harpoon.extensions').builtins.highlight_current_file())
  end,
}
