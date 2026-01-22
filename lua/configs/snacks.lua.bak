---@diagnostic disable: missing-fields, undefined-global
require("snacks").setup {
  styles = {
    notification = { border = "single" },
    notification_history = { border = "single", width = 0.9, height = 0.9, minimal = true },
    snacks_image = {
      border = "single",
    },
    -- Zen mode appearance
    zen = {
      enter = true,
      fixbuf = false,
      minimal = false,
      width = 120,
      height = 0,
      backdrop = { transparent = true, blend = 20 },
      keys = { q = false },
      zindex = 40,
      wo = {
        winhighlight = "NormalFloat:Normal",
      },
      w = {
        snacks_main = true,
      },
    },
  },
  statuscolumn = {},
  dashboard = require("configs.snacks-dashboard"),
  -- indent = {
  --   indent = {
  --     char = " ",
  --     -- only_scope = true,
  --     only_current = true,
  --     hl = {
  --       -- "SnacksIndent1",
  --       -- "SnacksIndent2",
  --       -- "SnacksIndent3",
  --       -- "SnacksIndent4",
  --       -- "SnacksIndent5",
  --       -- "SnacksIndent6",
  --       -- "SnacksIndent7",
  --       -- "SnacksIndent8",
  --     },
  --   },
  --   scroll = {},
  --   animate = {
  --     duration = {
  --       step = 10,
  --       duration = 100,
  --     },
  --   },
  --   scope = {
  --     enabled = true,
  --     priority = 200,
  --     char = "|",
  --     underline = false,
  --     only_current = true,
  --     hl = {
  --       "SnacksIndent1",
  --       "SnacksIndent2",
  --       "SnacksIndent3",
  --       "SnacksIndent4",
  --       "SnacksIndent5",
  --       "SnacksIndent6",
  --       "SnacksIndent7",
  --       "SnacksIndent8",
  --     },
  --   },
  -- },
  notifier = {
    top_down = false
  },
  bufdelete = {},
  explorer = {},
  image = {
    enabled = true,
    doc = {
      enabled = true,
      inline = false,
      float = true,
      max_width = 40,
      max_height = 30,
    },
  },
  picker = {
    explorer = {
      follow_file = true
    },
    sources = {
      explorer = {
        win = {
          list = {
            keys = {
              ["o"] = "confirm",
            },
          },
        },
      },
    },
    -- for each layout
    layouts = {
      -- sidebar layout
      sidebar = {
        preview = "main",
        layout = {
          backdrop = false,
          width = 30,
          min_width = 30,
          position = "left",
          box = "vertical",
          {
            win = "input",
            height = 1,
            border = "single",
            title = "{title} {live} {flags}",
            title_pos = "center",
          },
          {
            win = "list",
            border = "none",
          },
          {
            win = "preview",
            title = "{preview}",
            height = 0.4,
            border = "top",
          },
        },
      },
      -- vscode (style) layout
      vscode = {
        preview = "main",
        layout = {
          backdrop = false,
          row = 1,
          width = 0.4,
          min_width = 80,
          height = 0.6,
          box = "vertical",
          border = "single",
          {
            win = "input",
            height = 1,
            border = "bottom",
            title = "{title} {live} {flags}",
          },
          {
            win = "list",
            border = "none",
          },
          {
            win = "preview",
            title = "{preview}",
            border = "top",
          },
        },
      },
      -- default layout
      default = {
        layout = {
          box = "horizontal",
          width = 0.8,
          min_width = 120,
          height = 0.8,
          {
            box = "vertical",
            border = "single",
            title = "{title} {live} {flags}",
            { win = "input", height = 1,     border = "bottom" },
            { win = "list",  border = "none" },
          },
          { win = "preview", title = "{preview}", border = "single", width = 0.5 },
        },
      },
      -- dropdown layout
      dropdown = {
        -- preview = false,
        layout = {
          backdrop = false,
          row = 1,
          width = 0.4,
          min_width = 80,
          height = 0.8,
          border = "none",
          box = "vertical",
          { win = "preview", title = "{preview}", height = 0.4, border = "single" },
          {
            box = "vertical",
            border = "single",
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "input", height = 1,     border = "bottom" },
            { win = "list",  border = "none" },
          },
        },
      },
      -- vertical layout
      vertical = {
        layout = {
          backdrop = false,
          width = 0.5,
          min_width = 80,
          height = 0.8,
          min_height = 30,
          box = "vertical",
          {
            box = "vertical",
            border = "single",
            title = "{title} {live} {flags}",
            title_pos = "center",

            { win = "input", height = 1,     border = "bottom" },
            { win = "list",  border = "none" },
          },
          { win = "preview", title = "{preview}", height = 0.4, border = "single" },
        },
      },
      select = {
        -- preview = false,
        layout = {
          backdrop = false,
          width = 0.5,
          min_width = 80,
          height = 0.4,
          min_height = 3,
          box = "vertical",
          border = "single",
          title = "{title}",
          title_pos = "center",
          { win = "input",   height = 1,          border = "bottom" },
          { win = "list",    border = "none" },
          { win = "preview", title = "{preview}", height = 0.4,     border = "top" },
        },
      },
    },
    matcher = {
      frecency = true,
      cwd_bonus = true,
      history_bonus = true,
    },
    formatters = {
      icon_width = 3,
    },
  },
  terminal = {},
}

local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params
        .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
