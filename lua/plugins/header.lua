local useMap = require('useMap')
return {
  'attilarepka/header.nvim',
  event = 'VeryLazy',
  opts = {
    allow_autocmds = true,
    file_name = true,
    author = 'froQ',
    project = nil,
    date_created = true,
    date_created_fmt = '%Y-%m-%d %H:%M:%S',
    date_modified = true,
    date_modified_fmt = '%Y-%m-%d %H:%M:%S',
    line_separator = nil,
    use_block_header = true,
    copyright_text = nil,
    -- license_from_file = true,
    -- author_from_git = true,
  },
  config = function(_, opts)
    local Header = require('header')

    Header.setup(opts)

    useMap.nmap('<leader>dh', Header.add_headers, { desc = 'Insert File Header' })
  end,
}
