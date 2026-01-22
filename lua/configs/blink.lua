require("blink.cmp").setup {
  -- fuzzy = {
  --   implementation = "prefer-rust"
  -- },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer", "references" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
      snippets = { score_offset = 1000 },
      references = {
        name = "pandoc_references",
        module = "blink.compat.source",
      },
    },
  },
  snippets = { preset = "mini_snippets" },
  signature = {
    window = { border = "single", show_documentation = false },
  },
  cmdline = {
    keymap = {
      preset = "inherit",
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
    ghost_text = {
      enabled = true
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
    keyword = {
      -- range = "full",
    },
    menu = {
      border = "single",
      draw = {
        columns = { { "kind_icon" }, { "label", gap = 1 } },
        components = {
          label = {
            text = function(ctx)
              return require("colorful-menu").blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require("colorful-menu").blink_components_highlight(ctx)
            end,
          },
        },
      },
    },
    documentation = {
      window = { border = "bold" },
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
  keymap = {
    -- %keymap
    preset = "none",
    ["<CR>"] = { "accept", "fallback" },
    ["<S-tab>"] = { "snippet_backward", "fallback" },
    ["<tab>"] = { "snippet_forward", "accept", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
  },
}
