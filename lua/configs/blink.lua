require('blink.cmp').setup {
  fuzzy = {
    implementation = 'prefer_rust'
  },
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'references', 'copilot' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      snippets = { score_offset = 1000 },
      references = {
        name = 'pandoc_references',
        module = 'blink.compat.source',
      },
      copilot = {
        name = 'copilot',
        module = 'blink-copilot',
        score_offset = 100,
        async = true,
        transform_items = function(ctx, items)
          for _, item in ipairs(items) do
            item.kind_icon = ''
            item.kind_name = 'Copilot'
          end
          return items
        end
      },
    },
  },
  snippets = { preset = 'mini_snippets' },
  signature = {
    window = { border = 'single', show_documentation = false },
  },
  cmdline = {
    keymap = {
      preset = 'inherit',
    },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = {
        auto_show = true,
      },
    },
  },
  completion = {
    trigger = {
      show_on_keyword = true,
      show_on_blocked_trigger_characters = { ' ', '\n', '\t' },
      show_on_x_blocked_trigger_characters = {},
      show_on_insert_on_trigger_character = true
    },
    ghost_text = {
      enabled = true
    },
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    keyword = {
      range = 'full',
    },
    menu = {
      direction_priority = { 'n', 's' },
      border = 'single',
      draw = {
        columns = { { 'kind_icon' }, { 'label', gap = 1 }, { 'kind' } },
        components = {
          label = {
            text = function(ctx)
              return require('colorful-menu').blink_components_text(ctx)
            end,
            -- highlight = function(ctx)
            --   return require('colorful-menu').blink_components_highlight(ctx)
            -- end,
          },
        },
      },
    },
    documentation = {
      window = { border = 'single' },
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
  keymap = {
    -- %keymap
    preset = 'none',
    ['<C-n>'] = { 'show', 'fallback' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<S-tab>'] = { 'snippet_backward', 'fallback' },
    ['<tab>'] = { 'snippet_forward', 'fallback' },
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    -- ['<leader><leader>'] = { 'show', 'fallback' }

    -- ['<leader><leader>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end }
  },
}
