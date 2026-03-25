return {
  'b0o/incline.nvim',
  event = { 'BufReadPost' },
  opts = {
    window = {
      placement = {
        vertical = 'top',
        horizontal = 'right',
      },
      padding = 0,
      margin = { vertical = 0, horizontal = 0 },
    },
    render = function(props)
      local palette = require('lig.colors').setup()
      local mini_icons = require('mini.icons')

      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t') or '[-]'
      local ft_icon, ft_hl = mini_icons.get('file', filename)

      local general_group = props.focused and 'TablineSel' or 'StatusLine'

      local function get_git_diff()
        -- local icons = { delete = "- ", change = "~ ", add = "+ " }
        local icons = { remove = '-', changed = '~', added = '+' }
        local hl_map = { remove = 'Delete', changed = 'Change', added = 'Add' }
        -- local sum = vim.b[props.buf].minidiff_summary
        local sum = vim.b[props.buf].gitsigns_status_dict
        local labels = {}
        if sum == nil then
          return labels
        end
        for name, icon in pairs(icons) do
          if tonumber(sum[name]) and sum[name] > 0 then
            table.insert(labels, { icon .. sum[name] .. ' ', group = 'Gitsigns' .. hl_map[name] })
          end
        end
        if #labels > 0 then
          table.insert(labels, { '/ ', group = general_group })
        end
        return labels
      end

      local function get_diagnostic_label()
        local icons = { error = 'E', warn = 'W', info = 'I', hint = 'H' }
        local label = {}

        for severity, icon in pairs(icons) do
          local n = #vim.diagnostic.get(
            props.buf,
            { severity = vim.diagnostic.severity[string.upper(severity)] }
          )
          if n > 0 then
            table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
          end
        end
        if #label > 0 then
          table.insert(label, { '/ ', group = general_group })
        end
        return label
      end

      local function get_harpoon_items()
        local harpoon = require('harpoon')
        local marks = harpoon:list().items
        local label = {}

        -- if #label > 0 then
        if #marks > 0 then
          table.insert(label, 1, { '󰛢 ', group = 'DiagnosticInfo' })
          -- set hl group
          table.insert(label, { '/ ', group = general_group })
        end
        return label
      end

      local function get_file_name()
        local label = {}
        table.insert(label, { (ft_icon or '') .. ' ', group = ft_hl })
        table.insert(
          label,
          {
            filename,
            -- guifg = vim.bo[props.buf].modified and palette.amber[2] or palette.fg_reversed,
            group = vim.bo[props.buf].modified and 'DiagnosticWarn' or general_group,
            gui = vim.bo[props.buf].modified and 'italic' or ''
          }
        )

        return label
      end

      return {
        { ' ', group = general_group },
        {
          { get_diagnostic_label() },
          { get_git_diff() },
          { get_harpoon_items() },
          { get_file_name() },
          group = general_group,
        },
        { ' ', group = general_group },
      }
    end,
  }
}
