if vim.g.vscode then
  return {}
else
  return {
    'nvim-mini/mini.starter',
    version = false,
    lazy = false,
    config = function()
      local MiniStarter = require('mini.starter')

      MiniStarter.setup({
        query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789',
        items = {
          MiniStarter.sections.sessions(3, true),
          MiniStarter.sections.recent_files(5, true, true),
          -- MiniStarter.sections.builtin_actions()
        },
        footer = 'Take a rest.',
        content_hooks = {
          MiniStarter.gen_hook.adding_bullet(),
          MiniStarter.gen_hook.aligning('center', 'center')
        }
      })
    end
  }
end
