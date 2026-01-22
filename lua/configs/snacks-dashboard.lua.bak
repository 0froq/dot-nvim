return {
  preset = {
    -- Set items in `keys` section
    keys = {
      { icon = " ", key = "<leader>ff", desc = "Files", action = ":lua Snacks.picker.smart()" },
      { icon = " ", key = "<leader>fw", desc = "Grep", action = ":lua Snacks.picker.grep()" },
      {
        icon = " ",
        key = "<leader>sl",
        desc = "Restore Session",
        action = ":lua require('persistence').load()",
      },
      { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  },
  formats = {
    key = function(item)
      return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
    end,
  },
  sections = {
    { title = "Keys",           padding = 1 },
    { section = "keys",         padding = 1 },
    { title = "MRU ",           file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
    { section = "recent_files", cwd = true,                           limit = 8,  padding = 1 },
    { title = "Projects",       padding = 1 },
    { section = "projects",     padding = 1 },
  },
}
