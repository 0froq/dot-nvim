return {
  'nvim-mini/mini.snippets',
  version = false,
  lazy = false,
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local MiniSnippets = require('mini.snippets')
    local map = require('utils').map

    local match_strict = function(snips)
      -- Do not match with whitespace to cursor's left
      return MiniSnippets.default_match(snips, { pattern_fuzzy = '%S+' })
    end


    MiniSnippets.setup({
      snippets = {
        -- gen_loader.from_runtime({})
        -- function(context)
        --   local rel_path = 'snippets/' .. context.lang .. '.json'
        --   if vim.fn.filereadable(rel_path) == 0 then return end
        --   return MiniSnippets.read_file(rel_path)
        -- end,
        MiniSnippets.gen_loader.from_lang(),
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
    })

    MiniSnippets.start_lsp_server({ triggers = { '..' } })
  end
}
