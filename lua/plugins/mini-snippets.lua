return {
  'nvim-mini/mini.snippets',
  version = false,
  event = { 'BufReadPost', 'BufNewFile' },
  opts = function()
    local MiniSnippets = require('mini.snippets')

    local match_strict = function(snips)
      -- Do not match with whitespace to cursor's left
      return MiniSnippets.default_match(snips, { pattern_fuzzy = '%S+' })
    end

    return {
      snippets = {
        -- gen_loader.from_runtime({})
        -- function(context)
        --   local rel_path = 'snippets/' .. context.lang .. '.json'
        --   if vim.fn.filereadable(rel_path) == 0 then return end
        --   return MiniSnippets.read_file(rel_path)
        -- end,
        MiniSnippets.gen_loader.from_lang(),

        function(context)
          local rel_path = '.snippets/' .. context.lang .. '.json'
          if vim.fn.filereadable(rel_path) == 0 then return end
          return MiniSnippets.read_file(rel_path)
        end,
      },
      mappings = {
        expand = '<C-l>',
        jump_next = '<Tab>',
        jump_prev = '<S-Tab>',
        stop = ''
      },
      expand = {
        match = match_strict
      }
    }
  end,
  config = function(_, opts)
    local MiniSnippets = require('mini.snippets')

    MiniSnippets.setup(opts)

    local make_stop = function()
      local au_opts = { pattern = '*:n', once = true }
      au_opts.callback = function()
        while MiniSnippets.session.get() do
          MiniSnippets.session.stop()
        end
      end
      vim.api.nvim_create_autocmd('ModeChanged', au_opts)
    end
    local opts = { pattern = 'MiniSnippetsSessionStart', callback = make_stop }
    vim.api.nvim_create_autocmd('User', opts)
  end
}
